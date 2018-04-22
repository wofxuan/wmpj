inherited frmFlowWork: TfrmFlowWork
  Caption = 'frmFlowWork'
  ClientHeight = 393
  ClientWidth = 709
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 344
    Width = 709
    inherited btnOK: TcxButton
      Left = 546
      Visible = False
    end
    inherited btnCannel: TcxButton
      Left = 626
      Visible = False
    end
    object btnAllow: TcxButton
      Left = 216
      Top = 12
      Width = 75
      Height = 25
      Action = actAllow
      TabOrder = 2
    end
    object btnBack: TcxButton
      Left = 304
      Top = 12
      Width = 75
      Height = 25
      Action = actBack
      TabOrder = 3
    end
    object btnStop: TcxButton
      Left = 392
      Top = 12
      Width = 75
      Height = 25
      Action = actStop
      TabOrder = 4
    end
  end
  inherited pnlTop: TPanel
    Width = 709
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 709
    Height = 303
    object gbFlow: TcxGroupBox
      Left = 16
      Top = 216
      Caption = #23457#25209#24847#35265
      TabOrder = 0
      Height = 81
      Width = 681
      object mmoFlowInfo: TcxMemo
        Left = 2
        Top = 16
        Align = alClient
        Properties.ScrollBars = ssBoth
        TabOrder = 0
        Height = 63
        Width = 677
      end
    end
    object pcView: TcxPageControl
      Left = 19
      Top = 9
      Width = 678
      Height = 193
      ActivePage = tsHis
      TabOrder = 1
      ClientRectBottom = 193
      ClientRectRight = 678
      ClientRectTop = 24
      object tsHis: TcxTabSheet
        Caption = #23457#25209#35760#24405
        ImageIndex = 0
        object gridFlow: TcxGrid
          Left = 0
          Top = 0
          Width = 678
          Height = 169
          Align = alClient
          TabOrder = 0
          object gridTVFlow: TcxGridTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
          end
          object gridLVFlow: TcxGridLevel
            GridView = gridTVFlow
          end
        end
      end
      object tsList: TcxTabSheet
        Caption = #27969#31243
        ImageIndex = 1
      end
    end
  end
  inherited actlstEvent: TActionList
    object actAllow: TAction
      Caption = #21516#24847'(&Y)'
      OnExecute = actAllowExecute
    end
    object actBack: TAction
      Caption = #36864#22238'(&N)'
      OnExecute = actBackExecute
    end
    object actStop: TAction
      Caption = #32456#27490'(&S)'
      OnExecute = actStopExecute
    end
  end
  object cdsFlow: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 145
  end
end
