unit uFrmFlow;

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
  TfrmFlow = class(TfrmMDI)
    gbFlow: TcxGroupBox;
    tvFlow: TcxTreeView;
    btnAddFlowProcess: TdxBarLargeButton;
    actAddFlowProcess: TAction;
    btnViewFlow: TdxBarLargeButton;
    actEditFlowProcess: TAction;
    pnlFlow: TPanel;
    gridLVFlow: TcxGridLevel;
    gridFlow: TcxGrid;
    gridTVFlow: TcxGridTableView;
    cdsFlow: TClientDataSet;
    actViewFlow: TAction;
    actDelFlow: TAction;
    btnDel: TdxBarLargeButton;
    procedure gridTVFlowDblClick(Sender: TObject);
    procedure tvFlowChange(Sender: TObject; Node: TTreeNode);
    procedure actAddFlowProcessExecute(Sender: TObject);
    procedure actViewFlowExecute(Sender: TObject);
    procedure actDelFlowExecute(Sender: TObject);
  private
    { Private declarations }
    FGridFlow: TGridItem;
    FModelFlow: IModelFlow;

    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
    function SelNodeData(ATV: TcxTreeView): PNodeData;

    procedure LoadFlowTree;
    function GetNodeData(AFullname, ATypeid: string): PNodeData;
  public
    { Public declarations }
    class function GetMdlDisName: string; override;
  end;

var
  frmFlow: TfrmFlow;

implementation

{$R *.dfm}

uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uFrmFlowProcess, uParamObject;

{ TfrmFlow }

procedure TfrmFlow.BeforeFormDestroy;
begin
  inherited;
  FreeBaseTVData(tvFlow);
  FGridFlow.Free;
end;

procedure TfrmFlow.BeforeFormShow;
begin
  inherited;
  Title := '流程设置';

  FModelFlow := IModelFlow((SysService as IModelControl).GetModelIntf(IModelFlow));
  FGridFlow := TGridItem.Create(ClassName + gridFlow.Name, gridFlow, gridTVFlow);

  LoadFlowTree();
  IniGridField();
  LoadGridData('');
end;

class function TfrmFlow.GetMdlDisName: string;
begin
  Result := '流程设置';
end;

procedure TfrmFlow.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridFlow.ClearField();
  FGridFlow.AddField('ProcessID', 'ProcessID', -1);
  FGridFlow.AddField('TaskProcID', 'TaskProcID', -1);
  FGridFlow.AddField('TaskID', 'TaskID', -1);
  FGridFlow.AddField('TaskName', '流程名称', 200, cfString);
  aCol := FGridFlow.AddField('TType', '类型', 100);
  aCol.SetDisplayText(TFlow_TType);
  
  aCol := FGridFlow.AddField('Statu', '是否启用', 80);
  aCol.SetDisplayText(TFlow_Statu);
  
  FGridFlow.AddField('TaskProcName', '流程作业名称', 200);

  aCol := FGridFlow.AddField('DefaultProc', '是否默认', 80);
  aCol.SetDisplayText(TFlow_Statu);

  FGridFlow.AddField('ProcesseName', '项目名称', 100);
  FGridFlow.AddField('ProceOrder', '顺序', 80);

  aCol := FGridFlow.AddField('OperType', '操作类型', 100);
  aCol.SetDisplayText(TFlow_OperType);
  
  FGridFlow.InitGridData;
end;

procedure TfrmFlow.InitParamList;
begin
  inherited;
  MoudleNo := fnFlow;
end;

procedure TfrmFlow.LoadFlowTree;
var
  aParam: TParamObject;
  aCdsFlow: TClientDataSet;
  aNodeData: PNodeData;
  aRootNode: TTreeNode;
begin
  inherited;
  FreeBaseTVData(tvFlow);
  tvFlow.Items.Clear;

  aRootNode := tvFlow.Items.AddChildObject(nil, '流程列表', nil);

  aCdsFlow := TClientDataSet.Create(nil);
  aParam := TParamObject.Create;
  tvFlow.Items.BeginUpdate;
  try
    aParam.Add('@QryType', Flow_TaskType);
    aParam.Add('@Custom', '');
    FModelFlow.FlowData(aParam, aCdsFlow);
    aCdsFlow.First;
    while not aCdsFlow.Eof do
    begin
      aNodeData := GetNodeData(aCdsFlow.FieldByName('TaskName').AsString, aCdsFlow.FieldByName('TaskID').AsString);
      tvFlow.Items.AddChildObject(aRootNode, aNodeData.Fullname, aNodeData);

      aCdsFlow.Next;
    end;

    tvFlow.FullExpand;
    tvFlow.Items.GetFirstNode.GetNext.Selected := True;
    tvFlow.SetFocus;
  finally
    tvFlow.Items.EndUpdate;
    aParam.Free;
    aCdsFlow.Free;
  end;
