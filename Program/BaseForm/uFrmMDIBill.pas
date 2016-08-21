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
    actSelectBill: TAction;
    btnSelectBill: TdxBarLargeButton;
    procedure actSaveDraftExecute(Sender: TObject);
    procedure actSaveSettleExecute(Sender: TObject);
  private
    { Private declarations }
    FBillSaveState: TBillSaveState; //���ݱ�������״̬
    FBillOpenState: TBillOpenState; //��������ʲô״̬��
    FBillCurrState: TBillCurrState; //��ǰ���ݱ����ʲô״̬
    
  protected
    FVchCode, FVchType: Integer;//����ID����������
    FModelBill: IModelBill;
    FReadOnlyFlag: boolean;//�Ƿ��ܹ��޸ĵ���
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    
    procedure InitParamList; override;
    procedure SetTitle(const Value: string); override;

    function LoadBillData: Boolean; virtual;//���ص���
    function LoadBillDataMaster: Boolean; virtual;//���ر�ͷ����
    function LoadBillDataGrid: Boolean; virtual;//���ر������
    function GetLoadDSign: string; virtual; abstract;//�õ���ȡ������ϸ�ı�־

    procedure InitMasterTitles(Sender: TObject); virtual; //��ʼ����ͷ
    procedure InitGrids(Sender: TObject); virtual; //��ʼ������
    procedure InitMenuItem(Sender: TObject); virtual; //��ʼ���ҽ��˵�
    procedure InitOthers(Sender: TObject); virtual; ////��ʼ������

    function BeforeSaveBill(ASaveState: TBillSaveState): Boolean; virtual;
    procedure SetReadOnly(AReadOnly: Boolean = True); virtual;//���õ����Ƿ�ֻ��

    function CheckSaveBillData(ASaveState: TBillSaveState): Boolean; virtual;//����ǰ�������
    
    function SaveBillData(ASaveState: TBillSaveState; APrint: Boolean = false): Boolean; virtual;
    function SaveRecBillData(ABillSaveType: TBillSaveState): Integer; //���浥��
    function SaveToDraft: Boolean; virtual; //��ݸ�
    function SaveToSettle: Boolean; virtual; //�����
    function SaveDraftData(ADraft: TBillSaveState): Integer;//����ݸ�
    function SaveMasterData(const ABillMasterData: TBillData): Integer; virtual; //����������Ϣ
    function SaveDetailData(const ABillDetailData: TPackData): Integer; virtual; //����ӱ���Ϣ
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; virtual; //���������Ϣ

    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; virtual;//����һ����¼

    procedure GetBillNumber;
    procedure SetQtyPriceTotal(ATotal, AQty, APrice: string);//�����������۽��Ĺ�ʽ
  public
    { Public declarations }
     property BillSaveState: TBillSaveState read FBillSaveState write FBillSaveState;
     property BillOpenState: TBillOpenState read FBillOpenState write FBillOpenState;
     property BillCurrState: TBillCurrState read FBillCurrState write FBillCurrState;   

  end;

var
  frmMDIBill: TfrmMDIBill;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uBaseInfoDef, uGridConfig, uFrmApp, uVchTypeDef, uOtherIntf;

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

    // ���嵥���м��
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
var
  aInList: TParamObject;
  aCdsD: TClientDataSet;
  aBillState: Integer;
begin
  if FVchcode = 0 then //�µ���
  begin
    FGridItem.ClearData;
  end
  else
  begin
    //���ص���
    aInList := TParamObject.Create;
    aCdsD := TClientDataSet.Create(nil);
    try
      aInList.Add('VchCode', FVchCode);
      aInList.Add('VchType', FVchType);
      aBillState := Ord(BillOpenState);
      aInList.Add('BillState', Ord(BillOpenState));
      FModelBill.LoadBillDataDetail(aInList, aCdsD);
      FGridItem.LoadData(aCdsD);
    finally
      aCdsD.Free;
      aInList.Free;
    end;
  end;
end;

function TfrmMDIBill.LoadBillDataMaster: Boolean;
var
  aInList, aMasterList: TParamObject;
begin
  DBComItem.ClearItemData();
  if FVchCode = 0 then
  begin
    GetBillNumber();
  end
  else
  begin
    aInList := TParamObject.Create;
    aMasterList := TParamObject.Create;
    try
      aInList.Add('VchCode', FVchCode);
      aInList.Add('VchType', FVchType);
      FModelBill.LoadBillDataMaster(aInList, aMasterList);
      if aMasterList.Count = 0 then
      begin
        (SysService as IMsgBox).MsgBox('�õ��ݲ����ڣ������Ѿ���ɾ����');
        FrmClose();  
      end;
      DBComItem.GetDataFormParam(aMasterList);
    finally
      aMasterList.Free;
      aInList.Free;
    end;
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
  //���ص���
  if BillOpenState = bosNew then
  begin
    BillCurrState := bcsEdit;
    FReadOnlyFlag := False;
  end
  else if BillOpenState = bosEdit then
  begin
    BillCurrState := bcsEdit;
    FReadOnlyFlag := False;
  end
  else if (BillOpenState in [bosEdit, bosSett, bosModi]) then
  begin
    if BillOpenState <>  bosSett then
    begin
      BillCurrState := bcsEdit;
      FReadOnlyFlag := False;
    end
    else
    begin
      BillCurrState := bcsView;
      FReadOnlyFlag := True;
    end;
  end
  else if BillOpenState = bosView then 
  begin
    BillCurrState := bcsView; //�鿴ƾ֤
    FReadOnlyFlag := True;
    actSaveDraft.Enabled := False;
    actSaveSettle.Enabled := False;
    actSelectBill.Enabled := False;
  end
  else Exit; //�������
  
  LoadBillDataMaster();
  LoadBillDataGrid();

  SetReadOnly(FReadOnlyFlag);
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

procedure TfrmMDIBill.SetReadOnly(AReadOnly: Boolean);
begin
  DBComItem.SetReadOnly(nil, AReadOnly);
  FGridItem.SetGridCellSelect(not AReadOnly);
end;

end.
