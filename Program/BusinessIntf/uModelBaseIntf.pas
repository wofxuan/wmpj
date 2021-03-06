unit uModelBaseIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uDefCom, uBillData;

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

  //单据操作
  IModelBill = interface(IModelBase)
    ['{192C9A3B-07F4-43E9-952D-8C486AF158C3}']
    function SaveBill(const ABillData: TBillData; AOutPutData: TParamObject): Integer; //保存单据
    function BillCreate(AModi, AVchType, AVchcode, AOldVchCode: Integer; ADraft: TBillSaveState; AOutPutData: TParamObject): Integer; //单据过账
    procedure LoadBillDataMaster(AInParam, AOutParam: TParamObject); //得到单据主表信息
    procedure LoadBillDataDetail(AInParam: TParamObject; ACdsD: TClientDataSet); //得到单据从表信息
    function GetVchNumber(AParam: TParamObject): Integer;//获取单据编号
  end;

  //报表操作
  IModelReport = interface(IModelBase)
    ['{8AB57955-F14E-4B27-8790-92339017C1B6}']
    procedure LoadGridData(AParam: TParamObject; ACdsReport: TClientDataSet); //查询数据
  end;

implementation

end.

