inherited frmMDIBase: TfrmMDIBase
  Caption = 'frmMDIBase'
  PixelsPerInch = 96
  TextHeight = 13
  object splOP: TSplitter [0]
    Left = 121
    Top = 41
    Height = 239
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 736
    Height = 41
    Align = alTop
    Caption = 'pnlTop'
    TabOrder = 0
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 280
    Width = 736
    Height = 41
    Align = alBottom
    Caption = 'pnlBottom'
    TabOrder = 1
  end
  object pnlTV: TPanel [3]
    Left = 0
    Top = 41
    Width = 121
    Height = 239
    Align = alLeft
    Caption = 'pnlTV'
    TabOrder = 2
    Visible = False
    object tvClass: TcxTreeView
      Left = 1
      Top = 1
      Width = 119
      Height = 237
      Align = alClient
      TabOrder = 0
      ReadOnly = True
    end
  end
  object gridMainShow: TcxGrid [4]
    Left = 124
    Top = 41
    Width = 612
    Height = 239
    Align = alClient
    TabOrder = 3
    object gridDTVMainShow: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = dsMainShow
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object gridLVMainShow: TcxGridLevel
      GridView = gridDTVMainShow
    end
  end
  object dsMainShow: TDataSource [5]
    DataSet = cdsMainShow
    Left = 328
    Top = 128
  end
  object cdsMainShow: TClientDataSet [6]
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 112
  end
end
