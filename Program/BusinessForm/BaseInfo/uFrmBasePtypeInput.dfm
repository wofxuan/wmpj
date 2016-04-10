inherited frmBasePtypeInput: TfrmBasePtypeInput
  Left = 219
  Top = 201
  Caption = 'frmBasePtypeInput'
  ClientHeight = 404
  ClientWidth = 628
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 355
    Width = 628
    inherited btnOK: TcxButton
      Left = 438
    end
    inherited btnCannel: TcxButton
      Left = 534
    end
  end
  inherited pnlClient: TPanel
    Width = 628
    Height = 314
    object lbl1: TLabel
      Left = 11
      Top = 10
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #21830#21697#20840#21517
    end
    object lbl2: TLabel
      Left = 11
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #21830#21697#32534#30721
    end
    object Label1: TLabel
      Left = 223
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #31616#21517
    end
    object lbl3: TLabel
      Left = 419
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #25340#38899#30721
    end
    object lbl4: TLabel
      Left = 11
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #35268#26684
    end
    object Label2: TLabel
      Left = 223
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #22411#21495
    end
    object lbl5: TLabel
      Left = 419
      Top = 74
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #20135#22320
    end
    object lbl6: TLabel
      Left = 11
      Top = 106
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #25104#26412#31639#27861
    end
    object lbl7: TLabel
      Left = 212
      Top = 106
      Width = 68
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #26377#25928#26399'('#22825')'
    end
    object edtFullname: TcxButtonEdit
      Left = 75
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Text = 'edtFullname'
      Width = 545
    end
    object edtUsercode: TcxButtonEdit
      Left = 75
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Text = 'edtUsercode'
      Width = 137
    end
    object edtName: TcxButtonEdit
      Left = 284
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Text = 'edtName'
      Width = 137
    end
    object edtPYM: TcxButtonEdit
      Left = 480
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Text = 'edtPYM'
      Width = 137
    end
    object edtStandard: TcxButtonEdit
      Left = 75
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Text = 'edtStandard'
      Width = 137
    end
    object edtModel: TcxButtonEdit
      Left = 284
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Text = 'edtModel'
      Width = 137
    end
    object edtArea: TcxButtonEdit
      Left = 480
      Top = 70
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Text = 'edtArea'
      Width = 137
    end
    object cbbCostMode: TcxComboBox
      Left = 75
      Top = 102
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #31227#21160#21152#26435#24179#22343
        #20808#36827#20808#20986#27861
        #21518#36827#20808#20986#27861
        #25163#24037#25351#23450#27861)
      TabOrder = 7
      Text = #31227#21160#21152#26435#24179#22343
      Width = 137
    end
    object edtUsefulLifeday: TcxButtonEdit
      Left = 284
      Top = 102
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Text = 'edtUsefulLifeday'
      Width = 137
    end
    object chkStop: TcxCheckBox
      Left = 480
      Top = 102
      Caption = #20572#29992
      TabOrder = 9
      Width = 81
    end
    object pgcView: TPageControl
      Left = 15
      Top = 144
      Width = 601
      Height = 161
      ActivePage = tsJG
      TabOrder = 10
      object tsJG: TTabSheet
        Caption = #20215#26684#20449#24687
        object gridPtypeUnit: TcxGrid
          Left = 0
          Top = 0
          Width = 593
          Height = 133
          Align = alClient
          TabOrder = 0
          object gridTVPtypeUnit: TcxGridTableView
            NavigatorButtons.ConfirmDelete = False
            OnEditing = gridTVPtypeUnitEditing
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
          end
          object gridLVPtypeUnit: TcxGridLevel
            GridView = gridTVPtypeUnit
          end
        end
      end
    end
  end
  inherited pnlTop: TPanel
    Width = 628
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited actlstEvent: TActionList
    Left = 160
    Top = 216
  end
end
