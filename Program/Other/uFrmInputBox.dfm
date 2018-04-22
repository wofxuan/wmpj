object frmInputBox: TfrmInputBox
  Left = 384
  Top = 351
  BorderStyle = bsDialog
  Caption = 'frmInputBox'
  ClientHeight = 107
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 21
    Top = 12
    Width = 63
    Height = 13
    Caption = 'lblPrompt'
  end
  object edtInput: TEdit
    Left = 21
    Top = 36
    Width = 345
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = edtInputKeyPress
  end
  object btnOK: TBitBtn
    Left = 200
    Top = 69
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 288
    Top = 69
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
