unit uFrmBillPRMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, uBillData, uPackData, uBaseInfoDef,
  uModelFunIntf, uGridConfig, cxSplitter, uDefCom;

type
  TfrmBillPRMoney = class(TfrmMDIBill)
    lblBtype: TcxLabel;
    edtBtype: TcxButtonEdit;
    lbl2: TcxLabel;
    edtEtype: TcxButtonEdit;
    lbl3: TcxLabel;
    edtDtype: TcxButtonEdit;
    lbl6: TcxLabel;
    edtSummary: TcxButtonEdit;
    lbl7: TcxLabel;
    edtComment: TcxButtonEdit;
    pnlBottom: TPanel;
    gridBill: TcxGrid;
    gridTVBill: TcxGridTableView;
    gridLVBill: TcxGridLevel;
    pnlBT: TPanel;
    cdsBill: TClientDataSet;
    spltrM: TcxSplitter;
  private
    { Private declarations }
    FGridBill: TGridItem;

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;

    procedure InitMasterTitles(Sender: TObject); override;
    procedure InitGrids(Sender: TObject); override;

    function LoadBillDataGrid: Boolean; override;

    function SaveMasterData(const ABillMasterData: TBillData): Integer; override;
    function SaveDetailData(const ABillDetailData: TPackData): Integer; override;
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; override;
    function LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; override;

    function SaveDraftData(ADraft: TBillSaveState): Integer; override;//保存草稿或过账

    procedure LoadGathering(ABTypeID: string);//加载单位对应点单据
    function SaveGathering(AGatheringVchCode: Integer): Integer;//保存结算的信息
  protected
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); override;
  public
    { Public declarations }
  end;

var
  frmBillPRMoney: TfrmBillPRMoney;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uFrmApp, uModelBillIntf, uVchTypeDef, uPubFun;

{$R *.dfm}

{ TfrmBillOrder }

procedure TfrmBillPRMoney.BeforeFormDestroy;
begin
  inherited;
  FGridBill.Free;
end;

procedure TfrmBillPRMoney.BeforeFormShow;
begin
  FModelBill := IModelBillPRMoney((SysService as IModelControl).GetModelIntf(IModelBillPRMoney));

  FGridBill := TGridItem.Create(fnPRMoney, gridBill, gridTVBill);
  FGridBill.SetGridCellSelect(True);
  FGridBill.ShowMaxRow := False;
  inherited;
end;

procedure TfrmBillPRMoney.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
  if  Sender = gridMainShow then
  begin
    ASelectOptions := ASelectOptions + [opMultiSelect]
  end;
  inherited;
  if Sender = gridMainShow then
  begin
    if AReturnCount >= 1 then
    begin
      if ABasicType = btPtype then
      begin
        LoadPtype(ABasicDatas);
      end
    end;
  end
  else if Sender = edtBtype then
  begin
    if AReturnCount >= 1 then
    begin
      if ABasicType = btBtype then
      begin
        LoadGathering(ABasicDatas[0].TypeId);
      end
    end;
  end;
end;

procedure TfrmBillPRMoney.InitGrids(Sender: TObject);
var
  aColInfo: TColInfo;
begin
  inherited;
  FGridItem.ClearField();
//  FGridItem.AddField(btPtype);

  FGridItem.AddField('Total', '金额', 100, cfTotal);
  FGridItem.InitGridData;

  FGridBill.ClearField();
  aColInfo := FGridBill.AddField('VchType', 'VchType', -1, cfInt);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('VchCode', 'VchCode', -1, cfInt);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('Number', '单据编号', 100, cfString);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('InputDate', '日期', 100, cfDate);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('Summary', '摘要', 100, cfString);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('JETotal', '金额', 100, cfTotal);
  aColInfo.GridColumn.Options.Editing := False;
  aColInfo := FGridBill.AddField('YETotal', '余额', 100, cfTotal);
  aColInfo.GridColumn.Options.Editing := False;
  FGridBill.AddField('JSTotal', '结算金额', 100, cfTotal);
  FGridBill.AddCheckBoxCol('IsSelect', '选择', 1, 0);
  FGridBill.InitGridData;
