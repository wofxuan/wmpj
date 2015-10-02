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

  //���ÿ�е���Ϣ
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;
  public
    constructor Create(AGridColumn: TcxGridColumn; AFieldName: string);
    destructor Destroy; override;
  end;

  //����ÿ������Ӧ�����ݺͲ���
  TGridItem = class(TObject)
  private
    FModelFun: IModelFun;
    FGridID: Integer;
    FGrid: TcxGrid;
    FGridTV: TcxGridTableView;
    FBasicType: TBasicType; //������Ҫ�������Ҫ����������ȥptypeid�ȵĶ����������Ƿ���ʾ*
    FColList: array of TColInfo; //��¼��ӵ���������Ϣ
    FTypeClassList: TStringList; //��¼ID��Ӧ����Ʒ�Ƿ��������ʽ 00001=0 or 00001=1,0û�ж��ӣ�1�ж���;Ϊ�˼���ÿ�еĲ�ѯ����

    //������������
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField;
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TGCType = gctSting): TColInfo; overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
    procedure InitGridData;
    procedure ReClassList; //Ҫ���������������ɺ�ִ��.ˢ�±���¼ID��PSonnum,���ж��Ƿ�������ʾ*��ʱ����Ҫ�õ�

    function GetFirstRow: Integer; //��ȡ�е�����
    function GetLastRow: Integer; //��ȡ�е�ĩ��
    procedure LoadData(ACdsData: TClientDataSet);
  published
    property BasicType: TBasicType read FBasicType write FBasicType;

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
  AWidth: Integer; AColShowType: TGCType): TColInfo;
var
  aCol: TcxGridColumn;
  aColInfo: TColInfo;
begin
  aCol := FGridTV.CreateColumn;
//  aCol.DataBinding.FieldName := AFileName;
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

  aColInfo := TColInfo.Create(aCol, AFileName);
  SetLength(FColList, Length(FColList) + 1);
  FColList[Length(FColList) - 1] := aColInfo;
  Result := aColInfo;
end;

function TGridItem.AddCheckBoxCol(AFileName, AShowCaption: string;
  AValueChecked, ValueUnchecked: Variant): TColInfo;
var
  aCol: TcxGridColumn;
  aColInfo: TColInfo;
begin
  aCol := FGridTV.CreateColumn;
//  aCol.DataBinding.FieldName := AFileName;
  aCol.Caption := AShowCaption;
  aCol.PropertiesClass := TcxCheckBoxProperties;
  TcxCheckBoxProperties(aCol.Properties).ValueChecked := AValueChecked;
  TcxCheckBoxProperties(aCol.Properties).ValueUnchecked := ValueUnchecked;

  aColInfo := TColInfo.Create(aCol, AFileName);
  SetLength(FColList, Length(FColList) + 1);
  FColList[Length(FColList) - 1] := aColInfo;
  Result := aColInfo;
end;

procedure TGridItem.ClearField;
begin
  FGridTV.ClearItems;
end;

constructor TGridItem.Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
begin
  FGridID := AGridID;
  FGrid := AGrid;
  FGridTV := AGridTV;
  FGridTV.OnCustomDrawIndicatorCell := XHOnCustomDrawCell;

  FModelFun := SysService as IModelFun;
  //��ʾ�кŵ���һ��
  FGridTV.OptionsView.Indicator := True;
  FGridTV.OptionsView.IndicatorWidth := 40;
  //�Ƿ���ѡ�е�Ԫ��
  FGridTV.OptionsSelection.CellSelect := False;

  FColCfg.AddGradItem(Self);
  FTypeClassList := TStringList.Create;

  SetLength(FColList, 0);
end;

destructor TGridItem.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FColList) - 1 do
  begin
    FColList[i].Free;
  end;

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
//    aCol := FGridTV.GetColumnByFieldName(ADBName).Index;
    Result := FGridTV.DataController.GetValue(ARowIndex, aCol);
  except
    raise(SysService as IExManagement).CreateSysEx('��ȡ�����[' + ADBName + ']���ݴ���,�����ñ�����ֶΣ�');
  end;
end;

procedure TGridItem.ReClassList;
var
  aTypeId, aSonnum: string;
  aRowIndex: Integer;
begin
  FTypeClassList.Clear;
  if GetBaseTypesLevels(Self.BasicType) <= 1 then Exit;

  aRowIndex := 0;
  for aRowIndex := Self.GetFirstRow to Self.GetLastRow do
  begin
    aTypeId := Self.GetCellValue(GetBaseTypeid(Self.BasicType), aRowIndex);
    aSonnum := FModelFun.GetLocalValue(Self.BasicType, GetBaseTypeSonnumStr(Self.BasicType), aTypeId);
    if StrToIntDef(aSonnum, 0) > 0 then
    begin
      FTypeClassList.Add(IntToStr(aRowIndex + 1))
    end;
  end;
end;

function TGridItem.GetFirstRow: Integer;
begin
  Result := 0;
end;

function TGridItem.GetLastRow: Integer;
begin
  Result := FGridTV.DataController.RecordCount - 1;
end;

procedure TGridItem.LoadData(ACdsData: TClientDataSet);
var
  i, aRow, aCdsCol: Integer;
  aFieldName: string;
begin
  FGridTV.DataController.RecordCount := ACdsData.RecordCount;
  ACdsData.First;
  aRow := 0;
  FGridTV.BeginUpdate;
  try
    while not ACdsData.Eof do
    begin
      for i := 0 to Length(FColList) - 1 do
      begin
        aFieldName := FColList[i].FFieldName;
        aCdsCol := ACdsData.FieldDefs.IndexOf(aFieldName);
        if aCdsCol <> -1 then
          FGridTV.DataController.Values[aRow, i]:= ACdsData.FieldValues[aFieldName];
      end;
      inc(aRow);
      ACdsData.Next;
    end;
  finally
    ReClassList();
    FGridTV.EndUpdate;
  end;
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

{ TColInfo }

constructor TColInfo.Create(AGridColumn: TcxGridColumn;
  AFieldName: string);
begin
  FGridColumn := AGridColumn;
  FFieldName := AFieldName;
end;

destructor TColInfo.Destroy;
begin

  inherited;
end;

initialization
  FColCfg := TGridControl.Create;

finalization
  FColCfg.Free;

end.

