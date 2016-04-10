inherited frmInitOver: TfrmInitOver
  Caption = 'frmInitOver'
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
      TabOrder = 2
      Visible = False
    end
    inherited btnCannel: TcxButton
      Left = 295
      TabOrder = 3
    end
    object btnBegin: TcxButton
      Left = 16
      Top = 12
      Width = 75
      Height = 25
      Caption = #24320#36134
      TabOrder = 0
      OnClick = btnBeginClick
    end
    object btnEnd: TcxButton
      Left = 104
      Top = 12
      Width = 75
      Height = 25
      Caption = #21453#24320#36134
      TabOrder = 1
      OnClick = btnEndClick
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
        Height = 39
        Caption = 
          '        '#22312#24320#22987#19994#21153#21069#65292#36827#34892#24320#36134#22788#29702#65292#24320#36134#20250#25226#24403#21069#30340#26399#21021#24211#23384#36716#31227#21040#24403#21069#24211#23384#12290#24320#36134#21518#65292#22914#26524#27809#26377#36827#34892#21333#25454#36807#36134#20063#21487#20197#36827#34892#21453#24320#36134#65292 +
          #21453#24320#36134#20250#21024#38500#24403#21069#24211#23384#12290
        Transparent = True
        WordWrap = True
      end
    end
  end
end
