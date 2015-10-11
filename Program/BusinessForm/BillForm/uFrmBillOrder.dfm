inherited frmBillOrder: TfrmBillOrder
  Caption = 'frmBillOrder'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTop: TPanel
    inherited pnlBillTitle: TPanel
      inherited lblBillTitle: TcxLabel
        Style.IsFontAssigned = True
      end
    end
  end
  inherited gridMainShow: TcxGrid
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
      48
      0)
  end
end
