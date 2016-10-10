inherited frmDialog: TfrmDialog
  BorderStyle = bsDialog
  Caption = 'frmDialog'
  ClientWidth = 521
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 268
    Width = 521
    Height = 49
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      521
      49)
    object btnOK: TcxButton
      Left = 310
      Top = 12
      Width = 75
      Height = 25
      Action = actOK
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnCannel: TcxButton
      Left = 422
      Top = 12
      Width = 75
      Height = 25
      Action = actCancel
      Anchors = [akTop, akRight]
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 521
    Height = 41
    Align = alTop
    TabOrder = 1
    object lblTitle: TcxLabel
      Left = 24
      Top = 8
      Caption = #26631#39064
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -21
      Style.Font.Name = #40657#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
  end
  object pnlClient: TPanel [2]
    Left = 0
    Top = 41
    Width = 521
    Height = 227
    Align = alClient
    TabOrder = 2
  end
  inherited actlstEvent: TActionList
    object actOK: TAction
      Caption = #30830#23450
    end
    object actCancel: TAction
      Caption = #21462#28040'(&C)'
      OnExecute = actCancelExecute
    end
  end
end
