object Form1: TForm1
  Left = 195
  Top = 109
  Width = 716
  Height = 477
  Caption = 
    'Charge Manager 2010 --- (c)2003 by Markus Birth <mbirth@webwrite' +
    'rs.de>'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 128
    Top = 0
    Width = 12
    Height = 13
    Caption = '05'
  end
  object Label3: TLabel
    Left = 201
    Top = 1
    Width = 12
    Height = 13
    Caption = '10'
  end
  object Label4: TLabel
    Left = 275
    Top = 0
    Width = 12
    Height = 13
    Caption = '15'
  end
  object Label5: TLabel
    Left = 351
    Top = 0
    Width = 12
    Height = 13
    Caption = '20'
  end
  object Label6: TLabel
    Left = 427
    Top = 0
    Width = 12
    Height = 13
    Caption = '25'
  end
  object Label7: TLabel
    Left = 501
    Top = 1
    Width = 12
    Height = 13
    Caption = '30'
  end
  object Image1: TImage
    Left = 8
    Top = 264
    Width = 602
    Height = 162
  end
  object C1: TImage
    Left = 344
    Top = 128
    Width = 17
    Height = 17
    OnClick = C1Click
  end
  object C2: TImage
    Left = 344
    Top = 200
    Width = 17
    Height = 17
    OnClick = C2Click
  end
  object C3: TImage
    Left = 544
    Top = 128
    Width = 17
    Height = 17
    OnClick = C3Click
  end
  object C4: TImage
    Left = 544
    Top = 200
    Width = 17
    Height = 17
    OnClick = C4Click
  end
  object Label9: TLabel
    Left = 8
    Top = 0
    Width = 48
    Height = 13
    Caption = 'Raw Data'
  end
  object Label10: TLabel
    Left = 672
    Top = 259
    Width = 22
    Height = 13
    Caption = '5min'
  end
  object Label11: TLabel
    Left = 673
    Top = 408
    Width = 23
    Height = 13
    Caption = '1sec'
  end
  object Label12: TLabel
    Left = 671
    Top = 379
    Width = 22
    Height = 13
    Caption = '1min'
  end
  object Label8: TLabel
    Left = 612
    Top = 259
    Width = 34
    Height = 13
    Caption = '- 1,60V'
  end
  object Label13: TLabel
    Left = 616
    Top = 388
    Width = 22
    Height = 13
    Caption = 'secs'
  end
  object GraphDelayBar: TTrackBar
    Left = 648
    Top = 256
    Width = 25
    Height = 169
    Ctl3D = True
    Max = 299
    Orientation = trVertical
    ParentCtl3D = False
    PageSize = 10
    Frequency = 30
    Position = 240
    TabOrder = 22
    ThumbLength = 15
    OnChange = GraphDelayBarChange
  end
  object L1: TCheckBox
    Left = 344
    Top = 112
    Width = 41
    Height = 17
    Caption = 'Log'
    TabOrder = 17
    OnClick = L1Click
  end
  object COMSettings: TButton
    Left = 592
    Top = 16
    Width = 113
    Height = 25
    Caption = 'COM Port Settings...'
    TabOrder = 0
    OnClick = COMSettingsClick
  end
  object MultiButt: TButton
    Left = 592
    Top = 48
    Width = 113
    Height = 25
    Caption = 'Start capturing'
    TabOrder = 1
    OnClick = MultiButtClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 185
    Height = 73
    Caption = 'COM Status'
    TabOrder = 2
    object Label1: TLabel
      Left = 30
      Top = 16
      Width = 71
      Height = 13
      Caption = 'Last character:'
    end
    object L_Time: TLabel
      Left = 110
      Top = 16
      Width = 73
      Height = 13
      AutoSize = False
      Caption = 'hh:mm:ss'
    end
    object ComLed1: TComLed
      Left = 0
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsConn
      Kind = lkYellowLight
    end
    object ComLed2: TComLed
      Left = 24
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsCTS
      Kind = lkBlueLight
    end
    object ComLed3: TComLed
      Left = 48
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsDSR
      Kind = lkRedLight
    end
    object ComLed4: TComLed
      Left = 88
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsRing
      Kind = lkPurpleLight
    end
    object ComLed5: TComLed
      Left = 112
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsRLSD
      Kind = lkRedLight
    end
    object ComLed6: TComLed
      Left = 144
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsRx
      Kind = lkGreenLight
    end
    object ComLed7: TComLed
      Left = 160
      Top = 32
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsTx
      Kind = lkRedLight
    end
    object Label14: TLabel
      Left = 150
      Top = 54
      Width = 13
      Height = 13
      Caption = 'Rx'
    end
    object Label15: TLabel
      Left = 167
      Top = 54
      Width = 12
      Height = 13
      Caption = 'Tx'
    end
    object Label16: TLabel
      Left = 114
      Top = 56
      Width = 21
      Height = 10
      Caption = 'RLSD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 92
      Top = 56
      Width = 17
      Height = 10
      Caption = 'Ring'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 52
      Top = 56
      Width = 17
      Height = 10
      Caption = 'DSR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 28
      Top = 56
      Width = 16
      Height = 10
      Caption = 'CTS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 3
      Top = 56
      Width = 19
      Height = 10
      Caption = 'Conn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
  end
  object Edit1: TEdit
    Left = 64
    Top = 16
    Width = 521
    Height = 20
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = 
      '01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 2' +
      '2 23 24 25 26 27 28 29 30 31 32 33 34'
  end
  object Edit2: TEdit
    Left = 64
    Top = 40
    Width = 521
    Height = 20
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = 
      '01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 2' +
      '2 23 24 25 26 27 28 29 30 31 32 33 34'
  end
  object Edit3: TEdit
    Left = 64
    Top = 64
    Width = 521
    Height = 20
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = 
      '01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 2' +
      '2 23 24 25 26 27 28 29 30 31 32 33 34'
  end
  object Edit4: TEdit
    Left = 64
    Top = 88
    Width = 521
    Height = 20
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = 
      '01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 2' +
      '2 23 24 25 26 27 28 29 30 31 32 33 34'
  end
  object R_1: TRadioButton
    Left = 8
    Top = 16
    Width = 49
    Height = 17
    Caption = 'Slot 1'
    Enabled = False
    TabOrder = 7
  end
  object R_2: TRadioButton
    Left = 8
    Top = 40
    Width = 49
    Height = 17
    Caption = 'Slot 2'
    Enabled = False
    TabOrder = 8
  end
  object R_3: TRadioButton
    Left = 8
    Top = 64
    Width = 49
    Height = 17
    Caption = 'Slot 3'
    Enabled = False
    TabOrder = 9
  end
  object R_4: TRadioButton
    Left = 8
    Top = 88
    Width = 49
    Height = 17
    Caption = 'Slot 4'
    Enabled = False
    TabOrder = 10
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 431
    Width = 708
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object D_1: TMemo
    Left = 200
    Top = 112
    Width = 137
    Height = 71
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '1:')
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
  end
  object D_2: TMemo
    Left = 200
    Top = 184
    Width = 137
    Height = 71
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '2:')
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
  end
  object D_3: TMemo
    Left = 400
    Top = 112
    Width = 137
    Height = 71
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '3:')
    ParentFont = False
    ReadOnly = True
    TabOrder = 13
  end
  object D_4: TMemo
    Left = 400
    Top = 184
    Width = 137
    Height = 71
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '4:')
    ParentFont = False
    ReadOnly = True
    TabOrder = 14
  end
  object D_Stat: TMemo
    Left = 8
    Top = 112
    Width = 137
    Height = 71
    Color = clLime
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      ' CHARGE MANAGER'
      '================'
      '1:---    3:---'
      '2:---    4:---')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 15
  end
  object LogButton: TButton
    Left = 592
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Start logging'
    TabOrder = 16
    OnClick = LogButtonClick
  end
  object L2: TCheckBox
    Left = 344
    Top = 184
    Width = 41
    Height = 17
    Caption = 'Log'
    TabOrder = 18
    OnClick = L2Click
  end
  object L3: TCheckBox
    Left = 544
    Top = 112
    Width = 41
    Height = 17
    Caption = 'Log'
    TabOrder = 19
    OnClick = L3Click
  end
  object L4: TCheckBox
    Left = 544
    Top = 184
    Width = 41
    Height = 17
    Caption = 'Log'
    TabOrder = 20
    OnClick = L4Click
  end
  object GraphDelayCtrl: TEdit
    Left = 616
    Top = 400
    Width = 25
    Height = 21
    TabOrder = 23
    Text = '60'
    OnChange = GraphDelayCtrlChange
    OnKeyDown = GraphDelayCtrlKeyDown
  end
  object PB_1: TProgressBar
    Left = 344
    Top = 176
    Width = 49
    Height = 8
    Smooth = True
    TabOrder = 24
  end
  object PB_2: TProgressBar
    Left = 344
    Top = 248
    Width = 49
    Height = 8
    Smooth = True
    TabOrder = 25
  end
  object PB_3: TProgressBar
    Left = 544
    Top = 176
    Width = 49
    Height = 8
    Smooth = True
    TabOrder = 26
  end
  object PB_4: TProgressBar
    Left = 544
    Top = 248
    Width = 49
    Height = 8
    Smooth = True
    TabOrder = 27
  end
  object ColorDialog: TColorDialog
    Left = 664
    Top = 112
  end
  object DelayTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = DelayTimerTimer
    Left = 664
    Top = 160
  end
  object ComPort: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    OnAfterOpen = ComPortAfterOpen
    OnAfterClose = ComPortAfterClose
    OnRxChar = ComPortRxChar
    OnRxFlag = ComPortRxFlag
    Left = 160
    Top = 120
  end
end
