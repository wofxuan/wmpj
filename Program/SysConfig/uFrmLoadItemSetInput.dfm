inherited frmLoadItemSetInput: TfrmLoadItemSetInput
  Caption = 'frmLoadItemSetInput'
  ClientHeight = 260
  ClientWidth = 493
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 211
    Width = 493
  end
  inherited pnlClient: TPanel
    Width = 493
    Height = 170
    object lbl1: TLabel
      Left = 7
      Top = 10
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #21253#21517#31216
    end
    object edtLIName: TcxButtonEdit
      Left = 48
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Text = 'edtLIName'
      Width = 433
    end
    object chkIsSytem: TcxCheckBox
      Left = 408
      Top = 36
      Caption = #26159#21542#31995#32479
      TabOrder = 1
      Width = 73
    end
    object grp1: TGroupBox
      Left = 8
      Top = 56
      Width = 473
      Height = 105
      Caption = #22791#27880
      TabOrder = 2
      object mmRemark: TcxMemo
        Left = 2
        Top = 15
        Align = alClient
        Lines.Strings = (
          'mmRemark')
        Properties.ScrollBars = ssVertical
        TabOrder = 0
        Height = 88
        Width = 469
      end
    end
  end
  inherited pnlTop: TPanel
    Width = 493
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited actlstEvent: TActionList
    Left = 96
    Top = 0
  end
end
