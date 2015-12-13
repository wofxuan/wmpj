unit uFrmBillBuy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, uBillData, uPackData, uBaseInfoDef,
  uModelFunIntf;

type
  TfrmBillBuy = class(TfrmMDIBill)
    lblBtype: TcxLabel;
    edtBtype: TcxButtonEdit;
    lbl2: TcxLabel;
    edtEtype: TcxButtonEdit;
    lbl3: TcxLabel;
    edtDtype: TcxButtonEdit;
    lbl4: TcxLabel;
    deGatheringDate: TcxDateEdit;
    lblKtype: TcxLabel;
    edtKtype: TcxButtonEdit;
    lbl6: TcxLabel;
    edtSummary: TcxButtonEdit;
    lbl7: TcxLabel;
    edtComment: TcxButtonEdit;
  private
    { Private declarations }
    procedure BeforeFormShow; override;

    procedure InitMasterTitles(Sender: TObject); override;
    procedure InitGrids(Sender: TObject); override;

    function LoadBillDataGrid: Boolean; override;

    function SaveToSettle: Boolean; override;
    function SaveMasterData(const ABillMasterData: TBillData): Integer; override;
    function SaveDetailData(const ABillDetailData: TPackData): Integer; override;
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; override;
    function LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; override;
  protected
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); override;
  public
    { Public declarations }
  end;

var
  frmBillBuy: TfrmBillBuy;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uDefCom, uGridConfig, uFrmApp, uModelBillIntf, uVchTypeDef;

{$R *.dfm}

{ TfrmBillOrder }

procedure TfrmBillBuy.BeforeFormShow;
begin
  FModelBill := IModelBillOrder((SysService as IModelControl).GetModelIntf(IModelBillBuy));
  inherited;
end;

procedure TfrmBillBuy.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
  if  Sender = gridMainShow then
  begin
    ASelectOptions := ASelectOptions + [opMultiSelect]
  end;
  inherited;
  if  Sender = gridMainShow then
  begin
    if AReturnCount >= 1 then
    begin
      if ABasicType = btPtype then
      begin
        LoadPtype(ABasicDatas);
      end
    end;
  end;
end;

procedure TfrmBillBuy.InitGrids(Sender: TObject);
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled(btPtype);
  FGridItem.AddFiled('Unit', '��λ');
  FGridItem.AddFiled('Qty', '����', 100, cfQty);
  FGridItem.AddFiled('Price', '����', 100, cfPrice);
  FGridItem.AddFiled('Total', '���', 100, cfTotal);
  FGridItem.AddFiled('Comment', '��ע');   
  FGridItem.InitGridData;
end;

procedure TfrmBillBuy.InitMasterTitles(Sender: TObject);
begin
  inherited;
  MoudleNo := FVchType;

  BillTitle := '������';
  lblBtype.Caption := '������λ';
  lblKtype.Caption := '�ջ��ֿ�';

  DBComItem.AddItem(deBillDate, 'InputDate');
  DBComItem.AddItem(edtBillNumber, 'Number');

  DBComItem.AddItem(edtBtype, 'BTypeId', 'BTypeId', 'BUsercode', btBtype);
  DBComItem.AddItem(edtEtype, 'ETypeId', 'ETypeId', 'EUsercode', btEtype);
  DBComItem.AddItem(edtDtype, 'DTypeId', 'DTypeId', 'DUsercode', btDtype);
  DBComItem.AddItem(edtKtype, 'KTypeId', 'KTypeId', 'KUsercode', btKtype);
  
  DBComItem.AddItem(deGatheringDate, 'GatheringDate');
  DBComItem.AddItem(edtSummary, 'Summary');
  DBComItem.AddItem(edtComment, 'Comment');
end;

function TfrmBillBuy.LoadBillDataGrid: Boolean;
var
  szSql, szTemp: string;
begin
  inherited LoadBillDataGrid;
  if FVchcode = 0 then //�µ���
  begin
    FGridItem.ClearData;
  end
  else
  begin
    //���ص���
//    if (nDraft = 1) or (nDraft > 3) then szTemp := GetDlyName(bosEdit, FVchType)
//    else szTemp := GetDlyName(BillOpenState, FVchType);
//    GridDataSet.Close;
//    LoadDly(szTemp, FVchCode, GridDataSet);
//    SetGridProperty(MainGrid);
//    LoadLoadBillDataUnitData;
//    ReadpgDetailData(MainGrid);
//    ReadSnDetailData(MainGrid);
  end;
end;

function TfrmBillBuy.LoadOnePtype(ARow: Integer; AData: TSelectBasicData;
  IsImport: Boolean): Boolean;
begin
  FGridItem.SetCellValue(GetBaseTypeid(btPtype), ARow, AData.TypeId);
  FGridItem.SetCellValue(GetBaseTypeFullName(btPtype), ARow, AData.FullName);
  FGridItem.SetCellValue(GetBaseTypeUsercode(btPtype), ARow, AData.Usercode);
end;

function TfrmBillBuy.LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
var
  i, j: Integer;
  s: string;
begin
  for i := 0 to Length(ABasicDatas) - 1 do
  begin
    if i = 0 then
    begin
      LoadOnePtype(FGridItem.RowIndex, ABasicDatas[i]);
    end
    else
    begin
      for j := FGridItem.RowIndex + 1 to FGridItem.GetLastRow - 1 do
      begin
        if VarIsEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), j)) then Break;
        if VarIsNull(FGridItem.GetCellValue(GetBaseTypeid(btPtype), j)) then Break;
        //if Trim() = EmptyStr then Break;
      end;
      if j >= FGridItem.GetLastRow then exit;
      LoadOnePtype(j, ABasicDatas[i])
    end;
  end;
