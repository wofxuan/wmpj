inherited frmBaseSelect: TfrmBaseSelect
  Caption = 'frmBaseSelect'
  ClientHeight = 319
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 280
    Height = 39
    inherited btnOK: TcxButton
      Left = 326
      Top = 8
    end
    inherited btnCannel: TcxButton
      Left = 414
      Top = 8
    end
    object btnSelect: TcxButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Action = actSelect
      TabOrder = 2
    end
  end
  inherited pnlTop: TPanel
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
      Visible = False
    end
    object cbbQueryType: TcxComboBox
      Left = 16
      Top = 8
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 1
      Width = 145
    end
    object edtFilter: TcxButtonEdit
      Left = 168
      Top = 8
      Properties.Buttons = <>
      TabOrder = 2
      Width = 257
    end
    object btnQuery: TcxButton
      Left = 432
      Top = 8
      Width = 70
      Height = 21
      Action = actQuery
      TabOrder = 3
    end
  end
  inherited pnlClient: TPanel
    Height = 239
    object gridMainShow: TcxGrid
      Left = 1
      Top = 1
      Width = 519
      Height = 237
      Align = alClient
      TabOrder = 0
      object gridTVMainShow: TcxGridTableView
        OnKeyDown = gridTVMainShowKeyDown
        NavigatorButtons.ConfirmDelete = False
        OnCellDblClick = gridTVMainShowCellDblClick
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object gridLVMainShow: TcxGridLevel
        GridView = gridTVMainShow
      end
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
    object actQuery: TAction
      Caption = #26597#35810
      OnExecute = actQueryExecute
    end
    object actSelect: TAction
      Caption = #36873#20013
      OnExecute = actSelectExecute
    end
  end
end
