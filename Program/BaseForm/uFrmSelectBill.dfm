inherited frmSelectBill: TfrmSelectBill
  Left = 255
  Top = 178
  Caption = 'frmSelectBill'
  ClientHeight = 421
  ClientWidth = 736
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 372
    Width = 736
    inherited btnOK: TcxButton
      Left = 525
    end
    inherited btnCannel: TcxButton
      Left = 637
    end
  end
  inherited pnlTop: TPanel
    Width = 736
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 736
    Height = 331
    object pnlMaster: TPanel
      Left = 1
      Top = 1
      Width = 734
      Height = 168
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlMaster'
      TabOrder = 0
      object gridMaster: TcxGrid
        Left = 0
        Top = 0
        Width = 734
        Height = 168
        Align = alClient
        TabOrder = 0
        object gridTVMaster: TcxGridTableView
          NavigatorButtons.ConfirmDelete = False
          OnCellClick = gridTVMasterCellClick
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object gridLVMaster: TcxGridLevel
          GridView = gridTVMaster
        end
      end
    end
    object pnlDetail: TPanel
      Left = 1
      Top = 169
      Width = 734
      Height = 161
      Align = alClient
      Caption = 'pnlDetail'
      TabOrder = 1
      object gridDetail: TcxGrid
        Left = 1
        Top = 1
        Width = 732
        Height = 159
        Align = alClient
        TabOrder = 0
        object gridTVDetail: TcxGridTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object gridLVDetail: TcxGridLevel
          GridView = gridTVDetail
        end
      end
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
  object cdsMaster: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 345
    Top = 98
  end
  object cdsDetail: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 473
    Top = 130
  end
end
