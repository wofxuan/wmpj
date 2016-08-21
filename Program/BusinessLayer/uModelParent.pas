unit uModelParent;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject,
  uDefCom, uModelBaseIntf, uBaseInfoDef, uBillData, uPackData;

type
  //所有的业务父类,如果继承TInterfacedObject则不需要手动释放，如果继承TObject则需要手动释放且实现QueryInterface等
  TModelBase = class(TInterfacedObject, IModelBase)
  private
    FParamList: TParamObject;
  protected
    { IInterface }
//    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
//    function _AddRef: Integer; stdcall;
//    function _Release: Integer; stdcall;

    procedure SetParamList(const Value: TParamObject);
  public
    constructor Create;
    destructor Destroy; override;

    property ParamList: TParamObject read FParamList write SetParamList;
  end;

  TModelBaseType = class(TModelBase, IModelBaseType)        //基本信息的业务父类
  private
    FBasicType: TBasicType;

    FOnSetDataEvent: TParamDataEvent;
    FOnGetDataEvent: TParamDataEvent;

    procedure SetDataChangeType(const Value: TDataChangeType);
  protected
    procedure SetData(AList: TParamObject); virtual;        //把数据库中的显示到界面
    function GetData(AList: TParamObject): Boolean; virtual; //把界面的数据写到参数表中
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; virtual; //检查数据
    function SaveAddRec: Boolean; virtual;                  //增加模式下的保存
    function SaveUpdateRec: Boolean; virtual;               //修改模式下的保存
    function DeleteRec(ATypeId: string; ABasicType: TBasicType): Boolean; virtual; //删除一条记录
    function CheckBaseTypeid(AType, ATypeid: string; AData: TClientDataSet): Boolean; virtual; //获取一条记录信息
    function GetSaveProcName: string; virtual;              //得到保存数据时的存储过程
    
    function ModelInfName: string; overload; //业务领域名称

    procedure OnSetDataEvent(AOnSetDataEvent: TParamDataEvent);
    procedure OnGetDataEvent(AOnGetDataEvent: TParamDataEvent);
    function IniData(ATypeId: string): Integer;
    function DataChangeType: TDataChangeType;
    function SaveData: Boolean; virtual;
    function CurTypeId: string;
    procedure SetBasicType(const Value: TBasicType);
  public
    destructor Destroy; override;

    property BasicType: TBasicType read FBasicType write SetBasicType;

  end;

  TModelBaseList = class(TModelBase, IModelBaseList)        //基本信息列表的业务父类
  private
    FBasicType: TBasicType;

    procedure SetDataChangeType(const Value: TDataChangeType);
  protected
    procedure LoadGridData(ATypeid, ACustom: string; ACdsBaseList: TClientDataSet); virtual;
    function DeleteRec(ATypeId: string): Boolean; virtual; //删除一条记录

    function ModelInfName: string; overload; //业务领域名称
    
    procedure SetBasicType(const Value: TBasicType);
    function GetBasicType: TBasicType;
  public
    destructor Destroy; override;

    property BasicType: TBasicType read GetBasicType write SetBasicType;

  end;

  TModelBill = class(TModelBase, IModelBill)        //单据的业务父类
  private
    FVchType: Integer;

    function SaveDetail(AVchCode: Integer; APackData: TPackData): Integer;//保存业务明细
    function SaveAccount(AVchCode: Integer; APackData: TPackData): Integer;//保存财务数据
    function ClearSaveCreate(APRODUCT_TRADE, AModi, AVchType, AVchcode, AOldVchcode: Integer): Integer; //错误后清除单据相关记录
  protected
    function GetBillCreateProcName: string; virtual; abstract; //过账调用的存储过程名称
    function GetBillDraftProcName: string; virtual; //草稿调用的存储过程名称
    function SaveBill(const ABillData: TBillData; AOutPutData: TParamObject): Integer;
    function BillCreate(AModi, AVchType, AVchcode, AOldVchCode: Integer; ADraft: TBillSaveState; AOutPutData: TParamObject): Integer; //单据过账
    procedure LoadBillDataMaster(AInParam, AOutParam: TParamObject); //得到单据主表信息
    procedure LoadBillDataDetail(AInParam: TParamObject; ACdsD: TClientDataSet); //得到单据从表信息
    function GetVchNumber(AParam: TParamObject): Integer;//获取单据编号
  public

  end;

  TModelReport = class(TModelBase, IModelReport)        //报表的业务父类
  private

  protected
    procedure LoadGridData(AParam: TParamObject; ACdsReport: TClientDataSet); virtual;//查询数据
  public

  end;
  
