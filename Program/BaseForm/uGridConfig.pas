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
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf, uModelOtherSet, cxEdit, uDefCom;

type
  //表格单元格双击事件
  TCellDblClickEvent = procedure(Sender: TcxCustomGridTableView;
    ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
    AShift: TShiftState; var AHandled: Boolean) of object;

  TGridEditKeyPressEvent = procedure(Sender: TcxCustomGridTableView;
    AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char) of object;

  //表格每列的信息
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;
    FColShowType: TColField; //字段类型
    FBasicType: TBasicType; //点击列单元格的时候显示哪种TC

    FDataToDisplay: TStringList; //字段显示与查询数据对应列表
    procedure GetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure SetDisplayText(ADisplayText: TIDDisplayText); //设置查询数据与显示数据的对应关系
    constructor Create(AGridColumn: TcxGridColumn; AFieldName: string);
    destructor Destroy; override;
  published
    property GridColumn: TcxGridColumn read FGridColumn write FGridColumn;

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
    FOldGridEditKey: TcxGridEditKeyEvent; //表格单元格原来的按键事件
    FOldGridEditKeyPress: TGridEditKeyPressEvent; //表格单元格原来的按键事件

    //给表格增加序号
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
    procedure ReClassList; //要在子类加载数据完成后执行.刷新表格记录ID的PSonnum,在判断是否是类显示*的时候需要用到
    procedure GridCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure GridEditKeyEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure GridEditKeyPressEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char); //表格单元格输入事件
    procedure ColumnPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer); //添加基本信息时，单元格内的按钮点击事件
    function GetRowIndex: Integer; //获取当前选中的行
    procedure SetRowIndex(Value: Integer); //设置选中的行
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField;
    procedure ClearGridData;//清空表格数据
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TColField = cfString): TColInfo; overload;
    procedure AddFiled(ABasicType: TBasicType); overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant; //获取单元格值
    procedure SetCellValue(ADBName: string; ARowIndex: Integer; AValue: Variant); //设置单元格值
    procedure InitGridData;

    function GetFirstRow: Integer; //获取行的首行
    function GetLastRow: Integer; //获取行的末行
    function SelectedRowCount: Integer; //选中的行数
    procedure LoadData(ACdsData: TClientDataSet); //加载数据
    procedure SetGridCellSelect(ACellSelect: Boolean); //是否能选中单元格和此行其它单元格不是选中状态
    procedure SetGoToNextCellOnEnter(ANextCellOnEnter: Boolean); //是否是否通过回车换行
    procedure MultiSelect(AMultiSelect: Boolean); //是否运行多选
  published
    property BasicType: TBasicType read FBasicType write FBasicType;
    property RowIndex: Integer read GetRowIndex write SetRowIndex;
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

uses uSysSvc, uOtherIntf, cxDataStorage, cxCheckBox, cxButtonEdit, uPubFun, Graphics, Variants;

{ TGridItem }

function TGridItem.AddFiled(AFileName, AShowCaption: string;
  AWidth: Integer; AColShowType: TColField): TColInfo;
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
    cfString: aCol.DataBinding.ValueTypeClass := TcxStringValueType;
    cfInt, cfPlusInt: aCol.DataBinding.ValueTypeClass := TcxIntegerValueType;
    cfFloat, cfPlusFloat, cfQty, cfPrice, cfTotal, cfDiscount: aCol.DataBinding.ValueTypeClass := TcxFloatValueType;
