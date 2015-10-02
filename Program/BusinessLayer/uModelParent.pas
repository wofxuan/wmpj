unit uModelParent;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject,
  uDefCom, uModelBaseIntf, uBaseInfoDef;

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
    procedure ClientDataSetToParamObject(AData: TClientDataSet; AList: TParamObject); virtual; //����ת��
    
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

  TModelBaseList = class(TModelBase, IModelBaseList)        //������Ϣ�б���ҵ����
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

implementation

uses uSysSvc, uOtherIntf, uModelFunCom, uBasicDataLocalClass, Controls;

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

procedure TModelBaseType.ClientDataSetToParamObject(AData: TClientDataSet;
  AList: TParamObject);
var
  aCol: Integer;
  aName, aValues: string;
begin
  if not Assigned(AList) then Exit;
  if not Assigned(AData) then Exit;
  if AData.IsEmpty then Exit;

  AList.Clear;
  AData.First;
  for aCol := 0 to AData.FieldCount - 1 do
  begin
    aName := AData.FieldDefs[aCol].Name;
    aValues := AData.FieldList[acol].AsString;
    AList.Add(aName, aValues);
  end;
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

end.
