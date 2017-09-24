inherited frmBaseInput: TfrmBaseInput
  BorderStyle = bsDialog
  Caption = 'frmBaseInput'
  ClientHeight = 323
  ClientWidth = 513
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 274
    Width = 513
    Height = 49
    Align = alBottom
    TabOrder = 0
    object btnOK: TcxButton
      Left = 294
      Top = 12
      Width = 75
      Height = 25
      Action = actOK
      TabOrder = 0
    end
    object btnCannel: TcxButton
      Left = 406
      Top = 12
      Width = 75
      Height = 25
      Action = actCannel
      Caption = #21462#28040'(&C)'
      TabOrder = 1
    end
    object chkAutoAdd: TcxCheckBox
      Left = 16
      Top = 16
      Caption = #36830#32493#26032#22686
      TabOrder = 2
      Width = 121
    end
  end
  object pnlClient: TPanel [1]
    Left = 0
    Top = 41
    Width = 513
    Height = 233
    Align = alClient
    TabOrder = 1
  end
  object pnlTop: TPanel [2]
    Left = 0
    Top = 0
    Width = 513
    Height = 41
    Align = alTop
    TabOrder = 2
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
  inherited actlstEvent: TActionList
    object actOK: TAction
      Caption = #30830#23450
      OnExecute = actOKExecute
    end
    object actCannel: TAction
      Caption = #21462#28040
      OnExecute = actCannelExecute
    end
  end
end
