{***************************
�������
Ϊ�˼��ٱ�����ͣ����ݱ���λ�õ���ϣ� ����һģ�鶼�ɿ��ٵ��޸ĺ��滻
�ɷ�Ϊ�����߼���1����������ʾ��2�����Ʊ���е����ԣ�3������Ϣ��ȡ���洦��
mx 2014-11-28
****************************}
unit uGridConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf;

type
  //����ʾ����
  TGCType = (gctSting, gctInt, gctFloat, gctDate, gctDateTime, gctBoolen);

  //ÿ�α����������ݺ����
  TAfterLoadDataEvent = procedure(Sender: TObject) of object;

  //����ÿ������Ӧ�����ݺͲ���
  TGridItem = class(TObject)
  private
    FGridID: Integer;
    FGrid: TcxGrid;
    FGridDTV: TcxGridDBTableView;
    FBasicType: TBasicType; //������Ҫ�������Ҫ����������ȥptypeid�ȵĶ����������Ƿ���ʾ*
    FTypeClassList: TStringList; //��¼ID��Ӧ����Ʒ�Ƿ��������ʽ 00001=0 or 00001=1,0û�ж��ӣ�1�ж���;Ϊ�˼���ÿ�еĲ�ѯ����

    FModelFun: IModelFun;

    FOnAfterLoadData: TAfterLoadDataEvent; //ÿ�α����������ݺ����

    //������������
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridDTV: TcxGridDBTableView);
    destructor Destroy; override;

    procedure ClearField;
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TGCType = gctSting): TcxGridDBColumn; overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TcxGridDBColumn;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
    procedure InitGridData;
    procedure ReClassList; //Ҫ���������������ɺ�ִ��.ˢ�±���¼ID��PSonnum,���ж��Ƿ�������ʾ*��ʱ����Ҫ�õ�

    function GetFirstRow: Integer; //��ȡ�е�����
    function GetLastRow: Integer; //��ȡ�е�ĩ��
  published
    property OnAfterLoadData: TAfterLoadDataEvent read FOnAfterLoadData write FOnAfterLoadData;
    property BasicType: TBasicType read FBasicType write FBasicType;
    property TypeClassList: TStringList read FTypeClassList write FTypeClassList;

  end;

  //����Ϳ������еı���ʼ�����������еĿ�ȵ�
  TGridControl = class(TObject)
  private
    procedure AddGradItem(AGridItem: TGridItem);
  public
    constructor Create;
    destructor Destroy; override;

  end;

var
  FColCfg: TGridControl;

implementation

uses uSysSvc, uOtherIntf, cxDataStorage, cxCheckBox, Graphics;

{ TGridItem }

function TGridItem.AddFiled(AFileName, AShowCaption: string;
  AWidth: Integer; AColShowType: TGCType): TcxGridDBColumn;
var
  aCol: TcxGridDBColumn;
begin
  aCol := FGridDTV.CreateColumn;
  aCol.DataBinding.FieldName := AFileName;
  aCol.Caption := AShowCaption;
  aCol.Width := AWidth;
  if AWidth <= 0 then aCol.Visible := False;

  case AColShowType of
    gctSting: aCol.DataBinding.ValueTypeClass := TcxStringValueType;
    gctInt: aCol.DataBinding.ValueTypeClass := TcxIntegerValueType;
    gctFloat: aCol.DataBinding.ValueTypeClass := TcxFloatValueType;
//    gctDate: aCol.DataBinding.ValueTypeClass := ;                      //����������ʲô��û���ҵ� 2014-12-02
    gctDateTime: aCol.DataBinding.ValueTypeClass := TcxDateTimeValueType;
    gctBoolen: aCol.DataBinding.ValueTypeClass := TcxBooleanValueType;
  else
    aCol.DataBinding.ValueTypeClass := TcxStringValueType;
  end;

  Result := aCol;
end;

function TGridItem.AddCheckBoxCol(AFileName, AShowCaption: string;
  AValueChecked, ValueUnchecked: Variant): TcxGridDBColumn;
var
  aCol: TcxGridDBColumn;
