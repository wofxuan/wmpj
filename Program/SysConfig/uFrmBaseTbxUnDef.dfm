inherited frmBaseTbxUnDef: TfrmBaseTbxUnDef
  Caption = 'frmBaseTbxUnDef'
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
    object lstbUnDef: TcxCheckListBox
      Left = 1
      Top = 1
      Width = 503
      Height = 225
      Align = alClient
      Items = <>
      ReadOnly = True
      TabOrder = 0
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      Caption = #21152#20837#37197#32622
      OnExecute = actOKExecute
    end
    inherited actCancel: TAction
      OnExecute = actCancelExecute
    end
  end
end
