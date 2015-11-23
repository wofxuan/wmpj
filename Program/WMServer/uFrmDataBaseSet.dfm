object frmDataBaseSet: TfrmDataBaseSet
  Left = 436
  Top = 314
  Width = 424
  Height = 211
  BorderIcons = [biSystemMenu]
  Caption = #25968#25454#24211#36830#25509#35774#32622
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
    Caption = #25968#25454#24211#22320#22336
  end
  object lbl2: TLabel
    Left = 56
    Top = 55
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #29992#25143#21517
  end
  object lbl3: TLabel
    Left = 56
    Top = 86
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #23494#30721
  end
  object edtAddr: TEdit
    Left = 144
    Top = 20
    Width = 201
    Height = 21
    TabOrder = 0
    Text = 'edtAddr'
  end
  object edtUser: TEdit
    Left = 144
    Top = 51
    Width = 201
    Height = 21
    TabOrder = 1
    Text = 'edtAddr'
  end
  object edtPassWord: TEdit
    Left = 144
    Top = 82
    Width = 201
    Height = 21
    TabOrder = 2
    Text = 'edtAddr'
  end
  object btnOk: TButton
    Left = 112
    Top = 128
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 232
    Top = 128
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 4
  end
end
