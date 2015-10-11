inherited frmMDIBill: TfrmMDIBill
  Caption = 'frmMDIBill'
  PixelsPerInch = 96
  TextHeight = 13
  inherited splOP: TSplitter
    Top = 133
    Height = 184
  end
  inherited pnlTop: TPanel
    Top = 48
    Height = 85
    object pnlBillTitle: TPanel
      Left = 1
      Top = 1
      Width = 734
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        734
        32)
      object lblBillTitle: TcxLabel
        Left = 16
        Top = 0
        AutoSize = False
        Caption = 'lblBillTitle'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        Height = 32
        Width = 137
      end
      object edtBillNumber: TcxButtonEdit
        Left = 512
        Top = 8
        Anchors = [akTop, akRight]
        Properties.Buttons = <
          item
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Text = 'edtBillNumber'
        Width = 209
      end
      object deBillDate: TcxDateEdit
        Left = 328
        Top = 8
        Anchors = [akTop, akRight]
        EditValue = 36892d
        Properties.DateButtons = [btnClear, btnToday]
        TabOrder = 2
        Width = 121
      end
      object lblBillDate: TcxLabel
        Left = 272
        Top = 10
        Anchors = [akTop, akRight]
        Caption = #24405#21333#26085#26399
      end
      object lblBillNumber: TcxLabel
        Left = 456
        Top = 10
        Anchors = [akTop, akRight]
        Caption = #21333#25454#32534#21495
      end
    end
    object pnlBillMaster: TPanel
      Left = 1
      Top = 33
      Width = 734
      Height = 51
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlBillMaster'
      TabOrder = 1
    end
  end
  inherited gridMainShow: TcxGrid
    Top = 133
    Height = 184
    inherited gridTVMainShow: TcxGridTableView
      OptionsView.GroupByBox = False
    end
  end
  inherited actlstEvent: TActionList
    object actNewBill: TAction
      Caption = #26032#22686#21333#25454
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
    Left = 692
    DockControlHeights = (
      0
      0
      48
      0)
    inherited barTool: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnNewBill'
        end
        item
          Visible = True
          ItemName = 'btnClose'
        end>
    end
    object btnNewBill: TdxBarLargeButton
      Action = actNewBill
      Category = 0
    end
  end
end