implementation

uses uSysSvc, uOtherIntf, uModelFunCom, uBasicDataLocalClass, Controls, Math, uVchTypeDef;

{ TModelBase }

constructor TModelBase.Create;
begin
  inherited;
  FParamList := TParamObject.Create;
end;

destructor TModelBase.Destroy;
begin
  FParamList.Free;
  inherited;
end;

//function TModelBase.QueryInterface(const IID: TGUID; out Obj): HResult;
//begin
//  if GetInterface(IID, Obj) then
//    Result := 0
//  else
//    Result := E_NOINTERFACE;
//end;
//
//function TModelBase._AddRef: Integer;
//begin
//  Result := -1;
//end;
//
//function TModelBase._Release: Integer;
//begin
//  Result := -1;
//end;

procedure TModelBase.SetParamList(const Value: TParamObject);
var
  I: Integer;
begin
  if Value = nil then
    Exit;
  if FParamList <> Value then
  begin
    for I := 0 to Value.Count - 1 do
    begin
      FParamList.Add(Value.Params[I].ParamName, Value.Params[I].ParamValue);
    end;
  end;
end;

{ TModelBaseType }

function TModelBaseType.CheckData(AParamList: TParamObject; var Msg: string): Boolean;
begin
  Result := True;
end;

function TModelBaseType.DeleteRec(ATypeId: string;
  ABasicType: TBasicType): Boolean;
begin

end;

destructor TModelBaseType.Destroy;
begin

  inherited;
end;

function TModelBaseType.GetData(AList: TParamObject): Boolean;
var
  aMsgInfo: string;
begin
  Result := False;
  if Assigned(FOnGetDataEvent) then
    FOnGetDataEvent(Self, AList);

  //做数据完整性的检查
  if not CheckData(AList, aMsgInfo) then
  begin
    gMFCom.ShowMsgBox(aMsgInfo);
    Exit;
  end;

  Result := True;
end;

function TModelBaseType.SaveData: Boolean;
begin
  Result := False;
  //增加模式
  if DataChangeType in [dctAdd, dctAddCopy, dctClass] then
  begin
    Result := SaveAddRec;
    if Result then
    begin
//      if InputBasicType <> btNo then       //刷新基本信息本地化
//        gFunApp.GetBasicDatas(InputBasicType);

      Result := True;
    end;
  end
  else if DataChangeType in [dctModif] then                 //修改模式
  begin
    Result := SaveUpdateRec;
    if Result then                                          //保存成功
    begin
//      if InputBasicType <> btNo then               //刷新基本信息本地化
//        gFunApp.GetBasicDatas(InputBasicType);
      Result := True;
    end;
  end;
end;

function TModelBaseType.SaveAddRec: Boolean;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  Result := False;
  aList := TParamObject.Create;
  try
    aList.Add('@uErueMode', 0);                             //数据插入标识 0 为程序插入  1为excel导入
    if not GetData(aList) then Exit;
    aList.Add('@RltTypeID', '');
    aList.Add('@errorValue', '');

    aRet := gMFCom.ExecProcByName(GetSaveProcName, aList);
    if aRet = 0 then
    begin
      Self.ParamList.Add('RltTypeID', aList.AsString('@RltTypeID'));
      if DataChangeType in [dctClass] then
      begin

      end;
      Result := True;
    end
    else
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Result := False;
    end;
  finally
    aList.Free;
  end;
end;

function TModelBaseType.SaveUpdateRec: Boolean;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  Result := False;
  aList := TParamObject.Create;
  try
    GetData(aList);
    aList.Add('@errorValue', '');
    aRet := gMFCom.ExecProcByName(GetSaveProcName, aList);
    if aRet = 0 then
    begin
      if DataChangeType in [dctClass] then
      begin

      end;
      Result := True;
    end
    else
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Result := False;
    end;
  finally
    aList.Free;
  end;
end;