end;

procedure TfrmBillPRMoney.InitMasterTitles(Sender: TObject);
begin
  inherited;
  case FVchType of
    VchType_Gathering:
      begin
        Title := '收款单';
        lblBtype.Caption := '收款单位';
        MoudleNo := fnMdlBillGathering;
      end;
    VchType_Payment:
      begin
        Title := '付款单';
        lblBtype.Caption := '付款单位';
        MoudleNo := fnMdlBillPayment;
      end;
  end;

  DBComItem.AddItem(deBillDate, 'InputDate');
  DBComItem.AddItem(edtBillNumber, 'Number');

  DBComItem.AddItem(edtBtype, 'BTypeId', 'BTypeId', 'BUsercode', btBtype);
  DBComItem.AddItem(edtEtype, 'ETypeId', 'ETypeId', 'EUsercode', btEtype);
  DBComItem.AddItem(edtDtype, 'DTypeId', 'DTypeId', 'DUsercode', btDtype);

  DBComItem.AddItem(edtSummary, 'Summary');
  DBComItem.AddItem(edtComment, 'Comment');
end;

function TfrmBillPRMoney.LoadBillDataGrid: Boolean;
var
  szSql, szTemp: string;
begin
  inherited LoadBillDataGrid;
end;

procedure TfrmBillPRMoney.LoadGathering(ABTypeID: string);
var
  aParam: TParamObject;
begin
  aParam := TParamObject.Create;
  try
    aParam.Add('@BTypeID', ABTypeID);
    aParam.Add('@ETypeID', '');
    aParam.Add('@StartDate', '');
    aParam.Add('@EndDate', '');
    aParam.Add('@VchType', FVchType);
    aParam.Add('@OperatorID', OperatorID);
    IModelBillPRMoney(FModelBill).QryBalance(aParam, cdsBill);
    FGridBill.LoadData(cdsBill);
  finally
    aParam.Free;
  end;
end;

function TfrmBillPRMoney.LoadOnePtype(ARow: Integer; AData: TSelectBasicData;
  IsImport: Boolean): Boolean;
begin
  FGridItem.SetCellValue(GetBaseTypeid(btPtype), ARow, AData.TypeId);
  FGridItem.SetCellValue(GetBaseTypeFullName(btPtype), ARow, AData.FullName);
  FGridItem.SetCellValue(GetBaseTypeUsercode(btPtype), ARow, AData.Usercode);
end;

function TfrmBillPRMoney.LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
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
        if StringEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), j)) then Break;
      end;
      if j >= FGridItem.GetLastRow then exit;
      LoadOnePtype(j, ABasicDatas[i])
    end;
  end;
end;

function TfrmBillPRMoney.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmBillPRMoney.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
var
  aPackData: TParamObject;
  aRow: Integer;
  aPrice, aTotal, aQty: Extended;
begin
  ABillDetailData.ProcName := 'pbx_Bill_Is_PRMoney_D';
  for aRow := FGridItem.GetFirstRow to FGridItem.GetLastRow do
  begin
