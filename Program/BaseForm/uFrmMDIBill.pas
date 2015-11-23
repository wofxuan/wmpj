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
    FBillTitle: string; //单据显示的标题
    FBillSaveState: TBillSaveState; //单据保存类型状态
    FBillOpenState: TBillOpenState; //单据是以什么状态打开

    procedure SetBillTitle(const Value: string);
  protected
    FVchcode, FVchtype: Integer; //单据ID，单据类型
    FModelBill: IModelBill;

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;

    procedure InitParamList; override;

    function LoadBillData(AVchType, AVchCode: Integer): Boolean; virtual;
    function LoadBillDataMaster: Boolean; virtual;
    function LoadBillDataGrid: Boolean; virtual;

    procedure InitMasterTitles(Sender: TObject); virtual; //初始化表头
    procedure InitGrids(Sender: TObject); virtual; //初始化表体
    procedure InitMenuItem(Sender: TObject); virtual; //初始化右建菜单
    procedure InitOthers(Sender: TObject); virtual; ////初始化其它

    function BeforeSaveBill(ASaveState: TBillSaveState): Boolean; virtual;
    function SaveBillData(ASaveState: TBillSaveState; APrint: Boolean = false): Boolean; virtual;
    function SaveRecBillData(ABillSaveType: TBillSaveState): Integer; //保存单据
    function SaveToDraft: Boolean; virtual; //存草稿
    function SaveToSettle: Boolean; virtual; //存过账
    function SaveMasterData(const ABillMasterData: TBillData): Integer; virtual; //保存主表信息
    function SaveDetailData(const ABillDetailData: TPackData): Integer; virtual; //保存从表信息
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; virtual; //保存财务信息

    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; virtual; //加载一条记录
  public
    { Public declarations }
    property BillTitle: string read FBillTitle write SetBillTitle;
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

  LoadBillData(FVchtype, FVchcode);
end;

function TfrmMDIBill.BeforeSaveBill(ASaveState: TBillSaveState): Boolean;
begin

end;

procedure TfrmMDIBill.InitGrids(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitMasterTitles(Sender: TObject);
begin
  DBComItem.AddItem(deBillDate, 'InputDate');
  DBComItem.AddItem(edtBillNumber, 'Number');
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

end;

function TfrmMDIBill.LoadBillDataMaster: Boolean;
begin

end;

function TfrmMDIBill.SaveBillData(ASaveState: TBillSaveState;
  APrint: Boolean): Boolean;
begin

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
  Result := True;
end;

function TfrmMDIBill.SaveToSettle: Boolean;
begin
  Result := True;
end;

procedure TfrmMDIBill.actSaveDraftExecute(Sender: TObject);
begin
  inherited;
  SaveToDraft();
end;

procedure TfrmMDIBill.actSaveSettleExecute(Sender: TObject);
begin
  inherited;
  if SaveToSettle() then
  begin
    LoadBillData(FVchtype, 0);
  end;
end;

procedure TfrmMDIBill.SetBillTitle(const Value: string);
begin
  FBillTitle := Value;
  lblBillTitle.Caption := Value;
  Caption := Value;
end;

function TfrmMDIBill.LoadOnePtype(ARow: Integer; AData: TSelectBasicData;
  IsImport: Boolean): Boolean;
begin

end;

function TfrmMDIBill.LoadBillData(AVchType, AVchCode: Integer): Boolean;
begin
  FVchtype := AVchtype;
  FVchcode := AVchcode;
  LoadBillDataMaster();
  LoadBillDataGrid();
end;

end.