procedure TModelBaseType.SetDataChangeType(
  const Value: TDataChangeType);
begin

end;

procedure TModelBaseType.SetData(AList: TParamObject);
begin
  if Assigned(FOnSetDataEvent) then
  begin
    FOnSetDataEvent(Self, AList);
  end;
end;

procedure TModelBaseType.SetBasicType(const Value: TBasicType);
begin
  FBasicType := Value;
end;

function TModelBaseType.IniData(ATypeId: string): Integer;
  function GetCheckBaseTypeId: string;
  begin
    if (DataChangeType() = dctAddCopy) and (CurTypeId = '') then
      //复制新增
      Result := ROOT_ID
    else
      Result := CurTypeId;
  end;
var
  aCdsTemp: TClientDataSet;
  aListParam: TParamObject;
begin
  aCdsTemp := TClientDataSet.Create(nil);
  try
    if CheckBaseTypeid(GetBaseTypeKeyStr(Self.BasicType), GetCheckBaseTypeId, aCdsTemp) then //获取数据
    begin
      if Assigned(FOnSetDataEvent) then
      begin
        aListParam := TParamObject.Create;
        try
          ClientDataSetToParamObject(aCdsTemp, aListParam);
          FOnSetDataEvent(Self, aListParam);                //写数据到界面
        finally
          aListParam.Free;
        end;
      end;
      Result := 1;
    end
    else
      Result := 0;
  finally
    aCdsTemp.Free;
  end;
end;

function TModelBaseType.CheckBaseTypeid(AType, ATypeid: string;
  AData: TClientDataSet): Boolean;
var
  aRet: Integer;
  aInParam: TParamObject;
  aErrorMsg: string;
begin
  aInParam := TParamObject.Create;
  try
    aInParam.Add('@cMode', AType);
    aInParam.Add('@szTypeid', ATypeid);
    aInParam.Add('@errorValue', '');
    aRet := gMFCom.ExecProcBackData('pbx_Base_GetOneInfo', aInParam, AData);
    if aRet = 0 then
    begin
      Result := True;
    end
    else
    begin
      aErrorMsg := aInParam.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Result := False;
    end;
  finally
    aInParam.Free;
  end;
end;

function TModelBaseType.CurTypeId: string;
begin
  Result := ParamList.AsString('CurTypeId');
end;

function TModelBaseType.DataChangeType: TDataChangeType;
begin
  Result := GetDataChangeType(ParamList.AsString('cMode'));
end;

function TModelBaseType.GetSaveProcName: string;
begin
  Result := '';
end;

procedure TModelBaseType.OnSetDataEvent(AOnSetDataEvent: TParamDataEvent);
begin
  FOnSetDataEvent := AOnSetDataEvent;
end;

procedure TModelBaseType.OnGetDataEvent(AOnGetDataEvent: TParamDataEvent);
begin
  FOnGetDataEvent := AOnGetDataEvent;
end;

function TModelBaseType.ModelInfName: string;
begin
  Result := '基本信息记录操作领域';
end;

{ TModelBaseList }

destructor TModelBaseList.Destroy;
begin

  inherited;
end;

procedure TModelBaseList.SetDataChangeType(const Value: TDataChangeType);
begin

end;

procedure TModelBaseList.SetBasicType(const Value: TBasicType);
begin
  FBasicType := Value;
end;

function TModelBaseList.GetBasicType: TBasicType;
begin
  Result := FBasicType;
end;

procedure TModelBaseList.LoadGridData(ATypeid, ACustom: string; ACdsBaseList: TClientDataSet);
var
  aList: TParamObject;
begin
  inherited;
  aList := TParamObject.Create;
  try
    aList.Add('@cMode', GetBaseTypeKeyStr(BasicType));
    aList.Add('@szTypeid', ATypeid);
    aList.Add('@OperatorID', gMFCom.OperatorID);
    if ParamList.AsString(ReportMode) = ReportMode_Node then
    begin                                                   //分组
      gMFCom.ExecProcBackData('pbx_Base_GetGroup', aList, ACdsBaseList);
    end
    else if ParamList.AsString(ReportMode) = ReportMode_List then
    begin                                                   //列表
      aList.Add('@Custom', ACustom);
      gMFCom.ExecProcBackData('pbx_Base_GetList', aList, ACdsBaseList);
    end
    else
    begin
      raise (SysService as IExManagement).CreateFunEx('没有指定查询数据方式（列表或分组）！');
    end;
  finally
    aList.Free;
  end;
