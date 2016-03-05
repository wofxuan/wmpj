object FrmWMServer: TFrmWMServer
  Left = 372
  Top = 277
  Width = 416
  Height = 246
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26381#21153#31471
  Color = clBtnFace
  ParentFont = True
  Menu = mmServer
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ROMessage: TROBinMessage
    Envelopes = <>
    Left = 286
    Top = 16
  end
  object ROServer: TROIndyHTTPServer
    Dispatchers = <
      item
        Name = 'ROMessage'
        Message = ROMessage
        Enabled = True
        PathInfo = 'Bin'
      end>
    IndyServer.Bindings = <>
    IndyServer.CommandHandlers = <>
    IndyServer.DefaultPort = 8099
    IndyServer.Greeting.NumericCode = 0
    IndyServer.MaxConnectionReply.NumericCode = 0
    IndyServer.ReplyExceptionCode = 0
    IndyServer.ReplyTexts = <>
    IndyServer.ReplyUnknownCommand.NumericCode = 0
    Port = 8099
    Left = 318
    Top = 16
  end
  object mmServer: TMainMenu
    Left = 254
    Top = 16
    object mniSet: TMenuItem
      Caption = #35774#32622
      object mniDataBaseSet: TMenuItem
        Caption = #25968#25454#24211#36830#25509#35774#32622
        OnClick = mniDataBaseSetClick
      end
      object mniServerSet: TMenuItem
        Caption = #26381#21153#31471#35774#32622
        OnClick = mniServerSetClick
      end
    end
  end
  object pmList: TPopupMenu
    Left = 112
    Top = 48
    object mniShowFrm: TMenuItem
      Caption = #26174#31034#20027#30028#38754
      OnClick = mniShowFrmClick
    end
    object mniClose: TMenuItem
      Caption = #20851#38381#31243#24207
      OnClick = mniCloseClick
    end
  end
end
