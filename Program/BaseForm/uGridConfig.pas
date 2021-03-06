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
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf, cxEdit, uDefCom, cxCustomData, uOtherDefine,
  cxStyles;

const
  SpecialCharList: array[0..1] of string = ('[', ']');
  MaxRowCount = 500;

type
  //表格单元格双击事件
  TCellDblClickEvent = procedure(Sender: TcxCustomGridTableView;
    ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
    AShift: TShiftState; var AHandled: Boolean) of object;

  TGridEditKeyPressEvent = procedure(Sender: TcxCustomGridTableView;
    AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char) of object;

  TLoadUpDownDataEvent = procedure(Sender: TObject; ATypeid: String) of Object;
  
  //表格每列的信息
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;
    FColShowType: TColField; //字段类型
    FBasicType: TBasicType; //点击列单元格的时候显示哪种TC
    FExpression: string; //自定义的公式 bb*cc

    FDataToDisplay: TStringList; //字段显示与查询数据对应列表
    procedure GetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure AddExpression(AExpression: string);
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
    FGridID: string;
    FGrid: TcxGrid;
    FGridTV: TcxGridTableView;
    FBasicType: TBasicType; //表格如果要分组的需要根据类型在去ptypeid等的儿子数来看是否显示*
    FColList: array of TColInfo; //记录添加的所以列信息
    FTypeClassList: TStringList; //记录ID对应的商品是否有子类格式 00001=0 or 00001=1,0没有儿子，1有儿子;为了减少每行的查询操作
    FCdsSource: TClientDataSet; //通过数据集加载是的数据集
    FCanEdit: Boolean; //是否能够修改单元格类容
    FShowMaxRow: Boolean; //是否能显示最大的行数，不管是否修改或加载数据

    FOnSelectBasic: TSelectBasicinfoEvent; //弹出TC类选择框
    FOldCellDblClick: TCellDblClickEvent; //表格单元格原来的双击事件
    FOldGridEditKey: TcxGridEditKeyEvent; //表格单元格原来的按键事件
    FOldGridEditKeyPress: TGridEditKeyPressEvent; //表格单元格原来的按键事件
    FOnLoadUpDownData: TLoadUpDownDataEvent; //加载上一层或者下一层数据

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
    procedure GridColEditValueChanged(Sender: TObject); //设置公式字段后，单元格值改变事件时计算公式
    procedure InitExpression; //初始化公式设置
  public
    constructor Create(AGridID: string; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField; //清空表格的所有列数据
    procedure ClearData; //清空表格的所有行数据
    function AddField(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TColField = cfString): TColInfo; overload;
    procedure AddField(ABasicType: TBasicType); overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function AddBtnCol(AFileName, AShowCaption, ABtnCaption: string; AClickEvent: TcxEditButtonClickEvent): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant; //获取单元格值
    procedure SetCellValue(ADBName: string; ARowIndex: Integer; AValue: Variant); //设置单元格值
    procedure InitGridData;
    procedure GridPost; //提交修改的数据

    function GetFirstRow: Integer; //获取行的首行
    function GetLastRow: Integer; //获取行的末行
    function SelectedRowCount: Integer; //选中的行数
    procedure LoadData(ACdsData: TClientDataSet); //加载数据
    function LoadUpDownData(ALoadUp: Boolean): Boolean;//加载下一级或者上一级数据
    procedure SetGridCellSelect(ACellSelect: Boolean); //是否能选中单元格和此行其它单元格不是选中状态
    procedure SetGoToNextCellOnEnter(ANextCellOnEnter: Boolean); //是否是否通过回车换行
    procedure MultiSelect(AMultiSelect: Boolean); //是否运行多选
    function FindColByCaption(AShowCaption: string): TColInfo; //根据表头查找列
    function FindColByFieldName(AFieldName: string): TColInfo; //根据数据库字段名称查找列
    procedure AddFooterSummary(AColInfo: TColInfo; ASummaryKind: TcxSummaryKind); //增加一个合计行字段
    function AddRow: Integer; //增加一行
    function RecordCount: Integer; //有多少数据行
    procedure DeleteRow(ARow: Integer); //删除指定行
    procedure SetReadOnly(AReadOnly: Boolean); //是否能修改表格

    property ShowMaxRow: Boolean read FShowMaxRow write FShowMaxRow;
  published
    property BasicType: TBasicType read FBasicType write FBasicType;
    property RowIndex: Integer read GetRowIndex write SetRowIndex;
    property OnSelectBasic: TSelectBasicinfoEvent read FOnSelectBasic write FOnSelectBasic;
    property CdsSource: TClientDataSet read FCdsSource write FCdsSource;
    property OnLoadUpDownData: TLoadUpDownDataEvent read FOnLoadUpDownData write FOnLoadUpDownData;

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

uses uSysSvc, uOtherIntf, cxDataStorage, cxCheckBox, cxButtonEdit, cxTextEdit, uPubFun, Graphics, Variants, uCalcExpress, uDM;

{ TGridItem }

function TGridItem.AddField(AFileName, AShowCaption: string;
  AWidth: Integer; AColShowType: TColField): TColInfo;
var
  aCol: TcxGridColumn;
  aColInfo: TColInfo;
  i: Integer;
  aStrSpecial: string;
begin
  for i := 0 to Length(SpecialCharList) - 1 do
  begin
    aStrSpecial := SpecialCharList[i];
    if Pos(aStrSpecial, AShowCaption) >= 1 then
    begin
      raise(SysService as IExManagement).CreateSysEx('表格列显示名称"' + AShowCaption + '"错误,请重新设置！');
    end;
  end;

  aCol := FGridTV.CreateColumn;
  aCol.Caption := AShowCaption;

  aCol.PropertiesClass := TcxTextEditProperties;
  aCol.Properties.Alignment.Vert := taVCenter; //单元格内容上下居中
  aCol.Options.Sorting := False; //不能排序
  
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

constructor TGridItem.Create(AGridID: string; AGrid: TcxGrid; AGridTV: TcxGridTableView);
begin
  FGridID := AGridID;
  FGrid := AGrid;
  FGridTV := AGridTV;
  FGridTV.OnCustomDrawIndicatorCell := XHOnCustomDrawCell;
  FOldCellDblClick := FGridTV.OnCellDblClick;
  FGridTV.OnCellDblClick := GridCellDblClick;//在编辑单元格进行双击的时候不能触发
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
  FGridTV.Styles.Selection := TcxStyle.Create(nil);
  FGridTV.Styles.Selection.Color := $00C08000; //clGradientActiveCaption;


  FColCfg.AddGradItem(Self);
  FTypeClassList := TStringList.Create;

  FCdsSource := TClientDataSet.Create(nil);
  SetLength(FColList, 0);

  FBasicType := btNo;
  FCanEdit := False;
  FShowMaxRow := True;
end;

destructor TGridItem.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FColList) - 1 do
  begin
    FColList[i].Free;
  end;

  FCdsSource.Free;
  FTypeClassList.Free;
  inherited;
