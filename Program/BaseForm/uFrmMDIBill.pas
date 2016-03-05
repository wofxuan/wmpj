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
    FBillSaveState: TBillSaveState; //���ݱ�������״̬
    FBillOpenState: TBillOpenState; //��������ʲô״̬��
    
  protected
    FVchcode, FVchtype: Integer;//����ID����������
    FModelBill: IModelBill;
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    
    procedure InitParamList; override;
    procedure SetTitle(const Value: string); override;

    function LoadBillDataMaster: Boolean; virtual;//���ر�ͷ����
    function LoadBillDataGrid: Boolean; virtual;//���ر������

    procedure InitMasterTitles(Sender: TObject); virtual; //��ʼ����ͷ
    procedure InitGrids(Sender: TObject); virtual; //��ʼ������
    procedure InitMenuItem(Sender: TObject); virtual; //��ʼ���ҽ��˵�
    procedure InitOthers(Sender: TObject); virtual; ////��ʼ������

    function BeforeSaveBill(ASaveState: TBillSaveState): Boolean; virtual;
    function SaveBillData(ASaveState: TBillSaveState; APrint: Boolean = false): Boolean; virtual;
    function SaveRecBillData(ABillSaveType: TBillSaveState): Integer; //���浥��
    function SaveToDraft: Boolean; virtual; //��ݸ�
    function SaveToSettle: Boolean; virtual; //�����
    function SaveMasterData(const ABillMasterData: TBillData): Integer; virtual; //����������Ϣ
    function SaveDetailData(const ABillDetailData: TPackData): Integer; virtual; //����ӱ���Ϣ
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; virtual; //���������Ϣ

    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; virtual;//����һ����¼
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
end;

function TfrmMDIBill.BeforeSaveBill(ASaveState: TBillSaveState): Boolean;
begin

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

end;

function TfrmMDIBill.SaveToSettle: Boolean;
begin

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
    FVchcode := 0;
    BillOpenState := bosNew;
    LoadBillDataMaster();
    LoadBillDataGrid();
  end;
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

end.
