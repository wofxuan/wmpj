unit uParamObject;

interface

uses
  Classes, SysUtils, Variants, DBClient, superobject;

type
  //参数定义
  TGParam = record
    ParamName: string;
    ParamValue: Variant;
    IsSystem: Boolean;
  end;

  //参数数组
  TGParams = array of TGParam;

  TParamObject = class(TObject)
  private
    FParams: TGParams;
    FCount: Integer;
    procedure SetParams(Value: TGParams);
  public
    constructor Create;
    procedure Assign(Source: TObject);
    procedure SetValue(AParamName: string; AParamValue: Variant; AddWhenNotExist: Boolean = True);
    procedure Add(AParamName: string; AParamValue: Variant; IsSystem: Boolean = False); //先查找，有就修改没有就增加。
    procedure Clear; //只清空非系统级的
    function AsString(AParamName: string): string;
    function AsInteger(AParamName: string): Integer;
    function AsBoolean(AParamName: string): Boolean;
    function AsFloat(AParamName: string): double;
    function AsVariant(AParamName: string): Variant;
    property Params: TGParams read FParams write SetParams;
    property Count: Integer read FCount write FCount;
    destructor Destroy; override;
  end;

  TParamDataEvent = procedure(ASender: TObject; AList: TParamObject) of object;

function ParamObjectToJson(APB: TParamObject): ISuperObject;
function PackageToJson(AProcName: string; AJson: ISuperObject): ISuperObject;
function ParamObjectToString(APB: TParamObject): string;
procedure ClientDataSetToParamObject(AData: TClientDataSet; AList: TParamObject); //数据转换

implementation

function ParamObjectToString(APB: TParamObject): string;
var
  i: Integer;
  aToStr: string;
