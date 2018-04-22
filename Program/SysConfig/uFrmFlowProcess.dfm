inherited frmFlowProcess: TfrmFlowProcess
  Left = 348
  Top = 165
  Caption = 'frmFlowProcess'
  ClientHeight = 529
  ClientWidth = 718
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 480
    Width = 718
    inherited btnOK: TcxButton
      Left = 507
    end
    inherited btnCannel: TcxButton
      Left = 619
    end
  end
  inherited pnlTop: TPanel
    Width = 718
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 718
    Height = 439
    object lbl1: TLabel
      Left = 48
      Top = 12
      Width = 22
      Height = 11
      Caption = #31867#22411
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object gbE: TcxGroupBox
      Left = 1
      Top = 199
      Align = alBottom
      Caption = #23457#26680#20154#21592
      TabOrder = 0
      Height = 239
      Width = 716
      object gridE: TcxGrid
        Left = 2
        Top = 16
        Width = 712
        Height = 177
        Align = alTop
        TabOrder = 0
        object gridTVE: TcxGridTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object gridLVE: TcxGridLevel
          GridView = gridTVE
        end
      end
      object btnAddProcess: TcxButton
        Left = 13
        Top = 198
        Width = 75
        Height = 25
        Caption = #22686#21152#39033#30446
        TabOrder = 1
        OnClick = btnAddProcessClick
      end
      object btnDelProcess: TcxButton
        Left = 117
        Top = 198
        Width = 75
        Height = 25
        Caption = #21024#38500#39033#30446
        TabOrder = 2
      end
    end
    object gbTaskProc: TcxGroupBox
      Left = 1
      Top = 43
      Caption = #27969#31243
      TabOrder = 1
      Height = 150
      Width = 552
      object gridTaskProc: TcxGrid
        Left = 2
        Top = 16
        Width = 548
        Height = 132
        Align = alClient
        TabOrder = 0
        object gridTVTaskProc: TcxGridTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object gridLVTaskProc: TcxGridLevel
          GridView = gridTVTaskProc
        end
      end
    end
    object btnAddTaskProc: TcxButton
      Left = 616
      Top = 80
      Width = 75
      Height = 25
      Caption = #22686#21152#27969#31243
      TabOrder = 2
      OnClick = btnAddTaskProcClick
    end
    object btnDelTaskProc: TcxButton
      Left = 616
      Top = 144
      Width = 75
      Height = 25
      Caption = #21024#38500#27969#31243
      TabOrder = 3
      OnClick = btnDelTaskProcClick
    end
    object cbbType: TcxComboBox
      Left = 80
      Top = 8
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #21333#25454#19994#21153
        #20154#20107)
      TabOrder = 4
      Text = #21333#25454#19994#21153
      Width = 121
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
  object cdsFlow: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 24
  end
end
