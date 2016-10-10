inherited frmBillPRMoney: TfrmBillPRMoney
  Top = 209
  Caption = 'frmBillPRMoney'
  ClientHeight = 382
  ClientWidth = 824
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTop: TPanel
    Width = 824
    inherited pnlBillTitle: TPanel
      Width = 822
      inherited lblBillTitle: TcxLabel
        Style.IsFontAssigned = True
      end
      inherited edtBillNumber: TcxButtonEdit
        Left = 600
      end
      inherited deBillDate: TcxDateEdit
        Left = 416
      end
      inherited lblBillDate: TcxLabel
        Left = 360
      end
      inherited lblBillNumber: TcxLabel
        Left = 544
      end
    end
    inherited pnlBillMaster: TPanel
      Width = 822
      object lblBtype: TcxLabel
        Left = 19
        Top = 11
        Caption = #20184#27454#21333#20301
      end
      object edtBtype: TcxButtonEdit
        Left = 72
        Top = 11
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 121
      end
      object lbl2: TcxLabel
        Left = 202
        Top = 13
        Caption = #32463#25163#20154
      end
      object edtEtype: TcxButtonEdit
        Left = 239
        Top = 11
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 3
        Width = 121
      end
      object lbl3: TcxLabel
        Left = 400
        Top = 13
        Caption = #37096#38376
      end
      object edtDtype: TcxButtonEdit
        Left = 429
        Top = 11
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 5
        Width = 121
      end
      object lbl6: TcxLabel
        Left = 42
        Top = 41
        Caption = #25688#35201
      end
      object edtSummary: TcxButtonEdit
        Left = 72
        Top = 39
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 7
        Width = 288
      end
      object lbl7: TcxLabel
        Left = 374
        Top = 41
        Caption = #38468#21152#35828#26126
      end
      object edtComment: TcxButtonEdit
        Left = 430
        Top = 39
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 9
        Width = 121
      end
    end
  end
  inherited gridMainShow: TcxGrid
    Width = 824
    Height = 67
    inherited gridTVMainShow: TcxGridTableView
      OptionsSelection.InvertSelect = False
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 232
    Width = 824
    Height = 150
    Align = alBottom
    Caption = 'pnlBottom'
    TabOrder = 6
    object gridBill: TcxGrid
      Left = 1
      Top = 9
      Width = 822
      Height = 140
      Align = alClient
      TabOrder = 0
      object gridTVBill: TcxGridTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsSelection.InvertSelect = False
        OptionsView.GroupByBox = False
      end
      object gridLVBill: TcxGridLevel
        GridView = gridTVBill
      end
    end
    object pnlBT: TPanel
      Left = 1
      Top = 1
      Width = 822
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object spltrM: TcxSplitter [3]
    Left = 0
    Top = 224
    Width = 824
    Height = 8
    AlignSplitter = salBottom
    Control = pnlBottom
  end
  inherited imglstBtn: TcxImageList
    FormatVersion = 1
  end
  inherited bmList: TdxBarManager
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockControlHeights = (
      0
      0
      44
      0)
    inherited btnNewBill: TdxBarLargeButton
      ImageIndex = 2
    end
    inherited btnSave: TdxBarLargeButton
      ImageIndex = 3
    end
    inherited btnSelectBill: TdxBarLargeButton
      ImageIndex = 4
    end
  end
  object cdsBill: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 448
    Top = 320
  end
end
