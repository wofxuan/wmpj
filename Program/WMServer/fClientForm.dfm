object ClientForm: TClientForm
  Left = 372
  Top = 277
  Width = 339
  Height = 153
  Caption = 'RemObjects Client'
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 144
    Top = 40
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
    OnClick = btn1Click
  end
  object ROMessage: TROBinMessage
    Envelopes = <>
    Left = 36
    Top = 8
  end
  object ROChannel: TROWinInetHTTPChannel
    UserAgent = 'RemObjects SDK'
    TargetURL = 'http://localhost:8099/BIN'
    TrustInvalidCA = False
    ServerLocators = <>
    DispatchOptions = []
    Left = 8
    Top = 8
  end
  object RORemoteService: TRORemoteService
    Message = ROMessage
    Channel = ROChannel
    ServiceName = 'WMServer'
    Left = 64
    Top = 8
  end
end