//    gctDate: aCol.DataBinding.ValueTypeClass := ;                      //日期类型是什么，没有找到 2014-12-02
    cfDatime: aCol.DataBinding.ValueTypeClass := TcxDateTimeValueType;
    cfCheck: aCol.DataBinding.ValueTypeClass := TcxBooleanValueType;
  else
    aCol.DataBinding.ValueTypeClass := TcxStringValueType;
  end;

  aColInfo := TColInfo.Create(aCol, AFileName);
  aColInfo.FColShowType := AColShowType;
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
//  FOldCellDblClick := FGridTV.OnCellDblClick;
//  FGridTV.OnCellDblClick := GridCellDblClick;//在编辑单元格进行双击的时候不能触发
  FOldGridEditKey := FGridTV.OnEditKeyDown; //基本信息单元格回车的时候弹出TC
  FGridTV.OnEditKeyDown := GridEditKeyEvent;

  FOldGridEditKeyPress := FGridTV.OnEditKeyPress; //根据字段类型，判断是否能够输入字符
  FGridTV.OnEditKeyPress := GridEditKeyPressEvent;

  FModelFun := SysService as IModelFun;
  //显示行号的那一列
  FGridTV.OptionsView.Indicator := True;
  FGridTV.OptionsView.IndicatorWidth := 40;

  FGridTV.OptionsSelection.CellSelect := False; //是否能选中单元格
  FGridTV.OptionsView.NoDataToDisplayInfoText := '没有数据'; //表格没有数据时显示的内容
  FGridTV.OptionsView.GroupByBox := False; //不显示表头的分组功能
  FGridTV.OptionsBehavior.FocusCellOnCycle := True; //切换时可以循环
  FGridTV.OptionsBehavior.GoToNextCellOnEnter := True; //通过回车切换单元格

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
    Result := varEmpty;
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
    if FGridTV.DataController.RecordCount > 0 then
    begin
      FGridTV.DataController.FocusedRowIndex := 0;
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
        OnSelectBasic(FGridTV, ABasicType, ASelectParam, ASelectOptions, AReturnArray, aReturnCount);
        Break;
      end;
    end;
  end;
end;

procedure TGridItem.AddFiled(ABasicType: TBasicType);
var
  aColInfo: TColInfo;
begin
  if ABasicType = btPtype then
  begin
    AddFiled('PTypeId', 'PTypeId', -1);

    aColInfo := AddFiled('PFullname', '商品名称');
    aColInfo.FGridColumn.PropertiesClass := TcxButtonEditProperties;
    aColInfo.FBasicType := btPtype;
    (aColInfo.FGridColumn.Properties as TcxButtonEditProperties).OnButtonClick := ColumnPropertiesButtonClick; //关联点击事件

    AddFiled('PUsercode', '商品编码');
  end
  else if ABasicType = btBtype then
  begin
    AddFiled('BTypeId', 'BTypeId', -1);
    AddFiled('BFullname', '单位名称');
    AddFiled('BUsercode', '单位编码');
  end
  else if ABasicType = btEtype then
  begin
    AddFiled('ETypeId', 'ETypeId', -1);
    AddFiled('EFullname', '职员名称');
    AddFiled('EUsercode', '职员编码');
  end
  else if ABasicType = btDtype then
  begin
    AddFiled('DTypeId', 'DTypeId', -1);
    AddFiled('DFullname', '部门名称');
    AddFiled('DUsercode', '部门编码');
  end
  else if ABasicType = btKtype then
  begin
    AddFiled('KTypeId', 'KTypeId', -1);
    AddFiled('KFullname', '仓库名称');
    AddFiled('KUsercode', '仓库编码');
  end
  else
  begin
    raise(SysService as IExManagement).CreateSysEx('没有配置[' + BasicTypeToString(ABasicType) + ']此基本信息对应的列,请配置！');
  end;
end;

procedure TGridItem.ColumnPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var
  i, aReturnCount: Integer;
  aBasicType: TBasicType;
  aSelectParam: TSelectBasicParam;
  aSelectOptions: TSelectBasicOptions;
  aReturnArray: TSelectBasicDatas;
begin
  for i := 0 to Length(FColList) - 1 do
  begin
    if FColList[i].FGridColumn = FGridTV.Controller.FocusedColumn then
    begin
      if FColList[i].FBasicType <> btNo then
      begin
        OnSelectBasic(FGrid, FColList[i].FBasicType, aSelectParam, aSelectOptions, aReturnArray, aReturnCount);
      end;
    end;
  end;
