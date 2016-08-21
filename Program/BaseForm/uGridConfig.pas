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
  cxGridDBTableView, cxGraphics, uBaseInfoDef, uModelBaseIntf, uModelFunIntf, cxEdit, uDefCom, cxCustomData, uOtherDefine;

const
  SpecialCharList: array[0..1] of string = ('[', ']');
  MaxRowCount = 500;

type
  //���Ԫ��˫���¼�
  TCellDblClickEvent = procedure(Sender: TcxCustomGridTableView;
    ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
    AShift: TShiftState; var AHandled: Boolean) of object;

  TGridEditKeyPressEvent = procedure(Sender: TcxCustomGridTableView;
    AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char) of object;

  TLoadUpDownDataEvent = procedure(Sender: TObject; ATypeid: String) of Object;
  
  //���ÿ�е���Ϣ
  TColInfo = class(TObject)
  private
    FGridColumn: TcxGridColumn;
    FFieldName: string;
    FColShowType: TColField; //�ֶ�����
    FBasicType: TBasicType; //����е�Ԫ���ʱ����ʾ����TC
    FExpression: string; //�Զ���Ĺ�ʽ bb*cc

    FDataToDisplay: TStringList; //�ֶ���ʾ���ѯ���ݶ�Ӧ�б�
    procedure GetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure AddExpression(AExpression: string);
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
    FCdsSource: TClientDataSet; //ͨ�����ݼ������ǵ����ݼ�
    FCanEdit: Boolean; //�Ƿ��ܹ��޸ĵ�Ԫ������

    FOnSelectBasic: TSelectBasicinfoEvent; //����TC��ѡ���
    FOldCellDblClick: TCellDblClickEvent; //���Ԫ��ԭ����˫���¼�
    FOldGridEditKey: TcxGridEditKeyEvent; //���Ԫ��ԭ���İ����¼�
    FOldGridEditKeyPress: TGridEditKeyPressEvent; //���Ԫ��ԭ���İ����¼�
    FOnLoadUpDownData: TLoadUpDownDataEvent; //������һ�������һ������

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
    procedure GridColEditValueChanged(Sender: TObject); //���ù�ʽ�ֶκ󣬵�Ԫ��ֵ�ı��¼�ʱ���㹫ʽ
    procedure InitExpression; //��ʼ����ʽ����
  public
    constructor Create(AGridID: Integer; AGrid: TcxGrid; AGridTV: TcxGridTableView);
    destructor Destroy; override;

    procedure ClearField; //��ձ�������������
    procedure ClearData; //��ձ�������������
    function AddField(AFileName, AShowCaption: string; AWidth: Integer = 100; AColShowType: TColField = cfString): TColInfo; overload;
    procedure AddField(ABasicType: TBasicType); overload;
    function AddCheckBoxCol(AFileName, AShowCaption: string; AValueChecked, ValueUnchecked: Variant): TColInfo;
    function GetCellValue(ADBName: string; ARowIndex: Integer): Variant; //��ȡ��Ԫ��ֵ
    procedure SetCellValue(ADBName: string; ARowIndex: Integer; AValue: Variant); //���õ�Ԫ��ֵ
    procedure InitGridData;
    procedure GridPost; //�ύ�޸ĵ�����

    function GetFirstRow: Integer; //��ȡ�е�����
    function GetLastRow: Integer; //��ȡ�е�ĩ��
    function SelectedRowCount: Integer; //ѡ�е�����
    procedure LoadData(ACdsData: TClientDataSet); //��������
    function LoadUpDownData(ALoadUp: Boolean): Boolean;//������һ��������һ������
    procedure SetGridCellSelect(ACellSelect: Boolean); //�Ƿ���ѡ�е�Ԫ��ʹ���������Ԫ����ѡ��״̬
    procedure SetGoToNextCellOnEnter(ANextCellOnEnter: Boolean); //�Ƿ��Ƿ�ͨ���س�����
    procedure MultiSelect(AMultiSelect: Boolean); //�Ƿ����ж�ѡ
    function FindColByCaption(AShowCaption: string): TColInfo; //���ݱ�ͷ������
    function FindColByFieldName(AFieldName: string): TColInfo; //�������ݿ��ֶ����Ʋ�����
    procedure AddFooterSummary(AColInfo: TColInfo; ASummaryKind: TcxSummaryKind); //����һ���ϼ����ֶ�
  published
    property BasicType: TBasicType read FBasicType write FBasicType;
    property RowIndex: Integer read GetRowIndex write SetRowIndex;
    property OnSelectBasic: TSelectBasicinfoEvent read FOnSelectBasic write FOnSelectBasic;
    property CdsSource: TClientDataSet read FCdsSource write FCdsSource;
    property OnLoadUpDownData: TLoadUpDownDataEvent read FOnLoadUpDownData write FOnLoadUpDownData;

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

