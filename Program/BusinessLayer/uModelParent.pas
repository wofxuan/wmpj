unit uModelParent;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject,
  uDefCom, uModelBaseIntf, uBaseInfoDef, uBillData, uPackData;

type
  //���е�ҵ����,����̳�TInterfacedObject����Ҫ�ֶ��ͷţ�����̳�TObject����Ҫ�ֶ��ͷ���ʵ��QueryInterface��
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

  TModelBaseType = class(TModelBase, IModelBaseType)        //������Ϣ��ҵ����
  private
    FBasicType: TBasicType;

    FOnSetDataEvent: TParamDataEvent;
    FOnGetDataEvent: TParamDataEvent;

    procedure SetDataChangeType(const Value: TDataChangeType);
  protected
    procedure SetData(AList: TParamObject); virtual;        //�����ݿ��е���ʾ������
    function GetData(AList: TParamObject): Boolean; virtual; //�ѽ��������д����������
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; virtual; //�������
    function SaveAddRec: Boolean; virtual;                  //����ģʽ�µı���
    function SaveUpdateRec: Boolean; virtual;               //�޸�ģʽ�µı���
    function DeleteRec(ATypeId: string; ABasicType: TBasicType): Boolean; virtual; //ɾ��һ����¼
    function CheckBaseTypeid(AType, ATypeid: string; AData: TClientDataSet): Boolean; virtual; //��ȡһ����¼��Ϣ
    function GetSaveProcName: string; virtual;              //�õ���������ʱ�Ĵ洢����
    
    function ModelInfName: string; overload; //ҵ����������

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

  TModelBaseList = class(TModelBase, IModelBaseList)        //������Ϣ�б��ҵ����
  private
    FBasicType: TBasicType;

    procedure SetDataChangeType(const Value: TDataChangeType);
  protected
    procedure LoadGridData(ATypeid, ACustom: string; ACdsBaseList: TClientDataSet); virtual;
    function DeleteRec(ATypeId: string): Boolean; virtual; //ɾ��һ����¼

    function ModelInfName: string; overload; //ҵ����������
    
    procedure SetBasicType(const Value: TBasicType);
    function GetBasicType: TBasicType;
  public
    destructor Destroy; override;

    property BasicType: TBasicType read GetBasicType write SetBasicType;

  end;

  TModelBill = class(TModelBase, IModelBill)        //���ݵ�ҵ����
  private
    FVchType: Integer;

    function SaveDetail(AVchCode: Integer; APackData: TPackData): Integer;//����ҵ����ϸ
    function SaveAccount(AVchCode: Integer; APackData: TPackData): Integer;//�����������
    function ClearSaveCreate(APRODUCT_TRADE, AModi, AVchType, AVchcode, AOldVchcode: Integer): Integer; //��������������ؼ�¼
  protected
    function GetBillCreateProcName: string; virtual; abstract; //���˵��õĴ洢��������
    function GetBillDraftProcName: string; virtual; //�ݸ���õĴ洢��������
    function SaveBill(const ABillData: TBillData; AOutPutData: TParamObject): Integer;
    function BillCreate(AModi, AVchType, AVchcode, AOldVchCode: Integer; ADraft: TBillSaveState; AOutPutData: TParamObject): Integer; //���ݹ���
    procedure LoadBillDataMaster(AInParam, AOutParam: TParamObject); //�õ�����������Ϣ
    procedure LoadBillDataDetail(AInParam: TParamObject; ACdsD: TClientDataSet); //�õ����ݴӱ���Ϣ
    function GetVchNumber(AParam: TParamObject): Integer;//��ȡ���ݱ��
  public

  end;

  TModelReport = class(TModelBase, IModelReport)        //�����ҵ����
  private

  protected
    procedure LoadGridData(AParam: TParamObject; ACdsReport: TClientDataSet); virtual;//��ѯ����
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

  //�����������Եļ��
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
  //����ģʽ
  if DataChangeType in [dctAdd, dctAddCopy, dctClass] then
  begin
    Result := SaveAddRec;
    if Result then
    begin
