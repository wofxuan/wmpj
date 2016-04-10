inherited frmStockGoodOneCheck: TfrmStockGoodOneCheck
  Caption = 'frmStockGoodOneCheck'
  ClientHeight = 179
  ClientWidth = 345
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 130
    Width = 345
    TabOrder = 2
    inherited btnOK: TcxButton
      Left = 166
      TabOrder = 1
    end
    inherited btnCannel: TcxButton
      Left = 254
      TabOrder = 2
    end
    object btnNew: TcxButton
      Left = 16
      Top = 12
      Width = 75
      Height = 25
      Caption = #26032#30424#28857
      TabOrder = 0
    end
  end
  inherited pnlTop: TPanel
    Width = 345
    TabOrder = 0
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 345
    Height = 89
    TabOrder = 1
    object lbl1: TLabel
      Left = 72
      Top = 52
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #25130#27490#26085#26399
    end
    object lbl2: TLabel
      Left = 72
      Top = 20
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #30424#28857#20179#24211
    end
    object deCheckDate: TcxDateEdit
      Left = 136
      Top = 48
      TabOrder = 1
      Width = 121
    end
    object edtKType: TcxButtonEdit
      Left = 136
      Top = 16
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 121
    end
  end
  inherited actlstEvent: TActionList
    Left = 256
    Top = 8
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
end