uses uSysSvc, uOtherIntf, cxDataStorage, cxCheckBox, cxButtonEdit, cxTextEdit, uPubFun, Graphics, Variants, uCalcExpress;

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
      raise(SysService as IExManagement).CreateSysEx('�������ʾ����"' + AShowCaption + '"����,���������ã�');
    end;
  end;

  aCol := FGridTV.CreateColumn;
  aCol.Caption := AShowCaption;

  aCol.PropertiesClass := TcxTextEditProperties;
  aCol.Properties.Alignment.Vert := taVCenter; //��Ԫ���������¾���
  aCol.Options.Sorting := False; //��������
  
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
  FOldCellDblClick := FGridTV.OnCellDblClick;
  FGridTV.OnCellDblClick := GridCellDblClick;//�ڱ༭��Ԫ�����˫����ʱ���ܴ���
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

  FCdsSource := TClientDataSet.Create(nil);
  SetLength(FColList, 0);

  FBasicType := btNo;
  FCanEdit := False;
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
    FValue := '���';  
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
    FValue := '�ϼ�';  
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
  //���ù�ʽ
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
    if FCanEdit then
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
  //�Ƿ���ѡ�е�Ԫ��
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
    if LoadUpDownData(False) then Exit; //������һ������
    
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

    aColInfo := AddField('PFullname', '��Ʒ����');
    aColInfo.FGridColumn.PropertiesClass := TcxButtonEditProperties;
    aColInfo.FBasicType := btPtype;
    aDelBtn :=(aColInfo.FGridColumn.Properties as TcxButtonEditProperties).Buttons.Add;
    aDelBtn.Kind := bkGlyph;
//    aDelBtn.Glyph.LoadFromFile('E:\Code\Delphi\wmpj\Img\delete_16px.bmp');

    (aColInfo.FGridColumn.Properties as TcxButtonEditProperties).OnButtonClick := ColumnPropertiesButtonClick; //��������¼�

    AddField('PUsercode', '��Ʒ����');
  end
  else if ABasicType = btBtype then
  begin
    AddField('BTypeId', 'BTypeId', -1);
    AddField('BFullname', '��λ����');
    AddField('BUsercode', '��λ����');
  end
  else if ABasicType = btEtype then
  begin
    AddField('ETypeId', 'ETypeId', -1);
    AddField('EFullname', 'ְԱ����');
    AddField('EUsercode', 'ְԱ����');
  end
  else if ABasicType = btDtype then
  begin
    AddField('DTypeId', 'DTypeId', -1);
    AddField('DFullname', '��������');
    AddField('DUsercode', '���ű���');
  end
  else if ABasicType = btKtype then
  begin
    AddField('KTypeId', 'KTypeId', -1);
    AddField('KFullname', '�ֿ�����');
    AddField('KUsercode', '�ֿ����');
  end
  else if ABasicType = btVtype then
  begin
    AddField('VTypeId', 'VTypeId', -1);
    AddField('VchType', 'VchType', -1, cfInt);
    AddField('VFullname', '��������', 100, cfString);
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
      raise(SysService as IExManagement).CreateSysEx('���ñ����[' + ADBName + ']���ݴ���,�����ñ�����ֶΣ�');
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

  //���㹫ʽ
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
  //���ù�ʽ
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
  FGridTV.DataController.Post; //�������ύ����Ȼ�޸ĺ�ȡֵ�����ݻ���
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
      //������һ��
      aParTypeId := FModelFun.GetParIdFromId(BasicType, aTypeId);
      if aParTypeId = ROOT_ID then Exit;
      aTypeId := FModelFun.GetParIdFromId(BasicType, aParTypeId);
    end
    else
    begin
      //������һ��
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