end;

procedure TGridItem.XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
var
  FValue: string;
  FBounds: TRect;
begin
  if (AViewInfo is TcxGridIndicatorHeaderItemViewInfo) then
  begin
    FValue := '序号';  
  end
  else if (AViewInfo is TcxGridIndicatorRowItemViewInfo) then
  begin
    FValue := IntToStr(TcxGridIndicatorRowItemViewInfo(AViewInfo).GridRecord.Index + 1);

    if Assigned(FTypeClassList) then
    begin
      if FTypeClassList.IndexOf(FValue) >= 0 then
        FValue := FValue + '*';
    end;
  end
  else if (AViewInfo is TcxGridIndicatorFooterItemViewInfo) then
  begin
    FValue := '合计';  
  end;

  FBounds := AViewInfo.Bounds;

  ACanvas.FillRect(FBounds);
  ACanvas.DrawComplexFrame(FBounds, clBlack, clBlack, [bBottom, bLeft, bRight], 1);
  
  InflateRect(FBounds, -3, -2);
  ACanvas.Font.Color := clBlack;
  ACanvas.Brush.Style := bsClear;
  ACanvas.DrawText(FValue, FBounds, cxAlignCenter or cxAlignTop);
  ADone := True;
end;

procedure TGridItem.InitGridData;
begin
  //设置公式
  InitExpression();

  FGridTV.DataController.RecordCount := MaxRowCount;
end;

function TGridItem.GetCellValue(ADBName: string; ARowIndex: Integer): Variant;
var
  aCol: Integer;
  aColItem: TColInfo;
  aFindCol: Boolean;
  aValue: OleVariant;
