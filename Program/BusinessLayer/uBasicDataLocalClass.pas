{ ------------------------------------
  功能说明：专门处理本地化信息相关的操作
  创建日期：2014/07/08
  作者：mx
  版权：mx
  ------------------------------------- }
unit uBasicDataLocalClass;

interface

uses Classes, DB, DBClient, SysUtils, ExtCtrls, Controls, Forms, Graphics, DBCtrls,
  Variants, Math, StdCtrls, ComObj, uParamObject, uBaseInfoDef, uModelFunIntf;

type
  TBasicDataLocalClass = class(TObject)
  private
    FModelFun: IModelFun;
    FUpdataTags: array[btNo..btAll] of Integer; //更新标志
    FLocalDatas: array[btNo..btAll] of TClientDataSet; //基本信息
  protected
    procedure GetBasicData(ABasicType: TBasicType);
  public
    procedure GetBasicDataAll; //取基本信息本地化数据
    constructor Create;
    destructor Destroy; override;
    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string; overload;
    function GetParIdFromId(ABasicType: TBasicType; ATypeid: string): string;

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
    //对应基本信息数据
    aData := FLocalDatas[ABasicType];
    //对应基本信息标志
    aTag := FUpdataTags[ABasicType];
    //存储过程参数
    aList := TParamObject.Create;
    aList.Add('@cMode', GetBaseTypeKeyStr(ABasicType));
    aList.Add('@nUpdateTag', aTag);
    //AList.Add('@nUpdateTag', ATag);
    //执行存储过程
    aTag := gMFCom.ExecProcBackData('pbx_Base_GetBasicData', aList, aData);
    //更新基本信息标志
    FUpdataTags[ABasicType] := 0;
    //重置索引
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
  if FLocalDatas[ABasicType].FindKey([ATypeid]) then
  begin
    Result := FLocalDatas[ABasicType].FieldByName(ADbName).AsString;
  end
  else
  begin
    //尝试更新基本信息
    GetBasicData(ABasicType);
    if FLocalDatas[ABasicType].FindKey([ATypeid]) then
      Result := FLocalDatas[ABasicType].FieldByName(ADbName).AsString
    else
      Result := '';
  end;
end;

function TBasicDataLocalClass.GetParIdFromId(ABasicType: TBasicType;
  ATypeid: string): string;
begin
  if FLocalDatas[ABasicType].FindKey([ATypeid]) then
  begin
    Result := FLocalDatas[ABasicType].FieldByName('Parid').AsString;
  end
  else
  begin
    //尝试更新基本信息
    GetBasicData(ABasicType);
    if FLocalDatas[ABasicType].FindKey([ATypeid]) then
      Result := FLocalDatas[ABasicType].FieldByName('Parid').AsString
    else
      Result := '';
  end;
end;

initialization
  gBasicDataLocal := TBasicDataLocalClass.Create;

finalization
  if Assigned(gBasicDataLocal) then gBasicDataLocal.Free;

end.