end;

procedure TfrmFlow.LoadGridData(ATypeid: string);
var
  aParam: TParamObject;
  aNodeData: PNodeData;
begin
  inherited;
  aNodeData := SelNodeData(tvFlow);
  if not Assigned(aNodeData) then Exit;

  aParam := TParamObject.Create;
  try
    aParam.Add('@QryType', Flow_Process);
    aParam.Add('@Custom', aNodeData.Typeid);
    FModelFlow.FlowData(aParam, cdsFlow);
    FGridFlow.LoadData(cdsFlow);
  finally
    aParam.Free;
  end;
end;

procedure TfrmFlow.gridTVFlowDblClick(Sender: TObject);
var
  aProcessID, aTaskProcID, aTaskID, aRow: Integer;
  aParam: TParamObject;
begin
  inherited;
  aRow := FGridFlow.RowIndex;
  if (aRow < FGridFlow.GetFirstRow) or (aRow > FGridFlow.GetLastRow) then Exit;
  
  aProcessID := FGridFlow.GetCellValue('ProcessID', aRow);
  aTaskProcID := FGridFlow.GetCellValue('TaskProcID', aRow);
  aTaskID := FGridFlow.GetCellValue('TaskID', aRow);
  if aProcessID <= 0 then Exit;

  aParam := TParamObject.Create;
  aParam.Add('cMode', dctDis);
  aParam.Add('ProcessID', aProcessID);
  aParam.Add('TaskProcID', aTaskProcID);
  aParam.Add('TaskID', aTaskID);
  try
    if ShowFlowProcess(aParam) = mrok then
    begin
      LoadGridData('');
    end;
  finally
    aParam.Free;
  end;
end;

function TfrmFlow.GetNodeData(AFullname, ATypeid: string): PNodeData;
var
  aNodeData: PNodeData;
begin
  New(aNodeData);
  aNodeData.Leveal := 1;
  aNodeData.Fullname := AFullname;
  aNodeData.Typeid := ATypeid;
  aNodeData.Parid := '';
  Result := aNodeData;
end;

function TfrmFlow.SelNodeData(ATV: TcxTreeView): PNodeData;
var
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  Result := nil;
  aTreeNode :=  ATV.Selected;
  if not Assigned(aTreeNode) then Exit;

  aNodeData := aTreeNode.Data;
  if not Assigned(aNodeData) then Exit;

  Result := aNodeData;
end;

procedure TfrmFlow.tvFlowChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  LoadGridData('');
end;

procedure TfrmFlow.actAddFlowProcessExecute(Sender: TObject);
var
  aTaskID: Integer;
  aParam: TParamObject;
  aNodeData: PNodeData;
begin
  inherited;
  aNodeData := SelNodeData(tvFlow);
  if not Assigned(aNodeData) then Exit;

  aTaskID := StringToInt(aNodeData.Typeid);

  if aTaskID <= 0 then Exit;

  aParam := TParamObject.Create;
  aParam.Add('cMode', dctAdd);
  aParam.Add('TaskID', aTaskID);
  try
    if ShowFlowProcess(aParam) = mrok then
    begin
      LoadGridData('');
    end;
  finally
    aParam.Free;
  end;
end;

procedure TfrmFlow.actViewFlowExecute(Sender: TObject);
begin
  inherited;
  gridTVFlowDblClick(nil);
end;

procedure TfrmFlow.actDelFlowExecute(Sender: TObject);
var
  aTaskID: Integer;
  aParam: TParamObject;
  aNodeData: PNodeData;
begin
  inherited;
  aNodeData := SelNodeData(tvFlow);
  if not Assigned(aNodeData) then Exit;

  aTaskID := StringToInt(aNodeData.Typeid);

  if aTaskID <= 0 then Exit;

  aParam := TParamObject.Create;
  aParam.Add('cMode', dctDel);
  aParam.Add('@TaskID', aTaskID);
  try
    if FModelFlow.SaveFlow(aParam) = 0 then
    begin
      LoadGridData('');
    end;
  finally
    aParam.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmFlow, fnFlow);
  
end.