begin
  aCol := FGridDTV.CreateColumn;
  aCol.DataBinding.FieldName := AFileName;
  aCol.Caption := AShowCaption;
  aCol.PropertiesClass := TcxCheckBoxProperties;
  TcxCheckBoxProperties(aCol.Properties).ValueChecked := AValueChecked;
  TcxCheckBoxProperties(aCol.Properties).ValueUnchecked := ValueUnchecked;
  Result := aCol;
end;

procedure TGridItem.ClearField;
begin
  FGridDTV.ClearItems;
end;

constructor TGridItem.Create(AGridID: Integer; AGrid: TcxGrid; AGridDTV: TcxGridDBTableView);
begin
  FGridID := AGridID;
  FGrid := AGrid;
  FGridDTV := AGridDTV;
  FGridDTV.OnCustomDrawIndicatorCell := XHOnCustomDrawCell;

  FModelFun := SysService as IModelFun;
  //��ʾ�кŵ���һ��
  FGridDTV.OptionsView.Indicator := True;
  FGridDTV.OptionsView.IndicatorWidth := 40;
  //�Ƿ���ѡ�е�Ԫ��
  FGridDTV.OptionsSelection.CellSelect := False;

  FColCfg.AddGradItem(Self);
  FTypeClassList := TStringList.Create;
end;

destructor TGridItem.Destroy;
begin
  FTypeClassList.Free;
  inherited;
end;

procedure TGridItem.XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
var
  FValue: string;
  FBounds: TRect;
begin
  FBounds := AViewInfo.Bounds;
  if (AViewInfo is TcxGridIndicatorRowItemViewInfo) then
  begin
    ACanvas.FillRect(FBounds);
    ACanvas.DrawComplexFrame(FBounds, clBlack, clBlack, [bBottom, bLeft, bRight], 1);
    FValue := IntToStr(TcxGridIndicatorRowItemViewInfo(AViewInfo).GridRecord.Index + 1);

    if Assigned(FTypeClassList) then
    begin
      if FTypeClassList.IndexOf(FValue) >= 0 then
        FValue := FValue + '*';
    end;

    InflateRect(FBounds, -3, -2);
    ACanvas.Font.Color := clBlack;
    ACanvas.Brush.Style := bsClear;
    ACanvas.DrawText(FValue, FBounds, cxAlignCenter or cxAlignTop);
    ADone := True;
  end;
end;

procedure TGridItem.InitGridData;
begin

end;

function TGridItem.GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
var
  aCol: Integer;
begin
  try
    aCol := FGridDTV.GetColumnByFieldName(ADBName).Index;
    Result := FGridDTV.DataController.GetValue(ARowIndex, aCol);
  except
    raise (SysService as IExManagement).CreateSysEx('��ȡ�����[' + ADBName + ']���ݴ���,�����ñ�����ֶΣ�');
  end;
end;

procedure TGridItem.ReClassList;
var
  aTypeId, aSonnum: string;
  aRowIndex: Integer;
begin
  if GetBaseTypesLevels(Self.BasicType) <= 1 then Exit;

  Self.TypeClassList.Clear;
  aRowIndex := 0;
  for aRowIndex := Self.GetFirstRow to Self.GetLastRow do
  begin
    aTypeId := Self.GetCellValue(GetBaseTypeid(Self.BasicType), aRowIndex);
    aSonnum := FModelFun.GetLocalValue(Self.BasicType, GetBaseTypeSonnumStr(Self.BasicType), aTypeId);
    if StrToIntDef(aSonnum, 0) > 0 then
    begin
      Self.TypeClassList.Add(IntToStr(aRowIndex + 1))
    end;
  end;
end;

function TGridItem.GetFirstRow: Integer;
begin
  Result := 0;
end;

function TGridItem.GetLastRow: Integer;
begin
  Result := FGridDTV.DataController.RecordCount - 1; 
end;

{ TGridControl }

procedure TGridControl.AddGradItem(AGridItem: TGridItem);
begin

end;

constructor TGridControl.Create;
begin

end;

destructor TGridControl.Destroy;
begin

  inherited;
end;

initialization
  FColCfg := TGridControl.Create;

finalization
  FColCfg.Free;

end.

