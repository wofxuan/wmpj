object FrmWMPG: TFrmWMPG
  Left = 393
  Top = 186
  Width = 632
  Height = 422
  Caption = #20027#31243#24207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgTop: TImage
    Left = 0
    Top = 0
    Width = 616
    Height = 65
    Align = alTop
  end
  object statList: TStatusBar
    Left = 0
    Top = 364
    Width = 616
    Height = 19
    Panels = <
      item
        Text = '1'
        Width = 50
      end
      item
        Text = '2'
        Width = 50
      end
      item
        Text = '3'
        Width = 50
      end>
  end
  object tclFrmList: TcxTabControl
    Left = 0
    Top = 65
    Width = 616
    Height = 20
    Align = alTop
    Options = [pcoAlwaysShowGoDialogButton, pcoCloseButton, pcoGradient, pcoGradientClientArea, pcoRedrawOnResize]
    ParentShowHint = False
    ShowHint = False
    Style = 10
    TabIndex = 0
    TabOrder = 1
    Tabs.Strings = (
      #23548#33322#22270)
    OnCanClose = tclFrmListCanClose
    OnChange = tclFrmListChange
    ClientRectBottom = 20
    ClientRectRight = 616
    ClientRectTop = 19
  end
end