begin
  aToStr := '';
  for i := 0 to APB.Count - 1 do
  begin
    if Trim(APB.Params[i].ParamName) = EmptyStr then Continue;
    
    case VarType(APB.Params[i].ParamValue) of
      varString: aToStr := aToStr + '[' + APB.Params[i].ParamName + ':''' + APB.Params[i].ParamValue + ''']';
      varDouble: aToStr := aToStr + '[' + APB.Params[i].ParamName + ':' + FloatToStr(APB.Params[i].ParamValue) + ']';
      varInteger, varShortInt, varByte, varWord, varLongWord, varInt64:
        aToStr := aToStr + '[' + APB.Params[i].ParamName + ':' + IntToStr(APB.Params[i].ParamValue) + ']';
    else
      aToStr := aToStr + '[' + APB.Params[i].ParamName + ':''' + APB.Params[i].ParamValue + ''']';
    end;
  end;
  Result := aToStr;
end;

function ParamObjectToJson(APB: TParamObject): ISuperObject;
var
  i: Integer;
  aJson: ISuperObject;
begin
  aJson := SO();
  for i := 0 to APB.Count - 1 do
  begin
    if Trim(APB.Params[i].ParamName) = EmptyStr then Continue;
    
    case VarType(APB.Params[i].ParamValue) of
      varString: aJson.S[APB.Params[i].ParamName] := APB.Params[i].ParamValue;
      varDouble: aJson.D[APB.Params[i].ParamName] := APB.Params[i].ParamValue;
      varInteger, varShortInt, varByte, varWord, varLongWord, varInt64:
        aJson.I[APB.Params[i].ParamName] := APB.Params[i].ParamValue;
    else
      aJson.S[APB.Params[i].ParamName] := APB.Params[i].ParamValue;
    end;
  end;
  Result := aJson;
end;

function PackageToJson(AProcName: string; AJson: ISuperObject): ISuperObject;
var
  aPackageJson: ISuperObject;
begin
  aPackageJson := SO();
  aPackageJson.S['ProcName'] := AProcName;
  aPackageJson.O['Params'] := AJson;
  Result := aPackageJson;
end;

{ TParamObject }

procedure TParamObject.Add(AParamName: string; AParamValue: Variant; IsSystem: Boolean = False);
var
  I: Integer;
  bExists: Boolean;
begin
  bExists := False;
  for I := Low(FParams) to High(FParams) do
  begin
    if AnsiCompareStr(LowerCase(AParamName), LowerCase(FParams[I].ParamName)) = 0 then
    begin
      bExists := True;
      Break;
    end;
  end;
  if bExists then
  begin
    //参数存在，修改参数值
    FParams[I].ParamValue := AParamValue;
  end
  else
  begin
    //参数不存在，新增参数
    bExists := False;
    for I := Low(FParams) to High(FParams) do
    begin
      if AnsiCompareStr('', LowerCase(FParams[I].ParamName)) = 0 then
      begin
        bExists := True;
        Break;
      end;
    end;
    if bExists then
    begin
      //填补空值
      FParams[I].ParamName := AParamName;
      FParams[I].ParamValue := AParamValue;
      FParams[I].IsSystem := IsSystem;
    end
    else
    begin
      Inc(FCount);
      SetLength(FParams, FCount);
      I := High(FParams);
      FParams[I].ParamName := AParamName;
      FParams[I].ParamValue := AParamValue;
      FParams[I].IsSystem := IsSystem;
    end;
  end;
end;

function TParamObject.AsBoolean(AParamName: string): Boolean;
var
  V: Variant;
begin
  V := AsVariant(AParamName);
  if VarIsNull(V) then
    Result := False
  else
    Result := V;
end;

function TParamObject.AsFloat(AParamName: string): double;
var
  V: Variant;
begin
  V := AsVariant(AParamName);
  if VarIsNull(V) then
    Result := 0.00
  else
    Result := V;
end;

function TParamObject.AsInteger(AParamName: string): Integer;
var
  V: Variant;
begin
  V := AsVariant(AParamName);
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

procedure TParamObject.Assign(Source: TObject);
var
  i: Integer;
  aTGParam: TGParam;
begin
  if not (Source is TParamObject) then Exit;

  Self.Clear;

  for i := 0 to TParamObject(Source).Count - 1 do
  begin
    aTGParam := TParamObject(Source).Params[i];
    Add(aTGParam.ParamName, aTGParam.ParamValue, aTGParam.IsSystem);
  end;
end;

function TParamObject.AsString(AParamName: string): string;
var
  V: Variant;
begin
  V := AsVariant(AParamName);
  if VarIsNull(V) then
    Result := ''
  else
    Result := V;
end;

function TParamObject.AsVariant(AParamName: string): Variant;
var
  I: Integer;
  bExists: Boolean;
begin
  Result := null;
  bExists := False;
  for I := Low(FParams) to High(FParams) do
  begin
    if AnsiCompareStr(LowerCase(AParamName), LowerCase(FParams[I].ParamName)) = 0 then
    begin
      bExists := True;
      Result := FParams[I].ParamValue;
      Break;
    end;
  end;
end;

procedure TParamObject.Clear;
var
  I: Integer;
begin
  for I := Low(FParams) to High(FParams) do
  begin
    if not FParams[I].IsSystem then
    begin
      FParams[I].ParamName := '';
      FParams[I].ParamValue := null;
      FParams[I].IsSystem := False;
    end;
  end;
end;

constructor TParamObject.Create;
begin
  inherited;
  FParams := nil;
  FCount := 0;
end;

destructor TParamObject.Destroy;
begin
  SetLength(FParams, 0);
  FParams := nil;
  FCount := 0;
  inherited;
end;


procedure TParamObject.SetParams(Value: TGParams);
var
  I: Integer;
begin
  if Value = nil then Exit;
  if FParams <> Value then
  begin
    for I := Low(Value) to High(Value) do
    begin
      Add(Value[I].ParamName, Value[I].ParamValue, Value[I].IsSystem);
    end;
  end;
end;

procedure TParamObject.SetValue(AParamName: string; AParamValue: Variant; AddWhenNotExist: Boolean);
var I: Integer;
begin
  for I := Low(FParams) to High(FParams) do
  begin
    if AnsiCompareStr(LowerCase(AParamName), LowerCase(FParams[I].ParamName)) = 0 then
    begin
      FParams[I].ParamValue := AParamValue;
      Exit;
    end;
  end;
  if AddWhenNotExist then
    Add(AParamName, AParamValue, False);
end;

procedure ClientDataSetToParamObject(AData: TClientDataSet;
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
end.

