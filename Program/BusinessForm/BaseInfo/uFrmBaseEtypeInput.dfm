inherited frmBaseEtypeInput: TfrmBaseEtypeInput
  Left = 219
  Top = 201
  Caption = 'frmBaseEtypeInput'
  ClientHeight = 279
  ClientWidth = 655
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 230
    Width = 655
    inherited btnOK: TcxButton
      Left = 438
    end
    inherited btnCannel: TcxButton
      Left = 534
    end
  end
  inherited pnlClient: TPanel
    Width = 655
    Height = 189
    object lbl1: TLabel
      Left = 11
      Top = 10
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #32844#21592#20840#21517
    end
    object lbl2: TLabel
      Left = 11
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #32844#21592#32534#21495
    end
    object lbl3: TLabel
      Left = 228
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #25340#38899#30721
    end
    object lbl4: TLabel
      Left = 443
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #32844#21592#37096#38376
    end
    object lbl5: TLabel
      Left = 228
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #30005#35805
    end
    object lbl6: TLabel
      Left = 443
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #29983#26085
    end
    object lbl7: TLabel
      Left = 11
      Top = 138
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #22320#22336
    end
    object lbl8: TLabel
      Left = 10
      Top = 106
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #32844#20301
    end
    object lbl9: TLabel
      Left = 207
      Top = 106
      Width = 78
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #27599#21333#20248#24800#38480#39069
    end
    object lbl10: TLabel
      Left = 11
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'EMail'
    end
    object lbl11: TLabel
      Left = 408
      Top = 106
      Width = 92
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #26368#20302#25240#25187#19979#38480
    end
    object edtFullname: TcxButtonEdit
      Left = 75
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Text = 'edtFullname'
      Width = 566
    end
    object edtUsercode: TcxButtonEdit
      Left = 75
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Text = 'edtUsercode'
      Width = 137
    end
    object edtPYM: TcxButtonEdit
      Left = 289
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Text = 'edtPYM'
      Width = 137
    end
    object chkStop: TcxCheckBox
      Left = 560
      Top = 158
      Caption = #20572#29992
      TabOrder = 11
      Width = 81
    end
    object edtDType: TcxButtonEdit
      Left = 504
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Text = 'edtUsercode'
      Width = 137
    end
    object edtTel: TcxButtonEdit
      Left = 289
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Text = 'edtName'
      Width = 137
    end
    object edtBirthday: TcxButtonEdit
      Left = 504
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Text = 'edtPYM'
      Width = 137
    end
    object edtAddress: TcxButtonEdit
      Left = 73
      Top = 134
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Text = 'edtUsercode'
      Width = 569
    end
    object edtJob: TcxButtonEdit
      Left = 75
      Top = 102
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Text = 'edtName'
      Width = 137
    end
    object edtTopTotal: TcxButtonEdit
      Left = 289
      Top = 102
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Text = 'edtPYM'
      Width = 137
    end
    object edtEMail: TcxButtonEdit
      Left = 75
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Text = 'edtUsercode'
      Width = 137
    end
    object edtLowLimitDiscount: TcxButtonEdit
      Left = 504
      Top = 102
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Text = 'edtUsercode'
      Width = 137
    end
  end
  inherited pnlTop: TPanel
    Width = 655
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited actlstEvent: TActionList
    Left = 160
    Top = 216
  end
end
