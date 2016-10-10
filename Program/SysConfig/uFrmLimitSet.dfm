inherited frmLimitSet: TfrmLimitSet
  Left = 177
  Top = 219
  Caption = 'frmLimitSet'
  ClientHeight = 403
  ClientWidth = 821
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 354
    Width = 821
    TabOrder = 2
    inherited btnOK: TcxButton
      Left = 634
    end
    inherited btnCannel: TcxButton
      Left = 722
    end
  end
  inherited pnlTop: TPanel
    Width = 821
    TabOrder = 0
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 821
    Height = 313
    TabOrder = 1
    object pcLimit: TcxPageControl
      Left = 1
      Top = 1
      Width = 819
      Height = 311
      ActivePage = tsReport
      Align = alClient
      Style = 10
      TabOrder = 0
      ClientRectBottom = 311
      ClientRectRight = 819
      ClientRectTop = 19
      object tsBase: TcxTabSheet
        Caption = #22522#26412#20449#24687
        ImageIndex = 0
        object gridBase: TcxGrid
          Left = 0
          Top = 0
          Width = 819
          Height = 292
          Align = alClient
          TabOrder = 0
          object gridTVBase: TcxGridTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
          end
          object gridLVBase: TcxGridLevel
            GridView = gridTVBase
          end
        end
      end
      object tsBill: TcxTabSheet
        Caption = #21333#25454
        ImageIndex = 1
      end
      object tsReport: TcxTabSheet
        Caption = #25253#34920
        ImageIndex = 2
      end
      object tsData: TcxTabSheet
        Caption = #25968#25454
        ImageIndex = 4
      end
      object tsOther: TcxTabSheet
        Caption = #20854#23427
        ImageIndex = 4
      end
    end
  end
  object cdsBase: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 137
    Top = 186
  end
end
