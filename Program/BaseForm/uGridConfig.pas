{***************************
表格配置
为了减少表格类型，数据保存位置的耦合， 让任一模块都可快速的修改和替换
可分为三个逻辑（1：窗体表格显示；2：控制表格列的属性；3：列信息读取保存处理）
mx 2014-11-28
****************************}
unit uGridConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Controls, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf, uModelOtherSet;

type
  //列显示类型
  TGCType = (gctSting, gctInt, gctFloat, gctDate, gctDateTime, gctBoolen);

  //表格单元格双击事件
  TCellDblClickEvent = procedure(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean) of object;
  //表格每列的信息
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;

    FDataToDisplay: TStringList; //字段显示与查询数据对应列表
    procedure GetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure SetDisplayText(ADisplayText: TIDDisplayText); //设置查询数据与显示数据的对应关系
    constructor Create(AGridColumn: TcxGridColumn; AFieldName: string);
    destructor Destroy; override;
  end;

  //管理每个表格对应的数据和操作
  TGridItem = class(TObject)
  private
    FModelFun: IModelFun;
    FGridID: Integer;
    FGrid: TcxGrid;
    FGridTV: TcxGridTableView;
    FBasicType: TBasicType; //表格如果要分组的需要根据类型在去ptypeid等的儿子数来看是否显示*
    FColList: array of TColInfo; //记录添加的所以列信息
    FTypeClassList: TStringList; //记录ID对应的商品是否有子类格式 00001=0 or 00001=1,0没有儿子，1有儿子;为了减少每行的查询操作
    FOnSelectBasic: TSelectBasicinfoEvent; //弹出TC类选择框
    FOldCellDblClick: TCellDblClickEvent; //表格单元格原来的双击事件

    //给表格增加序号
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
    procedure ReClassList; //要在子类加载数据完成后执行.刷新表格记录ID的PSonnum,在判断是否是类显示*的时候需要用到
    procedure GridCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
              AShift: TShiftState; var AHandled: Boolean);
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField;
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TGCType = gctSting): TColInfo; overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
    procedure InitGridData;

    function GetFirstRow: Integer; //获取行的首行
    function GetLastRow: Integer; //获取行的末行
    procedure LoadData(ACdsData: TClientDataSet);//加载数据
    procedure SetGridCellSelect(ACellSelect: Boolean);//是否能选中单元格和此行其它单元格不是选中状态
  published
    property BasicType: TBasicType read FBasicType write FBasicType;
    property OnSelectBasic: TSelectBasicinfoEvent read FOnSelectBasic write FOnSelectBasic;

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

uses uSysSvc, uOtherIntf, cxDataStorage, cxCheckBox, uPubFun, Graphics;

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
//    gctDate: aCol.DataBinding.ValueTypeClass := ;                      //日期类型是什么，没有找到 2014-12-02
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
  FOldCellDblClick := FGridTV.OnCellDblClick;
  FGridTV.OnCellDblClick := GridCellDblClick;

  FModelFun := SysService as IModelFun;
  //显示行号的那一列
  FGridTV.OptionsView.Indicator := True;
  FGridTV.OptionsView.IndicatorWidth := 40;
  //是否能选中单元格
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
  FGridTV.DataController.RecordCount := 500;
end;

function TGridItem.GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
var
  aCol: Integer;
  aColItem: TColInfo;
  aFindCol: Boolean;
begin
  try
    aFindCol := False;
    for aCol := 0 to Length(FColList) - 1 do
    begin
      aColItem := FColList[aCol];
      if UpperCase(aColItem.FFieldName) = UpperCase(ADBName) then
      begin
        Result := FGridTV.DataController.GetValue(ARowIndex, aColItem.FGridColumn.Index);
        aFindCol := True;
        Break;
      end;
    end;
  finally
    if not aFindCol then
    begin
      raise(SysService as IExManagement).CreateSysEx('读取表格列[' + ADBName + ']数据错误,请设置表格列字段！');
    end;
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
    if StringToInt(aSonnum) > 0 then
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
          FGridTV.DataController.Values[aRow, i] := ACdsData.FieldValues[aFieldName];
      end;
      inc(aRow);
      ACdsData.Next;
    end;
  finally
    ReClassList();
    FGridTV.EndUpdate;
  end;
end;

procedure TGridItem.SetGridCellSelect(ACellSelect: Boolean);
begin
  //是否能选中单元格
  FGridTV.OptionsSelection.CellSelect := ACellSelect;
  FGridTV.OptionsSelection.InvertSelect := not ACellSelect;
end;

procedure TGridItem.GridCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  i, aReturnCount: Integer;
  aBasicType: TBasicType;
  aSelectParam: TSelectBasicParam;
  aSelectOptions: TSelectBasicOptions;
  aReturnArray: TSelectBasicDatas;
begin
  if Assigned(FOldCellDblClick) then FOldCellDblClick(Sender, ACellViewInfo, AButton, AShift, AHandled);

  for i := 0 to Length(FColList) - 1 do
  begin
    if FColList[i].FGridColumn = FGridTV.Controller.FocusedColumn then
    begin
      if FColList[i].FFieldName = 'PFullname' then
      begin
        OnSelectBasic(FGrid, ABasicType, ASelectParam, ASelectOptions, AReturnArray, aReturnCount);
      end;
    end;
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
  if Assigned(FDataToDisplay) then FDataToDisplay.Free;
  inherited;
end;

procedure TColInfo.GetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
var
  aDataIndex: Integer;
begin
  aDataIndex := FDataToDisplay.IndexOfName(AText);
  if aDataIndex <> -1 then
  begin
    AText := FDataToDisplay.ValueFromIndex[aDataIndex];
  end;
end;

procedure TColInfo.SetDisplayText(ADisplayText: TIDDisplayText);
begin
  if not Assigned(FDataToDisplay) then
  begin
    FDataToDisplay := TStringList.Create;
    FGridColumn.OnGetDisplayText := GetDisplayText;
  end;

  FDataToDisplay.AddStrings(ADisplayText);
end;

initialization
  FColCfg := TGridControl.Create;

finalization
  FColCfg.Free;

end.

