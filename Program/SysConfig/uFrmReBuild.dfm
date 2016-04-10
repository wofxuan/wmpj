inherited frmReBuild: TfrmReBuild
  Caption = 'frmReBuild'
  ClientHeight = 236
  ClientWidth = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 187
    Width = 394
    TabOrder = 2
    inherited btnOK: TcxButton
      Left = 207
    end
    inherited btnCannel: TcxButton
      Left = 295
    end
  end
  inherited pnlTop: TPanel
    Width = 394
    TabOrder = 0
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 394
    Height = 146
    TabOrder = 1
    object pnlTip: TPanel
      Left = 16
      Top = 8
      Width = 361
      Height = 121
      BevelInner = bvLowered
      TabOrder = 0
      object lblTip: TLabel
        Left = 24
        Top = 16
        Width = 312
        Height = 26
        Caption = '        '#37325#24314#20250#21024#38500#24080#22871#30340#25152#26377#21333#25454#65292#24211#23384#30456#20851#20449#24687#65292#35831#35880#24910#25805#20316#65281
        Transparent = True
        WordWrap = True
      end
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
end
