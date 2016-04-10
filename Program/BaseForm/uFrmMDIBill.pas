unit uFrmMDIBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxLabel, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, uDefCom, uBillData, uPackData,
  uModelBaseIntf, uModelFunIntf;

type
  TfrmMDIBill = class(TfrmMDI)
    pnlBillTitle: TPanel;
    pnlBillMaster: TPanel;
    lblBillTitle: TcxLabel;
    edtBillNumber: TcxButtonEdit;
    deBillDate: TcxDateEdit;
    lblBillDate: TcxLabel;
    lblBillNumber: TcxLabel;
    btnNewBill: TdxBarLargeButton;
    actNewBill: TAction;
    bpmSave: TdxBarPopupMenu;
    btnSaveDraft: TdxBarButton;
    btnSaveSettle: TdxBarButton;
    btnSave: TdxBarLargeButton;
    actSaveDraft: TAction;
    actSaveSettle: TAction;
    procedure actSaveDraftExecute(Sender: TObject);
    procedure actSaveSettleExecute(Sender: TObject);
  private
    { Private declarations }
    FBillSaveState: TBillSaveState; //单据保存类型状态
    FBillOpenState: TBillOpenState; //单据是以什么状态打开
    
  protected
    FVchCode, FVchType: Integer;//单据ID，单据类型
    FModelBill: IModelBill;
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    
    procedure InitParamList; override;
    procedure SetTitle(const Value: string); override;

    function LoadBillData: Boolean; virtual;//加载单据
    function LoadBillDataMaster: Boolean; virtual;//加载表头数据
    function LoadBillDataGrid: Boolean; virtual;//加载表格数据

    procedure InitMasterTitles(Sender: TObject); virtual; //初始化表头
    procedure InitGrids(Sender: TObject); virtual; //初始化表体
    procedure InitMenuItem(Sender: TObject); virtual; //初始化右建菜单
    procedure InitOthers(Sender: TObject); virtual; ////初始化其它

    function BeforeSaveBill(ASaveState: TBillSaveState): Boolean; virtual;

    function CheckSaveBillData(ASaveState: TBillSaveState): Boolean; virtual;//保存前检查数据
    
    function SaveBillData(ASaveState: TBillSaveState; APrint: Boolean = false): Boolean; virtual;
    function SaveRecBillData(ABillSaveType: TBillSaveState): Integer; //保存单据
    function SaveToDraft: Boolean; virtual; //存草稿
    function SaveToSettle: Boolean; virtual; //存过账
    function SaveDraftData(ADraft: TBillSaveState): Integer;//保存草稿
    function SaveMasterData(const ABillMasterData: TBillData): Integer; virtual; //保存主表信息
    function SaveDetailData(const ABillDetailData: TPackData): Integer; virtual; //保存从表信息
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; virtual; //保存财务信息

    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; virtual;//加载一条记录

    procedure GetBillNumber;
    procedure SetQtyPriceTotal(ATotal, AQty, APrice: string);//设置数量单价金额的公式
  public
    { Public declarations }
     property BillSaveState: TBillSaveState read FBillSaveState write FBillSaveState;
     property BillOpenState: TBillOpenState read FBillOpenState write FBillOpenState; 

  end;

var
  frmMDIBill: TfrmMDIBill;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uBaseInfoDef, uGridConfig, uFrmApp, uVchTypeDef;

{$R *.dfm}

{ TfrmMDIBill }

procedure TfrmMDIBill.BeforeFormDestroy;
begin
  inherited;

end;

procedure TfrmMDIBill.BeforeFormShow;
begin
  inherited;
  BillSaveState := sbNone;
  if ParamList.Count = 0 then
  begin
    FVchtype := VchType_Order_Sale;
    FVchcode := 0;
    BillOpenState := bosNew;
  end
  else
  begin
    FVchtype := ParamList.AsInteger('Vchtype');
    FVchcode := ParamList.AsInteger('Vchcode');
    BillOpenState := TBillOpenState(ParamList.AsInteger('bosState'));
  end;

  FGridItem.SetGridCellSelect(True);
  
  InitMasterTitles(Self);
  InitGrids(self);
  InitMenuItem(self);
  InitOthers(self);

  LoadBillData();
end;

function TfrmMDIBill.BeforeSaveBill(ASaveState: TBillSaveState): Boolean;
  var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  Result := False;

    // 具体单据中检查
  if not CheckSaveBillData(ASaveState) then Exit;

  aList := TParamObject.Create;
  try
    aList.Add('@DoWork', 1);
    aList.Add('@VchType', FVchType);
    aList.Add('@OldVchCode', FVchcode);
    aList.Add('@NewVchCode', 0);
    aList.Add('@BillDate', '');
    aList.Add('@VchNumberIn', edtBillNumber.Text);

    if FModelBill.GetVchNumber(aList) <> 0 then Exit
  finally
    aList.Free;
  end;

  Result := True;
end;

