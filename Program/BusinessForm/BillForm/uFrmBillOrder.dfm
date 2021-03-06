inherited frmBillOrder: TfrmBillOrder
  Caption = 'frmBillOrder'
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
        TabOrder = 2
      end
      inherited deBillDate: TcxDateEdit
        Left = 416
        TabOrder = 1
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
        Caption = #20379#36135#21333#20301
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
        TabOrder = 2
        Width = 121
      end
      object lbl3: TcxLabel
        Left = 378
        Top = 13
        Caption = #37096#38376
      end
      object edtDtype: TcxButtonEdit
        Left = 407
        Top = 11
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 3
        Width = 121
      end
      object lbl4: TcxLabel
        Left = 542
        Top = 13
        Caption = #20132#36135#26085#26399
      end
      object deGatheringDate: TcxDateEdit
        Left = 598
        Top = 11
        EditValue = 36892d
        Properties.DateButtons = [btnClear, btnToday]
        TabOrder = 4
        Width = 121
      end
      object lblKtype: TcxLabel
        Left = 19
        Top = 39
        Caption = #25910#36135#20179#24211
      end
      object edtKtype: TcxButtonEdit
        Left = 72
        Top = 39
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 9
        Width = 121
      end
      object lbl6: TcxLabel
        Left = 210
        Top = 41
        Caption = #25688#35201
      end
      object edtSummary: TcxButtonEdit
        Left = 240
        Top = 39
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 10
        Width = 288
      end
      object lbl7: TcxLabel
        Left = 542
        Top = 41
        Caption = #38468#21152#35828#26126
      end
      object edtComment: TcxButtonEdit
        Left = 598
        Top = 39
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 11
        Width = 121
      end
    end
  end
  inherited gridMainShow: TcxGrid
    Width = 824
    TabOrder = 3
    inherited gridTVMainShow: TcxGridTableView
      OptionsSelection.InvertSelect = False
    end
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
end
