program CM2010Project;

uses
  Forms,
  CM2010 in 'CM2010.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Charge Manager 2010 --- (c)2003 by Markus Birth';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
