inherited frmBaseDtypeInput: TfrmBaseDtypeInput
  Left = 219
  Top = 201
  Caption = 'frmBaseDtypeInput'
  ClientHeight = 293
  ClientWidth = 628
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    Top = 244
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
    Height = 203
    object lbl1: TLabel
      Left = 11
      Top = 10
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #37096#38376#20840#21517
    end
    object lbl2: TLabel
      Left = 11
      Top = 42
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #37096#38376#32534#21495
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
      Left = 72
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
    object chkStop: TcxCheckBox
      Left = 480
      Top = 70
      Caption = #20572#29992
      TabOrder = 4
      Width = 81
    end
    object grpComment: TGroupBox
      Left = 16
      Top = 95
      Width = 601
      Height = 105
      Caption = #22791#27880
      TabOrder = 5
      object mmComment: TcxMemo
        Left = 2
        Top = 15
        Align = alClient
        Lines.Strings = (
          'mmComment')
        TabOrder = 0
        Height = 88
        Width = 597
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
