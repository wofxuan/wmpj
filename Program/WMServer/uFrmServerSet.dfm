object frmServerSet: TfrmServerSet
  Left = 436
  Top = 314
  Width = 403
  Height = 151
  BorderIcons = [biSystemMenu]
  Caption = #26381#21153#31471#35774#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 56
    Top = 24
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #26381#21153#31471#31471#21475
  end
  object edtPort: TEdit
    Left = 144
    Top = 20
    Width = 113
    Height = 21
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 96
    Top = 64
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 216
    Top = 64
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
end