end;

function TfrmBillBuy.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmBillBuy.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
var
  aPackData: TParamObject;
  aRow: Integer;
begin
  ABillDetailData.ProcName := 'pbx_Bill_Is_Buy_D';
  for aRow := FGridItem.GetFirstRow to FGridItem.GetLastRow do
  begin
    if VarIsEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow)) then Continue;
    if VarIsNull(FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow)) then Continue;

    aPackData := ABillDetailData.AddChild();
    aPackData.Add('@ColRowNo', IntToStr(aRow + 1));
    aPackData.Add('@AtypeId', '0000100001');
    aPackData.Add('@BtypeId', DBComItem.GetItemValue(edtBtype));
    aPackData.Add('@EtypeId', DBComItem.GetItemValue(edtEtype));
    aPackData.Add('@DtypeId', DBComItem.GetItemValue(edtDtype));
    aPackData.Add('@KtypeId', DBComItem.GetItemValue(edtKtype));
    aPackData.Add('@KtypeId2', '');
    aPackData.Add('@PtypeId', FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow));
    aPackData.Add('@CostMode', 1);
    aPackData.Add('@UnitRate', 1);
    aPackData.Add('@Unit', 1);
    aPackData.Add('@Blockno', '');
    aPackData.Add('@Prodate', '');
    aPackData.Add('@UsefulEndDate', '');
    aPackData.Add('@Jhdate', '');
    aPackData.Add('@GoodsNo', '1');
    aPackData.Add('@Qty', FGridItem.GetCellValue('Qty', aRow));
    aPackData.Add('@Price', FGridItem.GetCellValue('Price', aRow));
    aPackData.Add('@Total', FGridItem.GetCellValue('Total', aRow));
    aPackData.Add('@Discount', 1);
    aPackData.Add('@DiscountPrice', 2);
    aPackData.Add('@DiscountTotal', 3);
    aPackData.Add('@TaxRate', 4);
    aPackData.Add('@TaxPrice', 5);
    aPackData.Add('@TaxTotal', 6);
    aPackData.Add('@AssQty', FGridItem.GetCellValue('Qty', aRow));
    aPackData.Add('@AssPrice', FGridItem.GetCellValue('Price', aRow));
    aPackData.Add('@AssDiscountPrice', 7);
    aPackData.Add('@AssTaxPrice', 8);
    aPackData.Add('@CostTotal', 9);
    aPackData.Add('@CostPrice', 10);
    aPackData.Add('@OrderCode', 0);
    aPackData.Add('@OrderDlyCode', 0);
    aPackData.Add('@OrderVchType', 0);
    aPackData.Add('@Comment', 'ssss');
    aPackData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
    aPackData.Add('@Usedtype', '1');
    aPackData.Add('@Period', 0);
    aPackData.Add('@PStatus', 1);
    aPackData.Add('@YearPeriod', 1);
  end;
end;

function TfrmBillBuy.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin
  ABillMasterData.ProcName := 'pbx_Bill_Is_Buy_M';
  ABillMasterData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
  ABillMasterData.Add('@Number', DBComItem.GetItemValue(edtBillNumber));
  ABillMasterData.Add('@VchType', FVchType);
  ABillMasterData.Add('@Summary', DBComItem.GetItemValue(edtSummary));
  ABillMasterData.Add('@Comment', DBComItem.GetItemValue(edtComment));
  ABillMasterData.Add('@Btypeid', DBComItem.GetItemValue(edtBtype));
  ABillMasterData.Add('@Etypeid', DBComItem.GetItemValue(edtEtype));
  ABillMasterData.Add('@Dtypeid', DBComItem.GetItemValue(edtDtype));
  ABillMasterData.Add('@Ktypeid', DBComItem.GetItemValue(edtKtype));
  ABillMasterData.Add('@Ktypeid2', '');
  ABillMasterData.Add('@Period', 1);
  ABillMasterData.Add('@YearPeriod', 1);
  ABillMasterData.Add('@Total', 11);
  ABillMasterData.Add('@RedWord', 'F');
  ABillMasterData.Add('@Defdiscount', 1);
  ABillMasterData.Add('@GatheringDate', DBComItem.GetItemValue(deGatheringDate));
end;

function TfrmBillBuy.SaveToSettle: Boolean;
var
  aBillData: TBillData;
  aOutPutData: TParamObject;
  aNewVchcode: Integer;
begin
  Result := False;
  aBillData := TBillData.Create;
  aOutPutData := TParamObject.Create;
  try
    aBillData.PRODUCT_TRADE := 0;
    aBillData.Draft := Ord(soSettle);
    aBillData.IsModi := false;
    aBillData.VchCode := FVchcode;
    aBillData.VchType := FVchtype;

    SaveMasterData(aBillData);
    SaveDetailData(aBillData.DetailData);
    SaveDetailAccount(aBillData.AccountData);
    aNewVchcode := FModelBill.SaveBill(aBillData, aOutPutData);
    if aNewVchcode >= 0 then
    begin
      FModelBill.BillCreate(0, aBillData.Draft, FVchType, aNewVchcode, aBillData.VchCode, aOutPutData);
      Result := True;
    end;
  finally
    aOutPutData.Free;
    aBillData.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmBillBuy, fnMdlBillBuy);

end.
