object uploadForm: TuploadForm
  Left = 517
  Top = 180
  Width = 473
  Height = 426
  Caption = 'Upload code microcontroller - version 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbWifiPassword: TLabel
    Left = 48
    Top = 136
    Width = 67
    Height = 13
    Caption = 'Wifi Password'
  end
  object lbIPAddress: TLabel
    Left = 64
    Top = 168
    Width = 52
    Height = 13
    Caption = 'IP Address'
  end
  object lbGateway: TLabel
    Left = 72
    Top = 232
    Width = 43
    Height = 13
    Caption = 'Gateway'
  end
  object lbSubnet: TLabel
    Left = 80
    Top = 264
    Width = 34
    Height = 13
    Caption = 'Subnet'
  end
  object lbCOMPort: TLabel
    Left = 72
    Top = 296
    Width = 46
    Height = 13
    Caption = 'COM Port'
  end
  object lbWifiSSID: TLabel
    Left = 72
    Top = 104
    Width = 44
    Height = 13
    Caption = 'Wifi SSID'
  end
  object lbPort: TLabel
    Left = 96
    Top = 200
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object edtWifiSSID: TEdit
    Left = 136
    Top = 96
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object btnCreateFile: TButton
    Left = 152
    Top = 328
    Width = 153
    Height = 41
    Caption = 'Upload'
    TabOrder = 1
    OnClick = ButtonUploadClick
  end
  object edtWifiPassword: TEdit
    Left = 136
    Top = 128
    Width = 201
    Height = 21
    HelpType = htKeyword
    TabOrder = 2
  end
  object cbComPort: TComboBox
    Left = 136
    Top = 288
    Width = 201
    Height = 21
    ItemHeight = 13
    TabOrder = 3
  end
  object meditIPAddress: TMaskEdit
    Left = 136
    Top = 160
    Width = 200
    Height = 21
    BevelInner = bvSpace
    TabOrder = 4
  end
  object meditGateWay: TMaskEdit
    Left = 136
    Top = 224
    Width = 201
    Height = 21
    TabOrder = 5
  end
  object meditSubnet: TMaskEdit
    Left = 136
    Top = 256
    Width = 201
    Height = 21
    TabOrder = 6
  end
  object meditPort: TMaskEdit
    Left = 136
    Top = 192
    Width = 201
    Height = 21
    EditMask = '!99999;1; '
    MaxLength = 5
    TabOrder = 7
    Text = '     '
  end
end