//    if StringEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow)) then Continue;

    aTotal := FGridItem.GetCellValue('Total', aRow);

    if aTotal = 0 then Continue;
    
    aPackData := ABillDetailData.AddChild();
    aPackData.Add('@ColRowNo', IntToStr(aRow + 1));
    aPackData.Add('@AtypeId', '000010000300001');
    aPackData.Add('@BtypeId', '');
    aPackData.Add('@EtypeId', '');
    aPackData.Add('@DtypeId', '');
    aPackData.Add('@KtypeId', '');
    aPackData.Add('@KtypeId2', '');
    aPackData.Add('@PtypeId', '');
    aPackData.Add('@CostMode', 0);
    aPackData.Add('@UnitRate', 1);
    aPackData.Add('@Unit', 0);
    aPackData.Add('@Blockno', '');
    aPackData.Add('@Prodate', '');
    aPackData.Add('@UsefulEndDate', '');
    aPackData.Add('@Jhdate', '');
    aPackData.Add('@GoodsNo', 0);
    aPackData.Add('@Qty', 0);
    aPackData.Add('@Price', 0);
    aPackData.Add('@Total', aTotal);
    aPackData.Add('@Discount', 1);
    aPackData.Add('@DiscountPrice', 0);
    aPackData.Add('@DiscountTotal', aTotal);
    aPackData.Add('@TaxRate', 1);
    aPackData.Add('@TaxPrice', 0);
    aPackData.Add('@TaxTotal', aTotal);
    aPackData.Add('@AssQty', 0);
    aPackData.Add('@AssPrice', 0);
    aPackData.Add('@AssDiscountPrice', 0);
    aPackData.Add('@AssTaxPrice', 0);
    aPackData.Add('@CostTotal', aTotal);
    aPackData.Add('@CostPrice', 0);
    aPackData.Add('@OrderCode', 0);
    aPackData.Add('@OrderDlyCode', 0);
    aPackData.Add('@OrderVchType', 0);
    aPackData.Add('@Comment', '');
    aPackData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
    aPackData.Add('@Usedtype', '1');
    aPackData.Add('@Period', 1);
    aPackData.Add('@PStatus', 0);
    aPackData.Add('@YearPeriod', 1);
  end;
end;

function TfrmBillPRMoney.SaveDraftData(ADraft: TBillSaveState): Integer;
var
  aRet: Integer;
begin
  aRet := inherited SaveDraftData(ADraft);
  if aRet = 0 then
  begin
    aRet := SaveGathering(FNewVchCode);
  end;
  Result := aRet;
end;

function TfrmBillPRMoney.SaveGathering(AGatheringVchCode: Integer): Integer;
var
  aParam: TParamObject;
  aRow: Integer;
begin
  aParam := TParamObject.Create;
  try
    for aRow := FGridBill.GetFirstRow to FGridBill.GetLastRow do
    begin
      if FGridBill.GetCellValue('IsSelect', aRow) = 1 then
      begin
        aParam.Clear;
        aParam.Add('@BTypeID', DBComItem.GetItemValue(edtBtype));
        aParam.Add('@VchCode', FGridBill.GetCellValue('VchCode', aRow));
        aParam.Add('@VchType', FGridBill.GetCellValue('VchType', aRow));
        aParam.Add('@GatheringVchCode', AGatheringVchCode);
        aParam.Add('@Total', FGridBill.GetCellValue('JSTotal', aRow));
        aParam.Add('@DoTypt', 1);

        Result := IModelBillPRMoney(FModelBill).SaveBalance(aParam);
      end;
    end;
  finally
    aParam.Free;
  end;
end;

function TfrmBillPRMoney.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin
  ABillMasterData.ProcName := 'pbx_Bill_Is_PRMoney_M';
  ABillMasterData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
  ABillMasterData.Add('@Number', DBComItem.GetItemValue(edtBillNumber));
  ABillMasterData.Add('@VchType', FVchType);
  ABillMasterData.Add('@Summary', DBComItem.GetItemValue(edtSummary));
  ABillMasterData.Add('@Comment', DBComItem.GetItemValue(edtComment));
  ABillMasterData.Add('@Btypeid', DBComItem.GetItemValue(edtBtype));
  ABillMasterData.Add('@Etypeid', DBComItem.GetItemValue(edtEtype));
  ABillMasterData.Add('@Dtypeid', DBComItem.GetItemValue(edtDtype));
  ABillMasterData.Add('@Ktypeid', '');
  ABillMasterData.Add('@Ktypeid2', '');
  ABillMasterData.Add('@Period', 1);
  ABillMasterData.Add('@YearPeriod', 1);
  ABillMasterData.Add('@Total', 0);
  ABillMasterData.Add('@RedWord', 'F');
  ABillMasterData.Add('@Defdiscount', 1);
  ABillMasterData.Add('@GatheringDate', '');
end;

initialization
  gFormManage.RegForm(TfrmBillPRMoney, fnMdlBillGathering);
  gFormManage.RegForm(TfrmBillPRMoney, fnMdlBillPayment);

end.
