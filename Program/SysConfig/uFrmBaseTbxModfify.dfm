inherited frmBaseTbxModfify: TfrmBaseTbxModfify
  Caption = 'frmBaseTbxModfify'
  ClientHeight = 275
  ClientWidth = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 226
    Width = 480
    inherited btnOK: TcxButton
      Left = 262
    end
    inherited btnCannel: TcxButton
      Left = 374
    end
  end
  inherited pnlTop: TPanel
    Width = 480
    inherited lblTitle: TcxLabel
      Caption = #31995#32479#34920#26684#37197#32622
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 480
    Height = 185
    object edtTbxName: TcxButtonEdit
      Left = 88
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Text = 'edtTbxName'
      Width = 361
    end
    object cbbTbxType: TcxComboBox
      Left = 328
      Top = 40
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 1
      Width = 121
    end
    object gbTbxComment: TcxGroupBox
      Left = 32
      Top = 72
      Caption = #22791#27880
      TabOrder = 2
      Height = 105
      Width = 417
      object mmoTbxComment: TcxMemo
        Left = 2
        Top = 16
        Align = alClient
        Lines.Strings = (
          'mmoTbxComment')
        TabOrder = 0
        Height = 87
        Width = 413
      end
    end
    object lblName: TcxLabel
      Left = 32
      Top = 10
      Caption = #34920#26684#21517#31216
    end
    object lblType: TcxLabel
      Left = 272
      Top = 42
      Caption = #34920#26684#31867#22411
    end
    object edtTbxDefName: TcxButtonEdit
      Left = 88
      Top = 40
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Text = 'edtTbxDefName'
      Width = 177
    end
    object lblTbxDefName: TcxLabel
      Left = 32
      Top = 42
      Caption = #34920#26684#21035#21517
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
  object cdsTbxInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 384
    Top = 17
  end
end