end;

function TModelBaseList.DeleteRec(ATypeId: string): Boolean;
var
  aRet: Integer;
  aInParam: TParamObject;
  aErrorMsg: string;
begin
  Result := False;
  if StringEmpty(ATypeId) then Exit;

  if gMFCom.ShowMsgBox('数据删除后不能恢复，请确认删除！', '提示',
    mbtInformation, mbbOKCancel) = mrok then
  begin
    aInParam := TParamObject.Create;
    try
      aInParam.Add('@cMode', GetBaseTypeKeyStr(BasicType));
      aInParam.Add('@cTypeid', ATypeid);
      aInParam.Add('@errorValue', '');
      aRet := gMFCom.ExecProcByName('pbx_Base_Delete', aInParam);
      if aRet = 0 then
      begin
        Result := True;
      end
      else
      begin
        aErrorMsg := aInParam.AsString('@errorValue');
        gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
        Result := False;
      end;
    finally
      aInParam.Free;
    end;
    Result := True;
  end;
end;

function TModelBaseList.ModelInfName: string;
begin
  Result := '基本信息列表领域';
end;

{ TModelBill }

function TModelBill.BillCreate(AModi, AVchType, AVchcode,
  AOldVchCode: Integer; ADraft: TBillSaveState; AOutPutData: TParamObject): Integer;
var
  aList: TParamObject;
  aRet: Integer;
  aShowMsg: string;
begin
  aRet := -1;
  aShowMsg := '未定义操作类型！';
  aList := TParamObject.Create;
  try
    aList.Add('@errorValue', '');
    aList.Add('@NewVchCode', AVchcode);
    aList.Add('@OldVchCode', AOldVchcode);
    aList.Add('@ModiDly', AModi);
    aList.Add('@ADraft', Ord(ADraft));
    aRet := gMFCom.ExecProcByName(GetBillDraftProcName, aList);
    if aRet = 0 then
    begin
      aShowMsg := '保存草稿成功！';
      if ADraft =  soSettle then
      begin
        aList.Add('@NewVchCode', AVchcode);
        aList.Add('@OldVchCode', AOldVchcode);
        aRet := gMFCom.ExecProcByName(GetBillCreateProcName, aList);
        aShowMsg := '过账成功！';
      end;
    end;

    if aRet <> 0 then
    begin
      aShowMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aShowMsg, '错误', mbtError);
    end
    else
    begin
      if AVchType in OrderVchtypes then
        aShowMsg := '保存订单成功！';
        
      gMFCom.ShowMsgBox(aShowMsg, '提示', mbtInformation);
    end;
    Result := aRet;
  finally
    aList.Free;
  end;
end;

function TModelBill.ClearSaveCreate(APRODUCT_TRADE, AModi, AVchType,
  AVchcode, AOldVchcode: Integer): Integer;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  aList := TParamObject.Create;
  try
    aList.Add('@PRODUCT_TRADE', APRODUCT_TRADE);
    aList.Add('@Modi', AModi);
    aList.Add('@VchType', AVchType);
    aList.Add('@NewVchCode', AVchcode);
    aList.Add('@OldVchCode', AOldVchcode);

    Result := gMFCom.ExecProcByName('pbx_Bill_ClearSaveCreate', aList);
  finally
    aList.Free;
  end;
end;

function TModelBill.GetBillDraftProcName: string;
begin
  Result := 'pbx_Bill_CreateDraft';
end;

