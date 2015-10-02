object WMFBData: TWMFBData
  OldCreateOrder = True
  OnCreate = RORemoteDataModuleCreate
  Left = 705
  Top = 247
  Height = 300
  Width = 300
  object dspPubBackQryData: TDataSetProvider
    DataSet = qryPubBackData
    Left = 144
    Top = 72
  end
  object conDB: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=123456;Persist Security Info=True;U' +
      'ser ID=sa;Initial Catalog=wmpj;Data Source=127.0.0.1'
    Provider = 'SQLOLEDB.1'
    Left = 40
    Top = 16
  end
  object qryPubBackData: TADOQuery
    Connection = conDB
    Parameters = <>
    Left = 40
    Top = 72
  end
  object spPubBackData: TADOStoredProc
    Connection = conDB
    Parameters = <>
    Left = 40
    Top = 136
  end
  object dspPubBackSPData: TDataSetProvider
    DataSet = spPubBackData
    Left = 144
    Top = 144
  end
end
