unit uPackData;

interface

uses
  Classes, TypInfo, SysUtils, Contnrs, Variants, DB, DBClient, uParamObject;

const
  SaveBillChar = 'ǎǒǜ'; //连续存盘时各个字符串的分隔符号
  
type
  {数据打包类:
   说明：仅打包published属性，如果属性是对象必须为TPackData的子类
  }
  TPackData = class(TPersistent)
  private
    FData: TParamObject;
    FChildList: TObjectList;
    FProcName: string;
    procedure SetProcName(const Value: string);
    function Incr(var x: Integer; n: Integer = 1): Integer;
  public
    constructor Create; overload; virtual;
    destructor Destroy; override;
    procedure Clear; virtual; //清除数据
    procedure Add(AName: string; AValue: Variant); //增加参数象
    function AddChild: TParamObject;
    function GetChild(index: Integer): TParamObject;
    function ChildCount: Integer;
    procedure GetChildAllParam(AChildParam: TParamObject);//把TObjectList所有的参数合并成一条记录
  published
    property ProcName: string read FProcName write SetProcName; //过程名称
    property ParamData: TParamObject read FData write FData; //过程名称
  end;

implementation

{ TPackData }

function TPackData.Incr(var x: Integer; n: Integer): Integer;
begin
  Result := x;
  Inc(x, n);
end;

constructor TPackData.Create;
begin
  FData := TParamObject.Create;
  FChildList := TObjectList.Create;
end;

destructor TPackData.Destroy;
begin
  FData.Free;
  FChildList.Free;
  inherited;
end;

procedure TPackData.Clear;
begin
  FData.Clear;
  FChildList.Clear;
end;

procedure TPackData.add(AName: string; AValue: Variant);
begin
  FData.Add(AName, AValue);
end;

function TPackData.addChild: TParamObject;
begin
  Result := TParamObject.Create;
  FChildList.Add(Result);
end;

function TPackData.childCount: Integer;
begin
  Result := FChildList.Count;
end;

function TPackData.GetChild(index: Integer): TParamObject;
begin
  Result := TParamObject(FChildList.Items[index]);
end;

procedure TPackData.SetProcName(const Value: string);
begin
  FProcName := Value;
end;

procedure TPackData.GetChildAllParam(AChildParam: TParamObject);
var
  i, j: Integer;
  aOneItem: TParamObject;
  aName, aOldValue, aNewValue: string;
begin
  if FChildList.Count > 0 then;
  begin
    aOneItem := TParamObject(FChildList.Items[0]);
    for i := 0 to aOneItem.Count - 1 do
    begin
      AChildParam.Add(aOneItem.Params[i].ParamName, '');
    end;
    AChildParam.add('@RowId', ''); //增加序号
  end;

  for i := 0 to FChildList.Count - 1 do
  begin
    for j := 0 to AChildParam.Count - 1 do
    begin
      aOldValue := AChildParam.Params[j].ParamValue;
      aName := AChildParam.Params[j].ParamName;
      
      if Trim(aName) = '@RowId' then Continue;

      aNewValue := TParamObject(FChildList.Items[i]).AsString(aName);
      aNewValue := aOldValue + SaveBillChar + aNewValue;

      AChildParam.Add(aName, aNewValue);
    end;
    aNewValue := AChildParam.AsString('@RowId');
    AChildParam.add('@RowId', aNewValue + SaveBillChar + IntToStr(i + 1)); //增加序号
  end;
end;

end.

  
  
