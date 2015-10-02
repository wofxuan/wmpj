{***************************
表格配置
为了减少表格类型，数据保存位置的耦合， 让任一模块都可快速的修改和替换
可分为三个逻辑（1：窗体表格显示；2：控制表格列的属性；3：列信息读取保存处理）
mx 2014-11-28
****************************}
unit uGridConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf;

type
  //列显示类型
  TGCType = (gctSting, gctInt, gctFloat, gctDate, gctDateTime, gctBoolen);

  //每次表格加载完数据后调用
  TAfterLoadDataEvent = procedure(Sender: TObject) of object;

  //管理每个表格对应的数据和操作
  TGridItem = class(TObject)
  private
    FGridID: Integer;
    FGrid: TcxGrid;
    FGridDTV: TcxGridDBTableView;
    FBasicType: TBasicType; //表格如果要分组的需要根据类型在去ptypeid等的儿子数来看是否显示*
    FTypeClassList: TStringList; //记录ID对应的商品是否有子类格式 00001=0 or 00001=1,0没有儿子，1有儿子;为了减少每行的查询操作

    FModelFun: IModelFun;

    FOnAfterLoadData: TAfterLoadDataEvent; //每次表格加载完数据后调用

    //给表格增加序号
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridDTV: TcxGridDBTableView);
    destructor Destroy; override;

    procedure ClearField;
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TGCType = gctSting): TcxGridDBColumn; overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TcxGridDBColumn;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
    procedure InitGridData;
    procedure ReClassList; //要在子类加载数据完成后执行.刷新表格记录ID的PSonnum,在判断是否是类显示*的时候需要用到

    function GetFirstRow: Integer; //获取行的首行
    function GetLastRow: Integer; //获取行的末行
  published
    property OnAfterLoadData: TAfterLoadDataEvent read FOnAfterLoadData write FOnAfterLoadData;
    property BasicType: TBasicType read FBasicType write FBasicType;
    property TypeClassList: TStringList read FTypeClassList write FTypeClassList;

  end;

  //管理和控制所有的表格初始化操作，如列的宽度等
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
//    gctDate: aCol.DataBinding.ValueTypeClass := ;                      //日期类型是什么，没有找到 2014-12-02
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
  //显示行号的那一列
  FGridDTV.OptionsView.Indicator := True;
  FGridDTV.OptionsView.IndicatorWidth := 40;
  //是否能选中单元格
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
    raise (SysService as IExManagement).CreateSysEx('读取表格列[' + ADBName + ']数据错误,请设置表格列字段！');
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

