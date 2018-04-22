unit uFrmFlowWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uModelFlowIntf,
  cxGroupBox, cxTextEdit, cxMemo, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, uGridConfig, DBClient, cxPC;

type
  TfrmFlowWork = class(TfrmDialog)
    btnAllow: TcxButton;
    btnBack: TcxButton;
    btnStop: TcxButton;
    actAllow: TAction;
    actBack: TAction;
    actStop: TAction;
    gbFlow: TcxGroupBox;
    mmoFlowInfo: TcxMemo;
    cdsFlow: TClientDataSet;
    pcView: TcxPageControl;
    tsHis: TcxTabSheet;
    tsList: TcxTabSheet;
    gridFlow: TcxGrid;
    gridTVFlow: TcxGridTableView;
    gridLVFlow: TcxGridLevel;
    procedure actAllowExecute(Sender: TObject);
    procedure actBackExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
  private
    { Private declarations }
    FModelFlow: IModelFlow;
    FGridFlow: TGridItem;
    
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure IniGridField;
    procedure LoadGridData;
    procedure DrawList;
    procedure FlowWork(ADoResult: TFlowDoResult);
  public
    { Public declarations }
  end;

var
  frmFlowWork: TfrmFlowWork;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uFrmFlowProcess, uParamObject;
     
{$R *.dfm}

{ TfrmFlowWork }

procedure TfrmFlowWork.BeforeFormDestroy;
begin
  inherited;
  FGridFlow.Free;
end;

procedure TfrmFlowWork.BeforeFormShow;
begin
  inherited;
  Title := '审批';
  FModelFlow := IModelFlow((SysService as IModelControl).GetModelIntf(IModelFlow));
  FGridFlow := TGridItem.Create(ClassName + gridFlow.Name, gridFlow, gridTVFlow);
  FGridFlow.ShowMaxRow := False;
  FGridFlow.SetGridCellSelect(False);

  IniGridField();
  LoadGridData();
  DrawList();
  
  pcView.ActivePageIndex := 0;
end;

procedure TfrmFlowWork.IniGridField;
var
  aCol: TColInfo;
begin
  FGridFlow.ClearField();
  FGridFlow.AddField('ProcessID', 'ProcessID', -1);
  FGridFlow.AddField('ProcesseName', '流程名称', 100, cfString);
  FGridFlow.AddField('EFullname', '审批人', 70, cfString);
  FGridFlow.AddField('CreateTime', '审批日期', 150, cfString);
  FGridFlow.AddField('FlowInfo', '审批意见', 200, cfString);

  aCol := FGridFlow.AddField('ProceResult', '审批结果', 80);
  aCol.SetDisplayText(TFlow_DoType);

  FGridFlow.InitGridData;
end;

procedure TfrmFlowWork.InitParamList;
begin
  inherited;
  MoudleNo := fnFlowWork;
end;

procedure TfrmFlowWork.LoadGridData;
var
  aParam: TParamObject;
begin
  inherited;
  aParam := TParamObject.Create;
  try
    aParam.Add('@QryType', Flow_His);

    aParam.Add('@BillID', ParamList.AsInteger('BillID'));
    aParam.Add('@BillType', ParamList.AsInteger('BillType'));
    aParam.Add('@WorkID', ParamList.AsString('WorkID'));
    
    FModelFlow.FlowData(aParam, cdsFlow);
    FGridFlow.LoadData(cdsFlow);
  finally
    aParam.Free;
  end;
end;

procedure TfrmFlowWork.FlowWork(ADoResult: TFlowDoResult);
var
  aProcePathID: Integer;
begin
  inherited;
  aProcePathID := ParamList.AsInteger('ProcePathID');
  if FModelFlow.DoOneFlow(aProcePathID, ADoResult, Trim(mmoFlowInfo.Text)) = 0 then
    ModalResult := mrOk;
end;


procedure TfrmFlowWork.actAllowExecute(Sender: TObject);
begin
  inherited;
  FlowWork(fdrAllow);
end;

procedure TfrmFlowWork.actBackExecute(Sender: TObject);
begin
  inherited;
  FlowWork(fdrBack);
end;

procedure TfrmFlowWork.actStopExecute(Sender: TObject);
begin
  inherited;
  FlowWork(fdrStop);
end;

procedure TfrmFlowWork.DrawList;
var
  aParam: TParamObject;
  aBtn: TcxButton;
  aLbl: TLabel;
  aWidth, aTop: Integer;
begin
  inherited;
  aParam := TParamObject.Create;
  try
    aParam.Add('@QryType', Flow_OneWork);

    aParam.Add('@BillID', ParamList.AsInteger('BillID'));
    aParam.Add('@BillType', ParamList.AsInteger('BillType'));
    aParam.Add('@WorkID', ParamList.AsString('WorkID'));
    
    FModelFlow.FlowData(aParam, cdsFlow);

    aWidth := 0;
    aTop := tsList.Height div 2 - 10;
    cdsFlow.First;
    while not cdsFlow.Eof do
    begin
      aBtn := TcxButton.Create(nil);
      aBtn.Parent := tsList;
//      aBtn.Owner := tsList;
      aBtn.Width := 50;
      aBtn.Height := 25;
      aBtn.Top := aTop;
      aBtn.Left := aWidth;
      aBtn.Caption := cdsFlow.FieldByName('EFullname').AsString;
      if cdsFlow.FieldByName('ProceResult').AsInteger = 1 then
        aBtn.Colors.Default := clGreen
      else if cdsFlow.FieldByName('ProceResult').AsInteger = 2 then
        aBtn.Colors.Default := clRed;

      aLbl := TLabel.Create(nil);
      aLbl.Parent := tsList;
//      aLbl.Owner := tsList;
//      aLbl.Width := 50;
//      aLbl.Height := 50;
      aLbl.Top := aBtn.BoundsRect.Top + (aBtn.Height - aLbl.Height) div 2;
      aLbl.Left := aBtn.BoundsRect.Right;
      aLbl.Caption := '->';

      aWidth := aLbl.BoundsRect.Right;
      cdsFlow.Next;
    end;
    if Assigned(aLbl) then aLbl.Free;
  finally
    aParam.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmFlowWork, fnFlowWork);
  
end.