begin
  try
    aFindCol := False;
    for aCol := 0 to Length(FColList) - 1 do
    begin
      aColItem := FColList[aCol];
      if UpperCase(aColItem.FFieldName) = UpperCase(ADBName) then
      begin
        if aColItem.FColShowType  in [cfInt, cfFloat, cfPlusFloat, cfQty, cfPrice, cfTotal, cfDiscount, cfCheck, cfDatime] then
        begin
          Result := 0;
        end
        else
        begin
          Result := '';
        end;

        aValue := FGridTV.DataController.GetValue(ARowIndex, aColItem.FGridColumn.Index);
        aFindCol := True;

        if aValue <> null then
          Result := aValue;
          
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
  if GetBaseTypesLevels(BasicType) <= 1 then Exit;

  for aRowIndex := GetFirstRow to GetLastRow do
  begin
    aTypeId := GetCellValue(GetBaseTypeid(BasicType), aRowIndex);
    if StringEmpty(aTypeId) then Continue;
    
    aSonnum := FModelFun.GetLocalValue(BasicType, GetBaseTypeSonnumStr(BasicType), aTypeId);
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
  CdsSource.Data := ACdsData.Data;
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
    if FCanEdit and ShowMaxRow then
    begin
      if FGridTV.DataController.RecordCount < MaxRowCount then
      begin
        FGridTV.DataController.RecordCount := MaxRowCount;
      end;
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

  FCanEdit := ACellSelect;
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
  if not FCanEdit then;
    if LoadUpDownData(False) then Exit; //加载下一级数据
    
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

procedure TGridItem.AddField(ABasicType: TBasicType);
var
  aColInfo: TColInfo;
  aDelBtn: TcxEditButton;
begin
  if ABasicType = btPtype then
  begin
    AddField('PTypeId', 'PTypeId', -1);

    aColInfo := AddField('PFullname', '商品名称');
    aColInfo.FGridColumn.PropertiesClass := TcxButtonEditProperties;
    aColInfo.FBasicType := btPtype;
    aDelBtn :=(aColInfo.FGridColumn.Properties as TcxButtonEditProperties).Buttons.Add;
    aDelBtn.Kind := bkGlyph;
//    aDelBtn.Glyph.LoadFromFile('E:\Code\Delphi\wmpj\Img\delete_16px.bmp');
    DMApp.GetBitmap(imDelRow, aDelBtn.Glyph);

    (aColInfo.FGridColumn.Properties as TcxButtonEditProperties).OnButtonClick := ColumnPropertiesButtonClick; //关联点击事件

    aColInfo := AddField('PUsercode', '商品编码');
    aColInfo.GridColumn.Options.Editing := False;
  end
  else if ABasicType = btBtype then
  begin
    AddField('BTypeId', 'BTypeId', -1);
    AddField('BFullname', '单位名称');
    AddField('BUsercode', '单位编码');
  end
  else if ABasicType = btEtype then
  begin
    AddField('ETypeId', 'ETypeId', -1);
    AddField('EFullname', '职员名称');
    AddField('EUsercode', '职员编码');
  end
  else if ABasicType = btDtype then
  begin
    AddField('DTypeId', 'DTypeId', -1);
    AddField('DFullname', '部门名称');
    AddField('DUsercode', '部门编码');
  end
  else if ABasicType = btKtype then
  begin
    AddField('KTypeId', 'KTypeId', -1);
    AddField('KFullname', '仓库名称');
    AddField('KUsercode', '仓库编码');
  end
  else if ABasicType = btVtype then
  begin
    AddField('VTypeId', 'VTypeId', -1);
    AddField('VchType', 'VchType', -1, cfInt);
    AddField('VFullname', '单据类型', 100, cfString);
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
        case AButtonIndex of
          0: OnSelectBasic(FGrid, FColList[i].FBasicType, aSelectParam, aSelectOptions, aReturnArray, aReturnCount);
          1:
            begin
              if FColList[i].FBasicType = btPtype then
              begin
                SetCellValue('PTypeId', RowIndex, '');
                SetCellValue('PFullname', RowIndex, '');
                SetCellValue('PUsercode', RowIndex, '');
              end;
            end;
        else ;
        end;
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
  aFindCol: Boolean;