end;

function TGridItem.GetRowIndex: Integer;
begin
  Result := -1;

//Result := FGridTV.Controller.FocusedRowIndex;
  if FGridTV.Controller.SelectedRowCount > 0 then
    Result := FGridTV.Controller.SelectedRows[0].RecordIndex;
end;

procedure TGridItem.SetRowIndex(Value: Integer);
begin
  FGridTV.Controller.FocusedRowIndex := Value;
end;

procedure TGridItem.GridEditKeyEvent(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FOldGridEditKey) then FOldGridEditKey(Sender, AItem, AEdit, Key, Shift);
  if Key = VK_RETURN then
  begin
    ColumnPropertiesButtonClick(nil, 0);
  end;
end;

procedure TGridItem.SetCellValue(ADBName: string; ARowIndex: Integer;
  AValue: Variant);
var
  i: Integer;
  aFieldName: string;
begin
  for i := 0 to Length(FColList) - 1 do
  begin
    aFieldName := FColList[i].FFieldName;
    if UpperCase(aFieldName) = UpperCase(ADBName) then
    begin
      FGridTV.DataController.Values[ARowIndex, i] := AValue;
      Break;
    end;
  end;
end;

procedure TGridItem.SetGoToNextCellOnEnter(ANextCellOnEnter: Boolean);
begin
  FGridTV.OptionsBehavior.FocusCellOnCycle := ANextCellOnEnter; //切换时可以循环
  FGridTV.OptionsBehavior.GoToNextCellOnEnter := ANextCellOnEnter; //通过回车切换单元格
end;

function TGridItem.SelectedRowCount: Integer;
begin
  Result := FGridTV.Controller.SelectedRowCount;
end;

procedure TGridItem.MultiSelect(AMultiSelect: Boolean);
begin
  FGridTV.OptionsSelection.MultiSelect := AMultiSelect;
end;

procedure TGridItem.GridEditKeyPressEvent(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char);
var
  i: Integer;
  aColInfo: TColInfo;
begin
  if Assigned(FOldGridEditKeyPress) then FOldGridEditKeyPress(Sender, AItem, AEdit, Key);

  if key = #13 then Exit;
  
  for i := 0 to Length(FColList) - 1 do
  begin
    aColInfo := FColList[i];
    if aColInfo.FGridColumn = AItem then
    begin
      if aColInfo.FColShowType in [cfInt, cfPlusInt] then //整数的时候
      begin
        if not (key in ['0'..'9', #8]) then
        begin
          key := #0;
        end;
      end
      else if aColInfo.FColShowType in [cfFloat, cfPlusFloat, cfQty, cfPrice, cfTotal, cfDiscount] then
      begin
        if not (key in ['0'..'9', #8, '.']) then
        begin
          key := #0;
        end;
      end
      else if aColInfo.FColShowType in [cfDate, cfTime, cfDatime] then
      begin
        if not (key in ['0'..'9', #8, '.', '-']) then
        begin
          key := #0;
        end;
      end;
    end;
  end;
end;

procedure TGridItem.ClearGridData;
var
  aCol: Integer;
  aColItem: TColInfo;
  aFindCol: Boolean;
begin
  try
    FGridTV.DataController.RecordCount := 0;
    FGridTV.DataController.RecordCount := 500;
//    for aCol := 0 to Length(FColList) - 1 do
//    begin
//      aColItem := FColList[aCol];
//      if UpperCase(aColItem.FFieldName) = UpperCase(ADBName) then
//      begin
//        Result := FGridTV.DataController.GetValue(ARowIndex, aColItem.FGridColumn.Index);
//        aFindCol := True;
//        Break;
//      end;
//    end;
  finally

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
  FBasicType := btNo;
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