//      if InputBasicType <> btNo then       //ˢ�»�����Ϣ���ػ�
//        gFunApp.GetBasicDatas(InputBasicType);

      Result := True;
    end;
  end
  else if DataChangeType in [dctModif] then                 //�޸�ģʽ
  begin
    Result := SaveUpdateRec;
    if Result then                                          //����ɹ�
    begin
//      if InputBasicType <> btNo then               //ˢ�»�����Ϣ���ػ�
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
    aList.Add('@uErueMode', 0);                             //���ݲ����ʶ 0 Ϊ�������  1Ϊexcel����
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
      gMFCom.ShowMsgBox(aErrorMsg, '����', mbtError);
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
      gMFCom.ShowMsgBox(aErrorMsg, '����', mbtError);
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
      //��������
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
    if CheckBaseTypeid(GetBaseTypeKeyStr(Self.BasicType), GetCheckBaseTypeId, aCdsTemp) then //��ȡ����
    begin
      if Assigned(FOnSetDataEvent) then
      begin
        aListParam := TParamObject.Create;
        try
          ClientDataSetToParamObject(aCdsTemp, aListParam);
          FOnSetDataEvent(Self, aListParam);                //д���ݵ�����
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
      gMFCom.ShowMsgBox(aErrorMsg, '����', mbtError);
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
  Result := '������Ϣ��¼��������';
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
    begin                                                   //����
      gMFCom.ExecProcBackData('pbx_Base_GetGroup', aList, ACdsBaseList);
    end
    else if ParamList.AsString(ReportMode) = ReportMode_List then
    begin                                                   //�б�
      aList.Add('@Custom', ACustom);
      gMFCom.ExecProcBackData('pbx_Base_GetList', aList, ACdsBaseList);
    end
    else
    begin
      raise (SysService as IExManagement).CreateFunEx('û��ָ����ѯ���ݷ�ʽ���б����飩��');
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

  if gMFCom.ShowMsgBox('����ɾ�����ָܻ�����ȷ��ɾ����', '��ʾ',
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
        gMFCom.ShowMsgBox(aErrorMsg, '����', mbtError);
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
  Result := '������Ϣ�б�����';
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
  aShowMsg := 'δ����������ͣ�';
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
      aShowMsg := '����ݸ�ɹ���';
      if ADraft =  soSettle then
      begin
        aList.Add('@NewVchCode', AVchcode);
        aList.Add('@OldVchCode', AOldVchcode);
        aRet := gMFCom.ExecProcByName(GetBillCreateProcName, aList);
        aShowMsg := '���˳ɹ���';
      end;
    end;

    if aRet <> 0 then
    begin
      aShowMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aShowMsg, '����', mbtError);
    end
    else
    begin
      if AVchType in OrderVchtypes then
        aShowMsg := '���涩���ɹ���';
        
      gMFCom.ShowMsgBox(aShowMsg, '��ʾ', mbtInformation);
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
      gMFCom.ShowMsgBox(aErrorMsg, '��ʾ', mbtInformation);
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
  aNewVchcode: Integer; //�����ɵĵ��ݺ�
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
  //��������
  aNewVchcode := gMFCom.ExecProcByName(ABillData.ProcName, ABillData.ParamData);
  AOutPutData.add('NewVchcode', aNewVchcode);
  if aNewVchcode < 0 then
  begin
    AOutPutData.add('NdxReturn', aNewVchcode);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('����������Ϣʧ�ܣ����ݿ����Ѿ������˻�ɾ����', '����', mbtError);
    Exit;
  end;

  //������ϸ����
  aRet := SaveDetail(ANewVchcode, ABillData.DetailData);
  if aRet < 0 then
  begin
    AOutPutData.add('DlyReturn', aRet);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('������ϸ����ʧ�ܣ����Ժ����ԡ�', '����', mbtError);
    Result := aRet;
    Exit;
  end;

  //������������
  aRet := SaveAccount(ANewVchcode, ABillData.AccountData);
  if aRet < 0 then
  begin
    AOutPutData.add('DlyAccReturn', aRet);
    ClearSaveCreate(ABillData.PRODUCT_TRADE, IfThen(ABillData.isModi, 1, 0), ABillData.VchType, ANewVchcode, ABillData.VchCode);
    gMFCom.ShowMsgBox('�����������ʧ�ܣ����Ժ����ԡ�', '����', mbtError);
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