begin
  try
    aFindCol := False;
    for i := 0 to Length(FColList) - 1 do
    begin
      aFieldName := FColList[i].FFieldName;
      if UpperCase(aFieldName) = UpperCase(ADBName) then
      begin
        FGridTV.DataController.Values[ARowIndex, FColList[i].FGridColumn.Index] := AValue;
        aFindCol := True;
        Break;
      end;
    end;
  finally
    if not aFindCol then
    begin
      raise(SysService as IExManagement).CreateSysEx('设置表格列[' + ADBName + ']数据错误,请设置表格列字段！');
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
      Break;
    end;
  end;
end;

procedure TGridItem.ClearData;
begin
  FGridTV.DataController.RecordCount := 0;
  FGridTV.DataController.RecordCount := MaxRowCount;
end;

procedure TGridItem.GridColEditValueChanged(Sender: TObject);
var
  i, j, aIndex, aArgsIndex: Integer;
  aExpression, aExpFieldName, aFieldName, aFormula, aSetFied: string;
  aRow, aCol: Integer;
  aParamValue: Variant;
  aCalc: TCalcExpress;
  aArgs: array[0..100] of Extended; // array of arguments - variable values
  aVariables: TStringList;
begin
  aRow := RowIndex;
  if (aRow < GetFirstRow) or (aRow > GetLastRow) then Exit;

  GridPost();

  //计算公式
  for i := 0 to Length(FColList) - 1 do
  begin
    if FColList[i].FGridColumn <> FGridTV.Controller.FocusedColumn then Continue;
    
    aExpression := Trim(FColList[i].FExpression);
    if aExpression <> EmptyStr then
    begin
      aSetFied := Copy(aExpression, 1, Pos('=', aExpression) - 1);
      aExpression := Copy(aExpression, Pos('=', aExpression) + 1, Length(aExpression));

      aFormula := aExpression;
      aArgsIndex := 0;
      
      aVariables := TStringList.Create;
      try
        for j := 0 to Length(FColList) - 1 do
        begin
          aFieldName := FColList[j].FFieldName;
          aExpFieldName := '[' + aFieldName + ']';
          aIndex := Pos(aExpFieldName, aExpression);
          if aIndex > 0 then
          begin
            aParamValue := GetCellValue(aFieldName, aRow);
            if VarIsNull(aParamValue) then Exit;

            aVariables.Add(aFieldName);
            aArgs[aArgsIndex] := aParamValue;
            Inc(aArgsIndex);
          end;
        end;
        aFormula := StringReplace(aFormula, '[', '', [rfReplaceAll]);
        aFormula := StringReplace(aFormula, ']', '', [rfReplaceAll]);

        aCalc := TCalcExpress.Create;
        try
          aCalc.Formula := aFormula;
          aCalc.Variables := aVariables;

          try
             SetCellValue(aSetFied, aRow, aCalc.calc(aArgs));
          except
            SetCellValue(aSetFied, aRow, 0);
          end;
//          SetCellValue(FColList[i].FFieldName, aRow, aCalc.calc(aArgs));
        finally
          aCalc.Free;
        end;
      finally
        aVariables.Free;
      end;
    end;
  end;
end;

procedure TGridItem.InitExpression;
var
  i, j, aIndex: Integer;
  aExpression, aFieldName: string;
begin
  //设置公式
  for i := 0 to Length(FColList) - 1 do
  begin
    aExpression := Trim(FColList[i].FExpression);
    if aExpression <> EmptyStr then
    begin
      FColList[i].FGridColumn.Properties.OnEditValueChanged := GridColEditValueChanged;

      for j := 0 to Length(FColList) - 1 do
      begin
        aFieldName := FColList[j].FFieldName;
        aFieldName := '[' + aFieldName + ']';
        aIndex := Pos(aFieldName, aExpression);
        if aIndex > 0 then
        begin
          FColList[j].FGridColumn.Properties.OnEditValueChanged := GridColEditValueChanged;
        end;
      end;
    end;
  end;
end;

procedure TGridItem.GridPost;
begin
  FGridTV.DataController.Post; //必须先提交，不然修改和取值的数据会乱
end;

function TGridItem.FindColByCaption(AShowCaption: string): TColInfo;
var
  i: Integer;
  aCaption: string;
