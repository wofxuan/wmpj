unit uPackData;

interface

uses
  Classes, TypInfo, SysUtils, Contnrs, Variants, DB, DBClient, uParamObject;

const
  SaveBillChar = '������'; //��������ʱ�����ַ����ķָ�����
  
type
  {���ݴ����:
   ˵���������published���ԣ���������Ƕ������ΪTPackData������
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
    procedure Clear; virtual; //�������
    procedure Add(AName: string; AValue: Variant); //���Ӳ�����
    function AddChild: TParamObject;
    function GetChild(index: Integer): TParamObject;
    function ChildCount: Integer;
    procedure GetChildAllParam(AChildParam: TParamObject);//��TObjectList���еĲ����ϲ���һ����¼
  published
    property ProcName: string read FProcName write SetProcName; //��������
    property ParamData: TParamObject read FData write FData; //��������
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
    AChildParam.add('@RowId', ''); //�������
  end;

  for i := 0 to FChildList.Count - 1 do
  begin
    for j := 0 to AChildParam.Count - 1 do
    begin
      aOldValue := AChildParam.Params[j].ParamValue;
      aName := AChildParam.Params[j].ParamName;
      
      aNewValue := TParamObject(FChildList.Items[i]).AsString(aName);
      aNewValue := aOldValue + SaveBillChar + aNewValue;

      AChildParam.Add(aName, aNewValue);
    end;
    aNewValue := AChildParam.AsString('@RowId');
    AChildParam.add('@RowId', aNewValue + SaveBillChar + IntToStr(i + 1)); //�������
  end;
end;

end.

  
  
