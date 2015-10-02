{ ------------------------------------
  ����˵����ר�Ŵ����ػ���Ϣ��صĲ���
  �������ڣ�2014/07/08
  ���ߣ�mx
  ��Ȩ��mx
  ------------------------------------- }
unit uBasicDataLocalClass;

interface

uses Classes, DB, DBClient, SysUtils, ExtCtrls, Controls, Forms, Graphics, DBCtrls,
  Variants, Math, StdCtrls, ComObj, uParamObject, uBaseInfoDef, uModelFunIntf;

type
  TBasicDataLocalClass = class(TObject)
  private
    FModelFun: IModelFun;
    FUpdataTags: array[btNo..btAll] of Integer; //���±�־
    FLocalDatas: array[btNo..btAll] of TClientDataSet; //������Ϣ
  protected
    procedure GetBasicData(ABasicType: TBasicType);
  public
    procedure GetBasicDataAll; //ȡ������Ϣ���ػ�����
    constructor Create;
    destructor Destroy; override;
    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string; overload;

  end;

var
  gBasicDataLocal: TBasicDataLocalClass;

implementation

uses uModelFunCom;

{ TBasicDataLocalClass }

constructor TBasicDataLocalClass.Create;
var
  i: Integer;
begin
  inherited;
  for i := Ord(Low(TBasicType)) to Ord(High(TBasicType)) do
  begin
    FLocalDatas[TBasicType(i)] := TClientDataSet.Create(nil);
    FUpdataTags[TBasicType(i)] := 0;
  end;
end;

destructor TBasicDataLocalClass.Destroy;
var
  i: Integer;
begin
  for i := Ord(Low(FLocalDatas)) to Ord(High(FLocalDatas)) do
  begin
    FLocalDatas[TBasicType(i)].Free;
    FUpdataTags[TBasicType(i)] := 0;
  end;
  inherited;
end;

procedure TBasicDataLocalClass.GetBasicData(ABasicType: TBasicType);
var
  aList: TParamObject;
  atypeid: string;
  aData: TClientDataSet;
  aTag: Integer;
begin
  try
    //��Ӧ������Ϣ����
    aData := FLocalDatas[ABasicType];
    //��Ӧ������Ϣ��־
    aTag := FUpdataTags[ABasicType];
    //�洢���̲���
    aList := TParamObject.Create;
    aList.Add('@cMode', GetBaseTypeKeyStr(ABasicType));
    aList.Add('@nUpdateTag', aTag);
    //AList.Add('@nUpdateTag', ATag);
    //ִ�д洢����
    aTag := gMFCom.ExecProcBackData('pbx_Base_GetBasicData', aList, aData);
    //���»�����Ϣ��־
    FUpdataTags[ABasicType] := 0;
    //��������
    aData.IndexDefs.Clear;
    atypeid := GetBaseTypeid(ABasicType);
    aData.IndexDefs.Add(atypeid, atypeid, [ixPrimary]);
    aData.IndexName := atypeid;
  finally
    aList.Free;
  end;
end;

procedure TBasicDataLocalClass.GetBasicDataAll;
var
  ABasic: TBasicType;
begin
  for ABasic := Low(TBasicType) to High(TBasicType) do
  begin
    if not IsSaveToLocal(ABasic) then Continue;
      GetBasicData(ABasic);
  end;
end;

function TBasicDataLocalClass.GetLocalValue(ABasicType: TBasicType;
  ADbName, ATypeid: string): string;
begin
  if FLocalDatas[ABasicType].FindKey([Atypeid]) then
  begin
    Result := FLocalDatas[ABasicType].FieldByName(ADbName).AsString;
  end
  else
  begin
    //���Ը��»�����Ϣ
    GetBasicData(ABasicType);
    if FLocalDatas[ABasicType].FindKey([Atypeid]) then
      Result := FLocalDatas[ABasicType].FieldByName(ADbName).AsString
    else
      Result := '';
  end;
end;

initialization
  gBasicDataLocal := TBasicDataLocalClass.Create;

finalization
  if Assigned(gBasicDataLocal) then gBasicDataLocal.Free;

end.