begin
  Result := nil;
  for i := 0 to Length(FColList) - 1 do
  begin
    aCaption := Trim(FColList[i].GridColumn.Caption);
    if AShowCaption = aCaption then
    begin
      Result := FColList[i];
      Exit;
    end;
  end;
end;


function TGridItem.FindColByFieldName(AFieldName: string): TColInfo;
var
  i: Integer;
  aColDBName: string;
begin
  Result := nil;
  for i := 0 to Length(FColList) - 1 do
  begin
    aColDBName := Trim(FColList[i].FFieldName);
    if AFieldName = aColDBName then
    begin
      Result := FColList[i];
      Exit;
    end;
  end;
end;

function TGridItem.LoadUpDownData(ALoadUp: Boolean): Boolean;
var
  aRowIndex: Integer;
  aTypeId, aSonnum, aParTypeId: string;
begin
  Result := False;
  if GetBaseTypesLevels(BasicType) <= 1 then Exit;

  aRowIndex := GetRowIndex;

  if (aRowIndex >= GetFirstRow) and (aRowIndex <= GetLastRow) then
  begin
    aTypeId := GetCellValue(GetBaseTypeid(BasicType), aRowIndex);

    if StringEmpty(aTypeId) then Exit;

    if ALoadUp then
    begin
      //进入上一级
      aParTypeId := FModelFun.GetParIdFromId(BasicType, aTypeId);
      if aParTypeId = ROOT_ID then Exit;
      aTypeId := FModelFun.GetParIdFromId(BasicType, aParTypeId);
    end
    else
    begin
      //进入下一级
      aSonnum := FModelFun.GetLocalValue(BasicType, GetBaseTypeSonnumStr(BasicType), aTypeId);
      if StringToInt(aSonnum) <= 0 then Exit;
    end;
  end;

  if Assigned(OnLoadUpDownData) then
  begin
    OnLoadUpDownData(Self, aTypeId);
  end;

  Result := True;
end;

procedure TGridItem.AddFooterSummary(AColInfo: TColInfo;
  ASummaryKind: TcxSummaryKind);
var
  aFooter: TcxDataSummaryItem;
begin
  aFooter := FGridTV.DataController.Summary.FooterSummaryItems.Add;
  aFooter.Kind := ASummaryKind;
  TcxGridTableSummaryItem(aFooter).Column := AColInfo.GridColumn;

  FGridTV.OptionsView.Footer := True;
end;

function TGridItem.AddRow: Integer;
var
  aRecordCount: Integer;
begin
  aRecordCount :=  FGridTV.DataController.RecordCount + 1;
  if aRecordCount > MaxRowCount then
  begin
    raise(SysService as IExManagement).CreateSysEx('超过表格最大行数，不能在增加行！');
  end;
  FGridTV.DataController.RecordCount := aRecordCount;
  Result := aRecordCount - 1;
end;

function TGridItem.RecordCount: Integer;
begin
  Result := FGridTV.DataController.RecordCount;
end;

procedure TGridItem.DeleteRow(ARow: Integer);
begin
  FGridTV.DataController.DeleteRecord(ARow);
end;

function TGridItem.AddBtnCol(AFileName, AShowCaption, ABtnCaption: string; AClickEvent: TcxEditButtonClickEvent): TColInfo;
var
  aCol: TcxGridColumn;
  aColInfo: TColInfo;
begin
  aCol := FGridTV.CreateColumn;
  aCol.Caption := AShowCaption;
  aCol.PropertiesClass := TcxButtonEditProperties;
  aCol.Options.ShowEditButtons := isebAlways;

  TcxButtonEditProperties(aCol.Properties).Buttons[0].Caption := ABtnCaption;
  TcxButtonEditProperties(aCol.Properties).Buttons[0].Kind := bkText;
  TcxButtonEditProperties(aCol.Properties).OnButtonClick := AClickEvent;
  
  aColInfo := TColInfo.Create(aCol, AFileName);
  SetLength(FColList, Length(FColList) + 1);
  FColList[Length(FColList) - 1] := aColInfo;
  Result := aColInfo;
end;


procedure TGridItem.SetReadOnly(AReadOnly: Boolean);
begin
  FGridTV.OptionsData.Editing := not AReadOnly;
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

procedure TColInfo.AddExpression(AExpression: string);
begin
  FExpression := Trim(AExpression);
end;

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

