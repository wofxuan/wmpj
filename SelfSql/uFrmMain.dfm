object frmMain: TfrmMain
  Left = 331
  Top = 224
  BorderStyle = bsDialog
  Caption = 'frmMain'
  ClientHeight = 284
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmoSQLList: TMemo
    Left = 8
    Top = 8
    Width = 521
    Height = 225
    Lines.Strings = (
      #26085#24535#65306)
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnDo: TButton
    Left = 456
    Top = 248
    Width = 75
    Height = 25
    Caption = #21512#24182'SQL'
    TabOrder = 1
    OnClick = btnDoClick
  end
end