function TModelBill.GetVchNumber(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aErrorMsg: string;
begin
  try
    aRet := gMFCom.ExecProcByName('pbx_Bill_VchNumber', AParam);
    if aRet <> 0 then
    begin
      aErrorMsg := AParam.AsString('@ErrorValue'); 
      gMFCom.ShowMsgBox(aErrorMsg, '提示', mbtInformation);
    end;
    Result := aRet;
  finally
  end;
end;

procedure TModelBill.LoadBillDataDetail(AInParam: TParamObject;
  ACdsD: TClientDataSet);
var
  aList: TParamObject;
  aCdsMaster: TClientDataSet;
begin
  aList := TParamObject.Create;
  aCdsMaster := TClientDataSet.Create(nil);
  try
    aList.Add('@VchCode', AInParam.AsInteger('VchCode'));
    aList.Add('@VchType', AInParam.AsInteger('VchType'));
    aList.Add('@BillState', AInParam.AsInteger('BillState'));
    gMFCom.ExecProcBackData('pbx_Bill_Load_D', aList, ACdsD);
  finally
    aCdsMaster.Free;
    aList.Free;
  end;
end;

procedure TModelBill.LoadBillDataMaster(AInParam, AOutParam: TParamObject);
var
  aList: TParamObject;
  aCdsMaster: TClientDataSet;
begin
  aList := TParamObject.Create;
  aCdsMaster := TClientDataSet.Create(nil);
  try
    aList.Add('@VchCode', AInParam.AsInteger('VchCode'));
    aList.Add('@VchType', AInParam.AsInteger('VchType'));
    gMFCom.ExecProcBackData('pbx_Bill_Load_M', aList, aCdsMaster);
    ClientDataSetToParamObject(aCdsMaster, AOutParam);
  finally
    aCdsMaster.Free;
    aList.Free;
  end;
end;

function TModelBill.SaveAccount(AVchCode: Integer;
  APackData: TPackData): Integer;
var
  aAccountData: TParamObject;
begin
  Result := 0;
//  if StringEmpty(APackData.ProcName) then Exit;
//  aAccountData :=  TParamObject.Create;
//  try
//    APackData.GetChildAllParam(aAccountData);
//    Result := gMFCom.ExecProcByName(APackData.ProcName, aAccountData);
//  finally
//    aAccountData.Free;
//  end;
end;

function TModelBill.SaveBill(const ABillData: TBillData; AOutPutData: TParamObject): Integer;
var
  aNewVchcode: Integer; //新生成的单据号
  aRet: Integer;
  aResultDataSet: TClientDataSet;
begin
  Result := -1;  
  aNewVchcode := 0;
  AOutPutData.add('NdxReturn', 0);
  AOutPutData.add('CopyAudit', 0);
  AOutPutData.add('DlyReturn', 0);
  AOutPutData.add('DlyAccReturn', 0);
  AOutPutData.add('CreateDraftReturn', 0);

  FVchType := ABillData.VchType;
  //保存主表
  aNewVchcode := gMFCom.ExecProcByName(ABillData.ProcName, ABillData.ParamData);
  AOutPutData.add('NewVchcode', aNewVchcode);
  if aNewVchcode < 0 then
  begin
    AOutPutData.add('NdxReturn', aNewVchcode);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('保存主表信息失败，单据可能已经被过账或删除！', '错误', mbtError);
    Exit;
  end;

  //保存明细数据
  aRet := SaveDetail(ANewVchcode, ABillData.DetailData);
  if aRet < 0 then
  begin
    AOutPutData.add('DlyReturn', aRet);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('保存明细数据失败，请稍后重试。', '错误', mbtError);
    Result := aRet;
    Exit;
  end;

  //保存帐务数据
  aRet := SaveAccount(ANewVchcode, ABillData.AccountData);
  if aRet < 0 then
  begin
    AOutPutData.add('DlyAccReturn', aRet);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('保存财务数据失败，请稍后重试。', '错误', mbtError);
    Result := aRet;
    Exit;
  end;

  Result := ANewVchcode;
end;

function TModelBill.SaveDetail(AVchCode: Integer;
  APackData: TPackData): Integer;
var
  aDetailData: TParamObject;
  aRet: Integer;
begin
  aRet := -1;
  aDetailData :=  TParamObject.Create;
  try
    try
      APackData.GetChildAllParam(aDetailData);
      aDetailData.Add('@VchType', FVchType);
      aDetailData.Add('@VchCode', AVchCode);
      aRet := gMFCom.ExecProcByName(APackData.ProcName, aDetailData);
    except

    end;
  finally
    Result := aRet;
    aDetailData.Free;
  end;
end;

{ TModelReport }

procedure TModelReport.LoadGridData(AParam: TParamObject;
  ACdsReport: TClientDataSet);
begin

end;

end.

