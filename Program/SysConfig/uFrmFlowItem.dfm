inherited frmFlowItem: TfrmFlowItem
  Left = 592
  Top = 271
  Caption = 'frmFlowItem'
  ClientHeight = 188
  ClientWidth = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 139
    Width = 437
    inherited btnOK: TcxButton
      Left = 226
    end
    inherited btnCannel: TcxButton
      Left = 338
    end
  end
  inherited pnlTop: TPanel
    Width = 437
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited pnlClient: TPanel
    Width = 437
    Height = 98
    object lbl1: TLabel
      Left = 304
      Top = 20
      Width = 44
      Height = 11
      Caption = #25805#20316#31867#22411
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object edtProcesseName: TWmLabelEditBtn
      Left = 96
      Top = 16
      Height = 21
      Properties.Buttons = <>
      TabOrder = 0
      LabelCaption = #39033#30446#21517#31216
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Width = 121
    end
    object cbbType: TcxComboBox
      Left = 352
      Top = 16
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #23457#26680
        #30693#20250)
      TabOrder = 1
      Text = #23457#26680
      Width = 65
    end
    object edtProceOrder: TWmLabelEditBtn
      Left = 96
      Top = 56
      Height = 21
      Properties.Buttons = <>
      TabOrder = 2
      Text = '0'
      LabelCaption = #39033#30446#39034#24207
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Width = 121
    end
    object edtEtype: TWmLabelEditBtn
      Left = 296
      Top = 56
      Height = 21
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      LabelCaption = #23457#26680#20154#21592
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Width = 121
    end
  end
  inherited actlstEvent: TActionList
    inherited actOK: TAction
      OnExecute = actOKExecute
    end
  end
end
