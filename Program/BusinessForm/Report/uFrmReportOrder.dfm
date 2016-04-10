inherited frmReportOrder: TfrmReportOrder
  Caption = 'frmReportOrder'
  PixelsPerInch = 96
  TextHeight = 13
  inherited gridMainShow: TcxGrid
    inherited gridTVMainShow: TcxGridTableView
      OnCellDblClick = gridTVMainShowCellDblClick
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
  end
end
