unit uFrmMyFlow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, ComCtrls,
  cxTreeView, cxContainer, cxGroupBox, uGridConfig, cxTextEdit, cxMaskEdit,
  cxButtonEdit, uWmLabelEditBtn, StdCtrls, cxDropDownEdit, uModelFlowIntf, uFrmApp;

type
  TfrmMyFlow = class(TfrmMDI)
    btnAddFlowProcess: TdxBarLargeButton;
    btnViewFlow: TdxBarLargeButton;
    pnlFlow: TPanel;
    gridLVMyFlow: TcxGridLevel;
    gridMyFlow: TcxGrid;
    gridTVMyFlow: TcxGridTableView;
    cdsFlow: TClientDataSet;
    btnDel: TdxBarLargeButton;
  private
    { Private declarations }
    FGridFlow: TGridItem;
    FModelFlow: IModelFlow;

    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
    procedure FlowClick(Sender: TObject; AButtonIndex: Integer);
  public
    { Public declarations }
    class function GetMdlDisName: string; override;
  end;

var
  frmMyFlow: TfrmMyFlow;

implementation

{$R *.dfm}

uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uParamObject, uFunApp;

{ TfrmFlow }

procedure TfrmMyFlow.BeforeFormDestroy;
begin
  inherited;

  FGridFlow.Free;
end;

procedure TfrmMyFlow.BeforeFormShow;
begin
  inherited;
  Title := '我的审核';

  FModelFlow := IModelFlow((SysService as IModelControl).GetModelIntf(IModelFlow));
  FGridFlow := TGridItem.Create(ClassName + gridMyFlow.Name, gridMyFlow, gridTVMyFlow);
  FGridFlow.SetGridCellSelect(True);
  FGridFlow.ShowMaxRow := False;

  IniGridField();
  LoadGridData('');
end;

class function TfrmMyFlow.GetMdlDisName: string;
begin
  Result := '我的审核';
end;

procedure TfrmMyFlow.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridFlow.ClearField();
  FGridFlow.AddField('ProcePathID', 'ProcePathID', -1);
  FGridFlow.AddField('BillID', 'BillID', -1);
  FGridFlow.AddField('BillType', 'BillType', -1);
  FGridFlow.AddField('WorkID', 'WorkID', -1);
  aCol := FGridFlow.AddField('CEFullname', '创建人名称');
  aCol.GridColumn.Options.Editing := False;
  aCol := FGridFlow.AddField('CreateTime', '创建时间', 150);
  aCol.GridColumn.Options.Editing := False;
  aCol := FGridFlow.AddField('Info', '摘要信息', 350);
  aCol.GridColumn.Options.Editing := False;

  aCol := FGridFlow.AddBtnCol('cz', '操作', '审批', FlowClick);
  aCol.GridColumn.Width := 38;
  aCol.GridColumn.Options.HorzSizing := False;

  FGridFlow.InitGridData;
end;

procedure TfrmMyFlow.InitParamList;
begin
  inherited;
  MoudleNo := fnFlow;
end;


procedure TfrmMyFlow.LoadGridData(ATypeid: string);
var
  aParam: TParamObject;
begin
  inherited;
  aParam := TParamObject.Create;
  try
    aParam.Add('@QryType', Flow_ProcePath);
    aParam.Add('@Custom', OperatorID);
    FModelFlow.FlowData(aParam, cdsFlow);
    FGridFlow.LoadData(cdsFlow);
  finally
    aParam.Free;
  end;
end;

procedure TfrmMyFlow.FlowClick(Sender: TObject; AButtonIndex: Integer);
var
  aVchType, aVchCode, aProcePathID: Integer;
  aRowIndex: Integer;
begin
  inherited;
  aRowIndex := FGridFlow.RowIndex;
  if (aRowIndex < FGridFlow.GetFirstRow) or (aRowIndex > FGridFlow.GetLastRow) then
    Exit;

  aVchCode := FGridFlow.GetCellValue('BillID', aRowIndex);
  aVchType := FGridFlow.GetCellValue('BillType', aRowIndex);
  aProcePathID := FGridFlow.GetCellValue('ProcePathID', aRowIndex);

  OpenBillFrm(aVchType, aVchCode, aProcePathID, bosAudit);
end;

initialization
  gFormManage.RegForm(TfrmMyFlow, fnMdlMyFlow);
  
end.
