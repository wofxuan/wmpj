object frmLogin: TfrmLogin
  Left = 379
  Top = 268
  Width = 461
  Height = 146
  Caption = 'frmLogin'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnLogin: TcxButton
    Left = 88
    Top = 32
    Width = 75
    Height = 25
    Caption = 'btnLogin'
    TabOrder = 0
    OnClick = btnLoginClick
  end
  object btnCancel: TcxButton
    Left = 272
    Top = 32
    Width = 75
    Height = 25
    Caption = 'btnCancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
