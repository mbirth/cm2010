unit CM2010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CPort, ComCtrls, IniFiles, CPortCtl, DateUtils;

type
  TForm1 = class(TForm)
    COMSettings: TButton;
    MultiButt: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    L_Time: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    R_1: TRadioButton;
    R_2: TRadioButton;
    R_3: TRadioButton;
    R_4: TRadioButton;
    StatusBar: TStatusBar;
    D_1: TMemo;
    D_2: TMemo;
    D_3: TMemo;
    D_4: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    D_Stat: TMemo;
    LogButton: TButton;
    Image1: TImage;
    Label8: TLabel;
    L1: TCheckBox;
    L2: TCheckBox;
    L3: TCheckBox;
    L4: TCheckBox;
    ColorDialog: TColorDialog;
    C1: TImage;
    C2: TImage;
    C3: TImage;
    C4: TImage;
    Label9: TLabel;
    GraphDelayBar: TTrackBar;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    GraphDelayCtrl: TEdit;
    Label13: TLabel;
    DelayTimer: TTimer;
    ComPort: TComPort;
    PB_1: TProgressBar;
    PB_2: TProgressBar;
    PB_3: TProgressBar;
    PB_4: TProgressBar;
    ComLed1: TComLed;
    ComLed2: TComLed;
    ComLed3: TComLed;
    ComLed4: TComLed;
    ComLed5: TComLed;
    ComLed6: TComLed;
    ComLed7: TComLed;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    procedure COMSettingsClick(Sender: TObject);
    procedure MultiButtClick(Sender: TObject);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure ComPortRxFlag(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LogButtonClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure L2Click(Sender: TObject);
    procedure L3Click(Sender: TObject);
    procedure L4Click(Sender: TObject);
    procedure GraphDelayBarChange(Sender: TObject);
    procedure DelayTimerTimer(Sender: TObject);
    procedure GraphDelayCtrlChange(Sender: TObject);
    procedure GraphDelayCtrlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TRecords = array[1..4]of String[34];
  TBuf = array[0..33] of char;

const
  CRLF: string = Chr(13) + Chr(10);

var
  Slot: TRecords;
  GraphPos: array[1..4,1..2] of byte;
  GraphCol: array[1..4] of TColor;
  GraphDelay: integer = 60;
  GraphTime: integer;
  Sync: String[136] = '';
  InSync: boolean = true;
  LSlot: byte = 1;
  Logging: boolean = false;
  LastEvent: TDateTime = 0;
  f1,f2,f3,f4: file of byte;

procedure TForm1.COMSettingsClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;

procedure TForm1.MultiButtClick(Sender: TObject);
begin
  if ComPort.Connected then
    ComPort.Close
  else
    ComPort.Open;
end;

procedure TForm1.ComPortAfterOpen(Sender: TObject);
begin
  MultiButt.Caption := 'Stop capturing';
end;

procedure TForm1.ComPortAfterClose(Sender: TObject);
var i: integer;
begin
  InSync := true;
  Sync := '';
  LSlot := 1;
  for i:=1 to 4 do Slot[i] := '';
  MultiButt.Caption := 'Start capturing';
end;

function ShowHex(x: byte): string;
const hset: string = '0123456789abcdef';
begin
  ShowHex := hset[(x DIV 16)+1]+hset[(x MOD 16)+1];
end;

function BuildHex(x: string): string;
var i: integer;
    t: string;
begin
  t := '';
  for i:=1 to Length(x) do t := t + ShowHex(Ord(x[i])) + ' ';
  BuildHex := t;
end;

function GetVolts(s: byte): word;
begin
  GetVolts := Ord(Slot[s][16])*256+Ord(Slot[s][17]);
end;

function GetAmps(s: byte): word;
begin
  GetAmps := Ord(Slot[s][14])*256+Ord(Slot[s][15]);
end;

function GetCCap(s: byte): dword;
begin
  GetCCap := Ord(Slot[s][18])*65536+Ord(Slot[s][19])*256+Ord(Slot[s][20]);
end;

function GetDCap(s: byte): dword;
begin
  GetDCap := Ord(Slot[s][21])*65536+Ord(Slot[s][22])*256+Ord(Slot[s][23]);
end;

function GetHours(s: byte): byte;
begin
  GetHours := Ord(Slot[s][6]);
end;

function GetMinutes(s: byte): byte;
begin
  GetMinutes := Ord(Slot[s][7]);
end;

function GetProgress(s: byte): byte;
begin
  Result := 0;
  if (ShowHex(Ord(Slot[s][3]))[2]<>'0') then begin
    case ShowHex(Ord(Slot[s][2]))[2] of
      '8': case ShowHex(Ord(Slot[s][3]))[2] of
             '5': Result := 50;
             '7','8': Result := 100;
           end;
      '9': case ShowHex(Ord(Slot[s][3]))[2] of
             '6': Result := 50;
             '7','8': Result := 100;
           end;
      'a': case ShowHex(Ord(Slot[s][3]))[2] of
             '4': Result := 33;
             '5': Result := 66;
             '7','8': Result := 100;
           end;
      'b': case ShowHex(Ord(Slot[s][3]))[2] of
             '3': Result := 25;
             '4': Result := 50;
             '5': Result := 75;
             '7','8': Result := 100;
           end;
      'c': case ShowHex(Ord(Slot[s][3]))[2] of
             '1': Result := 16;
             '2': Result := 33;
             '3': Result := 50;
             '4': Result := 66;
             '5': Result := 83;
             '7','8': Result := 100;
           end;
       'd','e','f': Result := 100;
    end;
  end else Result := 0;
end;

function FormatCaps(c: dword): string;
var t: string;
begin
  t := IntToStr(c);
  if (c<=100000) then t := Copy(t,1,Length(t)-2) + '.' + Copy(t,Length(t)-1,1) else t := Copy(t,1,Length(t)-2);
  if t[1]='.' then t := '0' + t;
  while Length(t)<5 do t := ' '+t;
  FormatCaps := t;
end;

function FormatTime(s: byte): string;
var t: string;
begin
  if (ShowHex(Ord(Slot[s][2]))[2]<>'0') then begin
    if GetHours(s)<10 then t := '0' + IntToStr(GetHours(s)) + ':' else t := IntToStr(GetHours(s)) + ':';
    if GetMinutes(s)<10 then t := t + '0' + IntToStr(GetMinutes(s)) else t := t + IntToStr(GetMinutes(s));
  end else t := '--:--';
  FormatTime := t;
end;

function FormatUI(v: dword): string;
var t: string;
begin
  if v>0 then begin
    t := IntToStr(v);
    while Length(t)<4 do t := '0' + t;
    t := Copy(t,1,Length(t)-3) + '.' + Copy(t,Length(t)-2,2);
    if t[1]='.' then t := '0' + t;
  end else t := '----';
  while Length(t)<7 do t := ' '+t;
  FormatUI := t;
end;

function GetAutoMan(s: byte): string;
begin
  if ShowHex(Ord(Slot[s][2]))[2]<>'0' then begin
    if ShowHex(Ord(Slot[s][3]))[1]='0' then GetAutoMan := 'AUTO' else GetAutoMan := 'MAN ';
  end else GetAutoMan := '----';
end;

function GetTriAction(s: byte): string;
begin
  case ShowHex(Ord(Slot[s][2]))[2] of
    '0': GetTriAction := '---';
    '8': GetTriAction := 'CHA';
    '9': GetTriAction := 'DIS';
    'a': GetTriAction := 'CHK';
    'b': GetTriAction := 'CYC';
    'c': GetTriAction := 'ALV';
    'd': GetTriAction := 'RDY';
    'e': GetTriAction := 'ERR';
    'f': GetTriAction := 'TRI';
   else
     GetTriAction := '???';
   end;
end;

procedure LoadSettings;
var cf: TIniFile;
begin
  try
    cf := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
    Form1.AlphaBlendValue := cf.ReadInteger('Window','AlphaValue',255);
    Form1.AlphaBlend := cf.ReadBool('Window','AlphaBlend',false);

    with Form1 do begin
      ComPort.Port := cf.ReadString('Communication','Port','COM1');
      ComPort.BaudRate := StrToBaudRate(cf.ReadString('Communication','BaudRate','9600'));
      ComPort.DataBits := StrToDataBits(cf.ReadString('Communication','DataBits','8'));
      ComPort.StopBits := StrToStopBits(cf.ReadString('Communication','StopBits','1'));
      ComPort.Parity.Bits := StrToParity(cf.ReadString('Communication','Parity','None'));
      ComPort.Parity.Check := cf.ReadBool('Communication','Parity.Check',false);
      ComPort.Parity.Replace := cf.ReadBool('Communication','Parity.Replace',false);
      ComPort.Parity.ReplaceChar := Chr(cf.ReadInteger('Communication','Parity.ReplaceChar',0));
      ComPort.FlowControl.FlowControl := StrToFlowControl(cf.ReadString('Communication','FlowControl','Custom'));
      ComPort.FlowControl.ControlDTR := TDTRFlowControl(cf.ReadInteger('Communication','FlowControl.DTR',1));
      ComPort.FlowControl.ControlRTS := TRTSFlowControl(cf.ReadInteger('Communication','FlowControl.RTS',0));
      ComPort.FlowControl.DSRSensitivity := cf.ReadBool('Communication','FlowControl.DSRSensitivity',false);
      ComPort.FlowControl.OutCTSFlow := cf.ReadBool('Communication','FlowControl.OutCTSFlow',false);
      ComPort.FlowControl.OutDSRFlow := cf.ReadBool('Communication','FlowControl.OutDSRFlow',false);
      ComPort.FlowControl.TxContinueOnXoff := cf.ReadBool('Communication','FlowControl.TxContinueOnXoff',false);
      ComPort.FlowControl.XoffChar := Chr(cf.ReadInteger('Communication','FlowControl.XoffChar',19));
      ComPort.FlowControl.XonChar := Chr(cf.ReadInteger('Communication','FlowControl.XonChar',17));
      ComPort.FlowControl.XonXoffIn := cf.ReadBool('Communication','FlowControl.XonXoffIn',false);
      ComPort.FlowControl.XonXoffOut := cf.ReadBool('Communication','FlowControl.XonXoffOut',false);
    end;

    GraphDelay := cf.ReadInteger('Slots','GraphDelay',60);
    Form1.GraphDelayBar.Position := 300-GraphDelay;
    Form1.GraphDelayCtrl.Text := IntToStr(GraphDelay);
    GraphCol[1] := TColor(cf.ReadInteger('Slots','1.Color',16711680));
    GraphCol[2] := TColor(cf.ReadInteger('Slots','2.Color',255));
    GraphCol[3] := TColor(cf.ReadInteger('Slots','3.Color',32768));
    GraphCol[4] := TColor(cf.ReadInteger('Slots','4.Color',16711935));

    cf.Free;
  except
    on E: Exception do ShowMessage('ERROR: Could not read settings from ini-file!'+CRLF+'('+E.Message+')');
  end;
end;

procedure SaveSettings;
var cf: TIniFile;
begin
  try
    cf := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
    with Form1 do begin
      cf.WriteString('Communication', 'Port', ComPort.Port);
      cf.WriteString('Communication', 'BaudRate', BaudRateToStr(ComPort.BaudRate));
      cf.WriteString('Communication', 'DataBits', DataBitsToStr(ComPort.DataBits));
      cf.WriteString('Communication', 'StopBits', StopBitsToStr(ComPort.StopBits));
      cf.WriteString('Communication', 'Parity', ParityToStr(ComPort.Parity.Bits));
      cf.WriteBool('Communication', 'Parity.Check', ComPort.Parity.Check);
      cf.WriteBool('Communication', 'Parity.Replace', ComPort.Parity.Replace);
      cf.WriteInteger('Communication', 'Parity.ReplaceChar', Ord(ComPort.Parity.ReplaceChar));
      cf.WriteString('Communication', 'FlowControl', FlowControlToStr(ComPort.FlowControl.FlowControl));
      cf.WriteInteger('Communication', 'FlowControl.DTR', Ord(ComPort.FlowControl.ControlDTR));
      cf.WriteInteger('Communication', 'FlowControl.RTS', Ord(ComPort.FlowControl.ControlRTS));
      cf.WriteBool('Communication', 'FlowControl.DSRSensitivity', ComPort.FlowControl.DSRSensitivity);
      cf.WriteBool('Communication', 'FlowControl.OutCTSFlow', ComPort.FlowControl.OutCTSFlow);
      cf.WriteBool('Communication', 'FlowControl.OutDSRFlow', ComPort.FlowControl.OutDSRFlow);
      cf.WriteBool('Communication', 'FlowControl.TxContinueOnXoff', ComPort.FlowControl.TxContinueOnXoff);
      cf.WriteInteger('Communication' ,'FlowControl.XoffChar', Ord(ComPort.FlowControl.XoffChar));
      cf.WriteInteger('Communication', 'FlowControl.XonChar', Ord(ComPort.FlowControl.XonChar));
      cf.WriteBool('Communication', 'FlowControl.XonXoffIn', ComPort.FlowControl.XonXoffIn);
      cf.WriteBool('Communication', 'FlowControl.XonXoffOut', ComPort.FlowControl.XonXoffOut);
    end;

    cf.WriteInteger('Slots','GraphDelay',GraphDelay);
    cf.WriteInteger('Slots','1.Color',Ord(GraphCol[1]));
    cf.WriteInteger('Slots','2.Color',Ord(GraphCol[2]));
    cf.WriteInteger('Slots','3.Color',Ord(GraphCol[3]));
    cf.WriteInteger('Slots','4.Color',Ord(GraphCol[4]));

    cf.Free;
  except
    on E: Exception do ShowMessage('ERROR: Could not write settings to ini-file!'+CRLF+'('+E.Message+')');
  end;
end;

procedure DoStatDisp(m: TMemo);
var t: string;
begin
  t :=     ' CHARGE MANAGER ' + CRLF;
  t := t + '================' + CRLF;
  t := t + '1:' + GetTriAction(1) + '    3:' + GetTriAction(3) + CRLF;
  t := t + '2:' + GetTriAction(2) + '    4:' + GetTriAction(4);
  if (t<>m.Text) then m.Text := t;
end;

procedure DoValDisp(s: byte; m: TMemo);
var b3,c,d: char;
var t: string;
begin
  b3 := ShowHex(Ord(Slot[s][3]))[2];
  c := ' ';
  d := ' ';
  case b3 of
    '1','3','5','7': c := '»';
    '2','4','6': d := '»';
  end;
  t := IntToStr(s) + ':' + GetTriAction(s) + c + 'C=' + FormatCaps(GetCCap(s)) + 'mAh' + CRLF;
  t := t + GetAutoMan(s) + ' ' + d + 'D=' + FormatCaps(GetDCap(s)) + 'mAh' + CRLF;
  t := t + '      U=' + FormatUI(GetVolts(s)) + 'V' + CRLF;
  t := t + FormatTime(s) + ' I=' + FormatUI(GetAmps(s)) + 'A';
  if (t<>m.Text) then m.Text := t;
end;

procedure DoEmptyDisp(s: byte; m: TMemo);
var t: string;
begin
  t := IntToStr(s) + ':';
  if (m.Text<>t) then m.Text := t;
end;

procedure DoAccuSettings(s: byte; m: TMemo; w1, w2: string);
var t: string;
begin
  t := ' ACCU- SETTINGS ' + CRLF;
  t := t + '================' + CRLF;
  t := t + IntToStr(s) + ':  ' + w1 + CRLF;
  t := t + w2;
  if (m.Text<>t) then m.Text := t;
end;

procedure DoDisplay(s: byte; m: TMemo);
var b2,b3,b4: string[2];
begin
  b2 := ShowHex(Ord(Slot[s][2]));
  b3 := ShowHex(Ord(Slot[s][3]));
  b4 := ShowHex(Ord(Slot[s][4]));
  if (b2+b3='0000') then begin
    DoEmptyDisp(s, m);
    m.Enabled := false;
  end else if (b2+b3='0100') then begin
    DoAccuSettings(s, m, 'SET AUTO/MAN', '  » AUTOMATIC');
    m.Enabled := true;
  end else if (b2+b3='0200') then begin
    DoAccuSettings(s, m, 'SET AUTO/MAN', '  » MANUAL');
    m.Enabled := true;
  end else if (b2+b3='0210') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','»  100-  200 mAh');
    m.Enabled := true;
  end else if (b2+b3='0220') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','»  200-  350 mAh');
    m.Enabled := true;
  end else if (b2+b3='0230') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','»  350-  600 mAh');
    m.Enabled := true;
  end else if (b2+b3='0240') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','»  600-  900 mAh');
    m.Enabled := true;
  end else if (b2+b3='0250') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','»  900- 1200 mAh');
    m.Enabled := true;
  end else if (b2+b3='0260') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','» 1200- 1500 mAh');
    m.Enabled := true;
  end else if (b2+b3='0270') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','» 1500- 2200 mAh');
    m.Enabled := true;
  end else if (b2+b3='0280') then begin
    DoAccuSettings(s, m, 'SET CAPACITY','» 2200- ...  mAh');
    m.Enabled := true;
  end else if (b2='03') then begin
    DoAccuSettings(s, m, 'SET PROGRAM', '  » CHARGE');
    m.Enabled := true
  end else if (b2='04') then begin
    DoAccuSettings(s, m, 'SET PROGRAM', '  » DISCHARGE');
    m.Enabled := true
  end else if (b2='05') then begin
    DoAccuSettings(s, m, 'SET PROGRAM', '  » CHECK');
    m.Enabled := true
  end else if (b2='06') then begin
    DoAccuSettings(s, m, 'SET PROGRAM', '  » CYCLE');
    m.Enabled := true
  end else if (b2='07') then begin
    DoAccuSettings(s, m, 'SET PROGRAM', '  » ALIVE');
    m.Enabled := true
  end else begin
    DoValDisp(s, m);
    m.Enabled := true;
  end;
end;

function MakeBuf(s: integer): TBuf;
var i: integer;
begin
  for i:=1 to 34 do Result[i-1] := Slot[s][i];
end;

procedure DoLog(s: byte);
var Buf: TBuf;
begin
  with Form1 do begin
    case s of
      1: if L1.Checked then begin
           Buf := MakeBuf(1);
           BlockWrite(f1,Buf,34);
         end;
      2: if L2.Checked then begin
           Buf := MakeBuf(2);
           BlockWrite(f2,Buf,34);
         end;
      3: if L3.Checked then begin
           Buf := MakeBuf(3);
           BlockWrite(f3,Buf,34);
         end;
      4: if L4.Checked then begin
           Buf := MakeBuf(4);
           BlockWrite(f4,Buf,34);
         end;
    end;
  end;
end;

procedure GraphClear(Image: TImage);
const linespace: integer = 50;   // horizontal helping lines (50 = 0,5V)
      minspace: integer = 30;    // vertical helping lines (30 = 30min)
var GH, GW, i: integer;
begin
  GH := Image.Height - 2;
  GW := Image.Width - 2;
  Image.Canvas.Brush.Color := clWindow;
  Image.Canvas.Brush.Style := bsSolid;
  Image.Canvas.Pen.Color := clBlack;
  Image.Canvas.FillRect(Rect(0,0,Image.Width,Image.Height));
  Image.Canvas.Rectangle(0,0,Image.Width,Image.Height);
  Image.Canvas.Pen.Color := clSilver;
  for i:=1 to (GH DIV linespace) do begin
    Image.Canvas.MoveTo(1,1+GH-linespace*i);
    Image.Canvas.LineTo(GW+1,1+GH-linespace*i);
  end;
  for i:=1 to (GW DIV minspace) do begin
    Image.Canvas.MoveTo(minspace*i,1);
    Image.Canvas.LineTo(minspace*i,GH+1);
  end;
end;

procedure PaintGraph(Image: TImage; Slot: integer);
var t: string;
    y: integer;
    GW, GH: integer;
begin
  GW := Image.Width - 2;
  GH := Image.Height - 2;
  if Slot=1 then begin
    Image.Canvas.CopyRect(Rect(1,1,GW,GH+1),Image.Canvas,Rect(2,1,GW+1,GH+1));
    Image.Canvas.Pen.Color := clWindow;
    Image.Canvas.Brush.Color := clWindow;
    Image.Canvas.Brush.Style := bsSolid;
    Image.Canvas.FillRect(Rect(GW,1,GW+1,GH+1));
    Image.Canvas.Pixels[GW,GH+1-50] := clSilver;   // 0,5V-Mark
    Image.Canvas.Pixels[GW,GH+1-100]  := clSilver; // 1,0V-Mark
    Image.Canvas.Pixels[GW,GH+1-150]  := clSilver; // 1,5V-Mark
  end;
  Image.Canvas.Pen.Color := GraphCol[Slot];
  if Abs(GraphPos[Slot,1]-GraphPos[Slot,2])>=50 then begin
    Image.Canvas.Font.Name := 'Small Fonts';
    Image.Canvas.Font.Size := 7;
    Image.Canvas.Font.Color := GraphCol[Slot];
    t := TimeToStr(time);
    y := GraphPos[Slot,2]-Image.Canvas.TextHeight(t) DIV 2;
    if y>Image.Height-Image.Canvas.TextHeight(t)-1 then y := Image.Height-Image.Canvas.TextHeight(t)-1;
    Image.Canvas.TextOut(GW-2-Image.Canvas.TextWidth(t),y,t);
  end;
  if (GraphPos[Slot,1]<GH) then Image.Canvas.MoveTo(GW-1,GraphPos[Slot,1]) else Image.Canvas.MoveTo(GW,GraphPos[Slot,2]);
  if (GraphPos[Slot,2]<GH) then begin
    Image.Canvas.LineTo(GW,GraphPos[Slot,2]);
    Image.Canvas.Pixels[GW,GraphPos[Slot,2]] := GraphCol[Slot];
  end;
end;

procedure DoGraphDisp(Image: TImage; Slot: integer);
begin
  GraphPos[Slot,1] := GraphPos[Slot,2];
  GraphPos[Slot,2] := Image.Height-2-GetVolts(Slot) DIV 10;
  PaintGraph(Image, Slot);
end;

function MSBetween(t1, t2: TDateTime): integer;
var r: double;
begin
  if t2>t1 then r := t2-t1 else r := t1-t2;
  result := Trunc(r * 86400000);
end;

procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
var str: string;
    i: integer;
begin
  if MSBetween(now, LastEvent)>400 then begin
    StatusBar.SimpleText := 'Signal timed out. Resynching';
    LastEvent := now;
    InSync := true;
  end;
  ComPort.ReadStr(str, Count);
  for i:=1 to Count do begin
    if InSync then begin
      if Length(Sync)=0 then StatusBar.SimpleText := 'Waiting for SyncBuffer to fill';
      if Length(Sync)<136 then begin
        Sync := Sync + str[i];
        StatusBar.SimpleText := StatusBar.SimpleText + '.';
      end else begin
        if StatusBar.SimpleText[1]<>'S' then StatusBar.SimpleText := 'Synchronizing';
        Sync := Copy(Sync,2,Length(Sync)) + Str[i];
        StatusBar.SimpleText := StatusBar.SimpleText + '.';
        if (Ord(Sync[1])=1) AND (Ord(Sync[35])=2) AND (Ord(Sync[69])=3) AND (Ord(Sync[103])=4) then begin
          StatusBar.SimpleText := StatusBar.SimpleText + 'done.';
          InSync := false;
          LSlot := 1;
          R_1.Checked := true;
        end;
      end;
    end else begin
      if Length(Slot[LSlot])>=34 then Slot[LSlot] := '';
      Slot[LSlot] := Slot[LSlot] + Str[i];
      if Length(Slot[LSlot])>=34 then begin
        case LSlot of
          1: R_1.Checked := false;
          2: R_2.Checked := false;
          3: R_3.Checked := false;
          4: R_4.Checked := false;
        end;
        if (Ord(Slot[LSlot][1])<>LSlot) then begin
          StatusBar.SimpleText := 'Synchronization lost. Resynching';
          InSync := true;
          LastEvent := now;
//          Sync := '';
        end;
        case LSlot of
          1: begin
               Edit1.Text := BuildHex(Slot[1]);
               DoDisplay(1, D_1);
               PB_1.Position := GetProgress(1);
               DoLog(1);
             end;
          2: begin
               Edit2.Text := BuildHex(Slot[2]);
               DoDisplay(2, D_2);
               PB_2.Position := GetProgress(2);
               DoLog(2);
             end;
          3: begin
               Edit3.Text := BuildHex(Slot[3]);
               DoDisplay(3, D_3);
               PB_3.Position := GetProgress(3);
               DoLog(3);
             end;
          4: begin
               Edit4.Text := BuildHex(Slot[4]);
               DoDisplay(4, D_4);
               PB_4.Position := GetProgress(4);
               DoLog(4);
             end;
        end;
        Inc(LSlot);
        if LSlot>4 then LSlot := 1;
        if (LSlot=1) AND (GraphTime>=GraphDelay) then begin
          DoGraphDisp(Image1, 1);
          DoGraphDisp(Image1, 2);
          DoGraphDisp(Image1, 3);
          DoGraphDisp(Image1, 4);
          GraphTime := 0;
        end;
        if (LSlot=1) then begin
          Inc(GraphTime);
          DoStatDisp(D_Stat);
        end;
        case LSlot of
          1: R_1.Checked := true;
          2: R_2.Checked := true;
          3: R_3.Checked := true;
          4: R_4.Checked := true;
        end;
      end;
    end;
  end;
end;

procedure TForm1.ComPortRxFlag(Sender: TObject);
begin
  L_Time.Caption := TimeToStr(time);
  LastEvent := now;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ComPort.Connected then ComPort.Close;
  SaveSettings;
end;

procedure UpdateColors;
begin
  Form1.C1.Canvas.Brush.Color := GraphCol[1];
  Form1.C1.Canvas.Brush.Style := bsSolid;
  Form1.C1.Canvas.FillRect(Rect(0,0,100,100));

  Form1.C2.Canvas.Brush.Color := GraphCol[2];
  Form1.C2.Canvas.Brush.Style := bsSolid;
  Form1.C2.Canvas.FillRect(Rect(0,0,100,100));

  Form1.C3.Canvas.Brush.Color := GraphCol[3];
  Form1.C3.Canvas.Brush.Style := bsSolid;
  Form1.C3.Canvas.FillRect(Rect(0,0,100,100));

  Form1.C4.Canvas.Brush.Color := GraphCol[4];
  Form1.C4.Canvas.Brush.Style := bsSolid;
  Form1.C4.Canvas.FillRect(Rect(0,0,100,100));
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
  LoadSettings;
  UpdateColors;
  GraphClear(Image1);
  GraphTime := GraphDelay;
  for i:=1 to 4 do begin
    GraphPos[i,1] := Image1.Height - 2;
    GraphPos[i,2] := Image1.Height - 2;
  end;
end;

procedure TForm1.LogButtonClick(Sender: TObject);
begin
  if (NOT L1.Checked) AND (NOT L2.Checked) AND (NOT L3.Checked) AND (NOT L4.Checked) then begin
    L1.Checked := true;
    L2.Checked := true;
    L3.Checked := true;
    L4.Checked := true;
    LogButton.Caption := 'Stop logging';
  end else begin
    L1.Checked := false;
    L2.Checked := false;
    L3.Checked := false;
    L4.Checked := false;
    LogButton.Caption := 'Start logging';
  end;
end;

procedure TForm1.C1Click(Sender: TObject);
begin
  ColorDialog.Color := GraphCol[1];
  ColorDialog.Execute;
  GraphCol[1] := ColorDialog.Color;
  UpdateColors;
end;

procedure TForm1.C2Click(Sender: TObject);
begin
  ColorDialog.Color := GraphCol[2];
  ColorDialog.Execute;
  GraphCol[2] := ColorDialog.Color;
  UpdateColors;
end;

procedure TForm1.C3Click(Sender: TObject);
begin
  ColorDialog.Color := GraphCol[3];
  ColorDialog.Execute;
  GraphCol[3] := ColorDialog.Color;
  UpdateColors;
end;

procedure TForm1.C4Click(Sender: TObject);
begin
  ColorDialog.Color := GraphCol[4];
  ColorDialog.Execute;
  GraphCol[4] := ColorDialog.Color;
  UpdateColors;
end;

procedure StartStopCheck;
begin
  if (Form1.L1.Checked) OR (Form1.L2.Checked) OR (Form1.L3.Checked) OR (Form1.L4.Checked) then
    Form1.LogButton.Caption := 'Stop logging'
  else
    Form1.LogButton.Caption := 'Start logging';
end;

function GetDateTimeString(): string;
var y,m,d,h,i,s,ms: word;
begin
  DecodeDateTime(now,y,m,d,h,i,s,ms);
  Result := '';
  Result := Result + IntToStr(y);
  if (m<10) then Result := Result + '0';
  Result := Result + IntToStr(m);
  if (d<10) then Result := Result + '0';
  Result := Result + IntToStr(d);
  if (h<10) then Result := Result + '0';
  Result := Result + IntToStr(h);
  if (i<10) then Result := Result + '0';
  Result := Result + IntToStr(i);
  if (s<10) then Result := Result + '0';
  Result := Result + IntToStr(s);
end;

procedure TForm1.L1Click(Sender: TObject);
begin
  StartStopCheck;
  if (L1.Checked) then begin
    AssignFile(f1,'Slot01_'+GetDateTimeString()+'.log');
    Rewrite(f1);
  end else begin
    CloseFile(f1);
  end;
end;

procedure TForm1.L2Click(Sender: TObject);
begin
  StartStopCheck;
  if (L2.Checked) then begin
    AssignFile(f2,'Slot02_'+GetDateTimeString()+'.log');
    Rewrite(f2);
  end else begin
    CloseFile(f2);
  end;
end;

procedure TForm1.L3Click(Sender: TObject);
begin
  StartStopCheck;
  if (L3.Checked) then begin
    AssignFile(f3,'Slot03_'+GetDateTimeString()+'.log');
    Rewrite(f3);
  end else begin
    CloseFile(f3);
  end;
end;

procedure TForm1.L4Click(Sender: TObject);
begin
  StartStopCheck;
  if (L4.Checked) then begin
    AssignFile(f4,'Slot04_'+GetDateTimeString()+'.log');
    Rewrite(f4);
  end else begin
    CloseFile(f4);
  end;
end;

procedure TForm1.GraphDelayBarChange(Sender: TObject);
begin
  GraphDelay := 300-GraphDelayBar.Position;
  GraphDelayCtrl.Text := IntToStr(GraphDelay);
end;

procedure TForm1.DelayTimerTimer(Sender: TObject);
begin
  GraphDelayCtrl.Text := IntToStr(300-GraphDelayBar.Position);
end;

procedure TForm1.GraphDelayCtrlChange(Sender: TObject);
begin
  DelayTimer.Enabled := false;
  DelayTimer.Enabled := true;
end;

procedure TForm1.GraphDelayCtrlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var x: integer;
begin
  if (Key=VK_RETURN) then begin
    try
      x := StrToInt(GraphDelayCtrl.Text);
    except
      GraphDelayCtrl.Text := '##';
      x := 300-GraphDelayBar.Position;
    end;
    if (x>0) then GraphDelayBar.Position := 300-x else GraphDelayCtrl.Text := '##';
  end;
end;


end.

