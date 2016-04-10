inherited frmStockGoodsModifyIni: TfrmStockGoodsModifyIni
  Caption = 'frmStockGoodsModifyIni'
  ClientHeight = 209
  ClientWidth = 333
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 160
    Width = 333
    TabOrder = 2
    DesignSize = (
      333
      49)
    inherited btnOK: TcxButton
      Left = 139
    end
    inherited btnCannel: TcxButton
      Left = 251
    end
  end
  inherited pnlTop: TPanel
    Width = 333
    TabOrder = 0
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 333
    Height = 119
    TabOrder = 1
    object lbl1: TcxLabel
      Left = 84
      Top = 24
      AutoSize = False
      Caption = #25968#37327
      Height = 17
      Width = 32
    end
    object lbl3: TcxLabel
      Left = 84
      Top = 51
      AutoSize = False
      Caption = #21333#20215
      Height = 17
      Width = 32
    end
    object lbl2: TcxLabel
      Left = 84
      Top = 78
      AutoSize = False
      Caption = #37329#39069
      Height = 17
      Width = 32
    end
    object edtQty: TcxButtonEdit
      Left = 120
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 121
    end
    object edtPrice: TcxButtonEdit
      Left = 120
      Top = 49
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 121
    end
    object edtTotal: TcxButtonEdit
      Left = 120
      Top = 76
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 121
    end
  end
  inherited actlstEvent: TActionList
    Left = 289
    Top = 16
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
end
