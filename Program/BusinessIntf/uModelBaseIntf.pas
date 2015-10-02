unit uModelBaseIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uDefCom;

type
  IModelBase = interface(IInterface)
    ['{D4A81B24-B133-4DC4-9BEE-DF637C894A81}']
    procedure SetParamList(const Value: TParamObject);
  end;

  //基本信息的输入
  IModelBaseType = interface(IModelBase)
    ['{40DF4178-D8D6-4816-80D1-D48D8DC7ED2E}']
    procedure OnSetDataEvent(AOnSetDataEvent: TParamDataEvent);//把数据库中的显示到界面
    procedure OnGetDataEvent(AOnGetDataEvent: TParamDataEvent);//把界面的数据写到参数表中
    function IniData(ATypeId: string): Integer;
    function DataChangeType: TDataChangeType; // 当前业务操作数据变化类型
    function SaveData: Boolean; //保存数据
    function CurTypeId: string; //当前ID
    procedure SetBasicType(const Value: TBasicType);
  end;

  //基本信息列表
  IModelBaseList = interface(IModelBase)
    ['{DBBF9289-8356-45B8-B433-065088B600B7}']
    function GetBasicType: TBasicType;
    procedure SetBasicType(const Value: TBasicType);
    procedure LoadGridData(ATypeid, ACustom: string; ACdsBaseList: TClientDataSet);
    function DeleteRec(ATypeId: string): Boolean; //删除一条记录
  end;
implementation

end.

