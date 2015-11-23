{***************************
�������
Ϊ�˼��ٱ�����ͣ����ݱ���λ�õ���ϣ� ����һģ�鶼�ɿ��ٵ��޸ĺ��滻
�ɷ�Ϊ�����߼���1����������ʾ��2�����Ʊ���е����ԣ�3������Ϣ��ȡ���洦��
mx 2014-11-28
****************************}
unit uGridConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Controls, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf, uModelOtherSet, cxEdit, uDefCom;

type
  //���Ԫ��˫���¼�
  TCellDblClickEvent = procedure(Sender: TcxCustomGridTableView;
    ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
    AShift: TShiftState; var AHandled: Boolean) of object;

  TGridEditKeyPressEvent = procedure(Sender: TcxCustomGridTableView;
    AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char) of object;

  //���ÿ�е���Ϣ
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;
    FColShowType: TColField; //�ֶ�����
    FBasicType: TBasicType; //����е�Ԫ���ʱ����ʾ����TC

    FDataToDisplay: TStringList; //�ֶ���ʾ���ѯ���ݶ�Ӧ�б�
    procedure GetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure SetDisplayText(ADisplayText: TIDDisplayText); //���ò�ѯ��������ʾ���ݵĶ�Ӧ��ϵ
    constructor Create(AGridColumn: TcxGridColumn; AFieldName: string);
    destructor Destroy; override;
  published
    property GridColumn: TcxGridColumn read FGridColumn write FGridColumn;

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
    FOnSelectBasic: TSelectBasicinfoEvent; //����TC��ѡ���
    FOldCellDblClick: TCellDblClickEvent; //���Ԫ��ԭ����˫���¼�
    FOldGridEditKey: TcxGridEditKeyEvent; //���Ԫ��ԭ���İ����¼�
    FOldGridEditKeyPress: TGridEditKeyPressEvent; //���Ԫ��ԭ���İ����¼�

    //������������
    procedure XHOnCustomDrawCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
    procedure ReClassList; //Ҫ���������������ɺ�ִ��.ˢ�±���¼ID��PSonnum,���ж��Ƿ�������ʾ*��ʱ����Ҫ�õ�
    procedure GridCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure GridEditKeyEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure GridEditKeyPressEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char); //���Ԫ�������¼�
    procedure ColumnPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer); //��ӻ�����Ϣʱ����Ԫ���ڵİ�ť����¼�
    function GetRowIndex: Integer; //��ȡ��ǰѡ�е���
    procedure SetRowIndex(Value: Integer); //����ѡ�е���
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField;
    procedure ClearGridData;//��ձ������
    function AddFiled(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TColField = cfString): TColInfo; overload;
    procedure AddFiled(ABasicType: TBasicType); overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant; //��ȡ��Ԫ��ֵ
    procedure SetCellValue(ADBName: string; ARowIndex: Integer; AValue: Variant); //���õ�Ԫ��ֵ
    procedure InitGridData;

    function GetFirstRow: Integer; //��ȡ�е�����
    function GetLastRow: Integer; //��ȡ�е�ĩ��
    function SelectedRowCount: Integer; //ѡ�е�����
    procedure LoadData(ACdsData: TClientDataSet); //��������
    procedure SetGridCellSelect(ACellSelect: Boolean); //�Ƿ���ѡ�е�Ԫ��ʹ���������Ԫ����ѡ��״̬
    procedure SetGoToNextCellOnEnter(ANextCellOnEnter: Boolean); //�Ƿ��Ƿ�ͨ���س�����
    procedure MultiSelect(AMultiSelect: Boolean); //�Ƿ����ж�ѡ
  published
    property BasicType: TBasicType read FBasicType write FBasicType;
    property RowIndex: Integer read GetRowIndex write SetRowIndex;
    property OnSelectBasic: TSelectBasicinfoEvent read FOnSelectBasic write FOnSelectBasic;

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
//    gctDate: aCol.DataBinding.ValueTypeClass := ;                      //����������ʲô��û���ҵ� 2014-12-02
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
//  FGridTV.OnCellDblClick := GridCellDblClick;//�ڱ༭��Ԫ�����˫����ʱ���ܴ���
  FOldGridEditKey := FGridTV.OnEditKeyDown; //������Ϣ��Ԫ��س���ʱ�򵯳�TC
  FGridTV.OnEditKeyDown := GridEditKeyEvent;

  FOldGridEditKeyPress := FGridTV.OnEditKeyPress; //�����ֶ����ͣ��ж��Ƿ��ܹ������ַ�
  FGridTV.OnEditKeyPress := GridEditKeyPressEvent;

  FModelFun := SysService as IModelFun;
  //��ʾ�кŵ���һ��
  FGridTV.OptionsView.Indicator := True;
  FGridTV.OptionsView.IndicatorWidth := 40;

  FGridTV.OptionsSelection.CellSelect := False; //�Ƿ���ѡ�е�Ԫ��
  FGridTV.OptionsView.NoDataToDisplayInfoText := 'û������'; //���û������ʱ��ʾ������
  FGridTV.OptionsView.GroupByBox := False; //����ʾ��ͷ�ķ��鹦��
  FGridTV.OptionsBehavior.FocusCellOnCycle := True; //�л�ʱ����ѭ��
  FGridTV.OptionsBehavior.GoToNextCellOnEnter := True; //ͨ���س��л���Ԫ��

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
      raise(SysService as IExManagement).CreateSysEx('��ȡ�����[' + ADBName + ']���ݴ���,�����ñ�����ֶΣ�');
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
  //�Ƿ���ѡ�е�Ԫ��
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

    aColInfo := AddFiled('PFullname', '��Ʒ����');
    aColInfo.FGridColumn.PropertiesClass := TcxButtonEditProperties;
    aColInfo.FBasicType := btPtype;
    (aColInfo.FGridColumn.Properties as TcxButtonEditProperties).OnButtonClick := ColumnPropertiesButtonClick; //��������¼�

    AddFiled('PUsercode', '��Ʒ����');
  end
  else if ABasicType = btBtype then
  begin
    AddFiled('BTypeId', 'BTypeId', -1);
    AddFiled('BFullname', '��λ����');
    AddFiled('BUsercode', '��λ����');
  end
  else if ABasicType = btEtype then
  begin
    AddFiled('ETypeId', 'ETypeId', -1);
    AddFiled('EFullname', 'ְԱ����');
    AddFiled('EUsercode', 'ְԱ����');
  end
  else if ABasicType = btDtype then
  begin
    AddFiled('DTypeId', 'DTypeId', -1);
    AddFiled('DFullname', '��������');
    AddFiled('DUsercode', '���ű���');
  end
  else if ABasicType = btKtype then
  begin
    AddFiled('KTypeId', 'KTypeId', -1);
    AddFiled('KFullname', '�ֿ�����');
    AddFiled('KUsercode', '�ֿ����');
  end
  else
  begin
    raise(SysService as IExManagement).CreateSysEx('û������[' + BasicTypeToString(ABasicType) + ']�˻�����Ϣ��Ӧ����,�����ã�');
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
  FGridTV.OptionsBehavior.FocusCellOnCycle := ANextCellOnEnter; //�л�ʱ����ѭ��
  FGridTV.OptionsBehavior.GoToNextCellOnEnter := ANextCellOnEnter; //ͨ���س��л���Ԫ��
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
      if aColInfo.FColShowType in [cfInt, cfPlusInt] then //������ʱ��
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