procedure TfrmMDIBill.InitGrids(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitMasterTitles(Sender: TObject);
begin
  deBillDate.Text := FormatdateTime('YYYY-MM-DD', Now);
end;

procedure TfrmMDIBill.InitMenuItem(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitOthers(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitParamList;
begin
  inherited;

end;

function TfrmMDIBill.LoadBillDataGrid: Boolean;
begin
  if FVchcode = 0 then //新单据
  begin
    FGridItem.ClearData;
  end
  else
  begin
    //加载单据
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

function TfrmMDIBill.LoadBillDataMaster: Boolean;
begin
  DBComItem.ClearItemData();
  if FVchCode = 0 then
  begin
    GetBillNumber();
  end;
end;

function TfrmMDIBill.SaveBillData(ASaveState: TBillSaveState;
  APrint: Boolean): Boolean;
begin
  if not BeforeSaveBill(ASaveState) then Exit;

  if ASaveState = soDraft then
  begin
    if not SaveToDraft() then Exit
  end
  else if ASaveState = soSettle then
  begin
    if not SaveToSettle() then Exit;
  end;

  if (BillOpenState = bosNew)then
  begin
    FVchcode := 0;
    LoadBillData();
  end;
end;

function TfrmMDIBill.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmMDIBill.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
begin

end;

function TfrmMDIBill.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin

end;

function TfrmMDIBill.SaveRecBillData(
  ABillSaveType: TBillSaveState): Integer;
begin

end;

function TfrmMDIBill.SaveToDraft: Boolean;
begin
  Result := False;
  if SaveDraftData(soDraft) = 0 then
  begin
    Result := True;
  end;
end;

function TfrmMDIBill.SaveToSettle: Boolean;
begin
  Result := False;
  if SaveDraftData(soSettle) = 0 then
  begin
    Result := True;
  end;
end;

procedure TfrmMDIBill.actSaveDraftExecute(Sender: TObject);
begin
  inherited;
  SaveBillData(soDraft);
end;

procedure TfrmMDIBill.actSaveSettleExecute(Sender: TObject);
begin
  inherited;
  SaveBillData(soSettle);
end;

function TfrmMDIBill.LoadOnePtype(ARow: Integer; AData: TSelectBasicData;
  IsImport: Boolean): Boolean;
begin

end;

procedure TfrmMDIBill.SetTitle(const Value: string);
begin
  inherited;
  lblBillTitle.Caption := Value;
end;

function TfrmMDIBill.SaveDraftData(ADraft: TBillSaveState): Integer;
var
  aBillData: TBillData;
  aOutPutData: TParamObject;
  aNewVchcode: Integer;
begin
  FGridItem.GridPost();
  Result := -1;
  aBillData := TBillData.Create;
  aOutPutData := TParamObject.Create;
  try
    aBillData.PRODUCT_TRADE := 0;
    aBillData.Draft := ADraft;
    aBillData.IsModi := false;
    aBillData.VchCode := FVchcode;
    aBillData.VchType := FVchtype;

    SaveMasterData(aBillData);
    SaveDetailData(aBillData.DetailData);
    SaveDetailAccount(aBillData.AccountData);
    aNewVchcode := FModelBill.SaveBill(aBillData, aOutPutData);
    if aNewVchcode >= 0 then
    begin
      Result := FModelBill.BillCreate(0, FVchType, aNewVchcode, aBillData.VchCode, aBillData.Draft, aOutPutData);
    end;
  finally
    aOutPutData.Free;
    aBillData.Free;
  end;
end;

function TfrmMDIBill.LoadBillData: Boolean;
begin
  LoadBillDataMaster();
  LoadBillDataGrid();
end;

procedure TfrmMDIBill.GetBillNumber;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  aList := TParamObject.Create;
  try
    aList.Add('@DoWork', 2);
    aList.Add('@VchType', FVchType);
    aList.Add('@OldVchCode', 0);
    aList.Add('@NewVchCode', 0);
    aList.Add('@BillDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
    aList.Add('@VchNumberIn', '');

    if FModelBill.GetVchNumber(aList) = 0 then
    begin
      edtBillNumber.Text := aList.AsString('@VchNumber');
    end;
  finally
    aList.Free;
  end;
end;

function TfrmMDIBill.CheckSaveBillData(
  ASaveState: TBillSaveState): Boolean;
begin
  Result := True;
end;

procedure TfrmMDIBill.SetQtyPriceTotal(ATotal, AQty, APrice: string);
var
  aColInfo: TColInfo;
begin
  aColInfo := FGridItem.FindColByFieldName(ATotal);
  aColInfo.AddExpression(AQty + '=[' + ATotal + ']/[' + APrice + ']');

  aColInfo := FGridItem.FindColByFieldName(AQty);
  aColInfo.AddExpression(ATotal + '=[' + AQty + ']*[' + APrice + ']');

  aColInfo := FGridItem.FindColByFieldName(APrice);
  aColInfo.AddExpression(ATotal + '=[' + AQty + ']*[' + APrice + ']');
end;

end.
