inherited frmBaseTbxCheckDef: TfrmBaseTbxCheckDef
  Caption = 'frmBaseTbxCheckDef'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    object lblTip: TcxLabel
      Left = 24
      Top = 16
      Caption = #20250#25226#25152#20197#21015#20986#30340#34920#26684#21152#20837#21040#31995#32479#37197#32622#20013
    end
  end
  inherited pnlTop: TPanel
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    object gbUnDef: TcxGroupBox
      Left = 1
      Top = 1
      Align = alLeft
      Caption = #26410#23450#20041#30340#34920
      TabOrder = 0
      Height = 225
      Width = 241
      object lbUnDef: TcxListBox
        Left = 2
        Top = 16
        Width = 237
        Height = 207
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object gbDel: TcxGroupBox
      Left = 250
      Top = 1
      Align = alClient
      Caption = #24050#32463#21024#38500#30340#34920'  '
      TabOrder = 1
      Height = 225
      Width = 254
      object lbDel: TcxListBox
        Left = 2
        Top = 16
        Width = 250
        Height = 207
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object slLeft: TcxSplitter
      Left = 242
      Top = 1
      Width = 8
      Height = 225
      Control = gbUnDef
    end
  end
  inherited actlstEvent: TActionList
    Left = 152
    Top = 80
    inherited actOK: TAction
      Caption = #21047#26032#37197#32622
      OnExecute = actOKExecute
    end
    inherited actCancel: TAction
      OnExecute = actCancelExecute
    end
  end
end
