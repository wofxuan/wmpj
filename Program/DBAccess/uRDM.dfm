object DMWMServer: TDMWMServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 423
  Top = 369
  Height = 148
  Width = 237
  object ROMessage: TROBinMessage
    Envelopes = <>
    Left = 60
    Top = 8
  end
  object ROChannel: TROWinInetHTTPChannel
    UserAgent = 'RemObjects SDK'
    TargetURL = 'http://localhost:8099/BIN'
    TrustInvalidCA = False
    DispatchOptions = []
    ServerLocators = <>
    Left = 8
    Top = 8
  end
  object RORemoteService: TRORemoteService
    Message = ROMessage
    Channel = ROChannel
    ServiceName = 'WMServer'
    Left = 120
    Top = 8
  end
end
