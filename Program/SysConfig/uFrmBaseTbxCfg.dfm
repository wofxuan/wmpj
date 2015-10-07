inherited frmBaseTbxCfg: TfrmBaseTbxCfg
  Caption = 'frmBaseTbxCfg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited splOP: TSplitter
    Top = 86
    Height = 231
  end
  inherited pnlTop: TPanel
    Top = 48
    Visible = False
  end
  inherited gridMainShow: TcxGrid
    Top = 86
    Height = 231
  end
  inherited actlstEvent: TActionList
    object actCheckDefTbx: TAction
      Caption = #26816#26597#37197#32622
      OnExecute = actCheckDefTbxExecute
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
    inherited barTool: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnUnDefTbx'
        end
        item
          Visible = True
          ItemName = 'btnReturn'
        end
        item
          Visible = True
          ItemName = 'btnClose'
        end>
    end
    object btnUnDefTbx: TdxBarLargeButton
      Action = actCheckDefTbx
      Category = 0
    end
  end
end
