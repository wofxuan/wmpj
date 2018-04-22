unit uFrmFlowProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxTextEdit,
  cxMaskEdit, cxButtonEdit, uWmLabelEditBtn, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxGroupBox, uGridConfig, uModelFlowIntf, uFrmApp, uParamObject, DB,
  DBClient, cxDropDownEdit;

type
  TfrmFlowProcess = class(TfrmDialog)
    gbE: TcxGroupBox;
    gridE: TcxGrid;
    gridTVE: TcxGridTableView;
    gridLVE: TcxGridLevel;
    cdsFlow: TClientDataSet;
    gbTaskProc: TcxGroupBox;
    gridTaskProc: TcxGrid;
    gridTVTaskProc: TcxGridTableView;
    gridLVTaskProc: TcxGridLevel;
    btnAddTaskProc: TcxButton;
    btnDelTaskProc: TcxButton;
    cbbType: TcxComboBox;
    lbl1: TLabel;
    btnAddProcess: TcxButton;
    btnDelProcess: TcxButton;
    procedure btnAddTaskProcClick(Sender: TObject);
    procedure btnDelTaskProcClick(Sender: TObject);
    procedure btnAddProcessClick(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    FGridFlow, FGridTaskProc: TGridItem;
    FModelFlow: IModelFlow;
    FProcesse: array of TParamObject;

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure IniData; override;
    procedure IniGridField;
    procedure LoadGridData(ATypeid: string);
    function CheckData: Boolean;
    function SaveData: Boolean;
  public
    { Public declarations }
  end;

function ShowFlowProcess(AParam: TParamObject): Integer;

implementation

{$R *.dfm}

uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uOtherIntf, uFrmFlowItem, uPackData;

function ShowFlowProcess(AParam: TParamObject): Integer;
var
  aFrm: TfrmFlowProcess;
begin
  aFrm := TfrmFlowProcess.CreateFrmParamList(nil, AParam);
  try
    Result := aFrm.ShowModal;
  finally
    aFrm.Free;
  end;
end;

{ TfrmFlowProcess }

procedure TfrmFlowProcess.BeforeFormDestroy;
var
  i: Integer;
begin
  inherited;
  for i := 0 to Length(FProcesse) - 1 do
  begin
    FProcesse[i].Free;
  end;

  FGridFlow.Free;
  FGridTaskProc.Free;
end;

procedure TfrmFlowProcess.BeforeFormShow;
begin
  inherited;
  Title := '流程配置表';

  FModelFlow := IModelFlow((SysService as IModelControl).GetModelIntf(IModelFlow));

  FGridFlow := TGridItem.Create(ClassName + gridE.Name, gridE, gridTVE);
  FGridFlow.ShowMaxRow := False;

  FGridTaskProc := TGridItem.Create(ClassName + gridTaskProc.Name, gridTaskProc, gridTVTaskProc);
  FGridTaskProc.ShowMaxRow := False;

  SetLength(FProcesse, 0);
  
  IniGridField();
  IniData();
end;

procedure TfrmFlowProcess.IniData;
begin
  inherited;
  if GetDataChangeType(ParamList.AsString('cMode')) = dctDis then
  begin
    LoadGridData(ParamList.AsString('TaskID'));
    btnOK.Visible := False;
  end;
end;

procedure TfrmFlowProcess.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridTaskProc.ClearField;
  FGridTaskProc.AddField('TaskID', 'TaskID', -1);
  FGridTaskProc.AddField('TaskProcName', '流程名称', 200);
  aCol := FGridTaskProc.AddField('DefaultProc', '是否默认', 80);
  aCol.SetDisplayText(TFlow_Statu);
  FGridTaskProc.InitGridData;
  
  FGridFlow.ClearField();
  FGridFlow.AddField('ProcessID', 'ProcessID', -1);
  FGridFlow.AddField('TaskName', '流程名称', 100, cfString);
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
  FGridFlow.AddField(btEtype);
  FGridFlow.InitGridData;

  gridTVE.DataController.RecordCount := 0;
  gridTVTaskProc.DataController.RecordCount := 0;
end;

procedure TfrmFlowProcess.LoadGridData(ATypeid: string);
var
  aParam: TParamObject;
  aNodeData: PNodeData;
begin
  inherited;
  aParam := TParamObject.Create;
  try
    aParam.Clear;
    aParam.Add('@QryType', Flow_TaskProc);
    aParam.Add('@Custom', ATypeid);
    FModelFlow.FlowData(aParam, cdsFlow);
    FGridTaskProc.LoadData(cdsFlow);
    
    aParam.Add('@QryType', Flow_ProcePermi);
    aParam.Add('@Custom', ATypeid);
    FModelFlow.FlowData(aParam, cdsFlow);
    FGridFlow.LoadData(cdsFlow);
  finally
    aParam.Free;
  end;
end;

procedure TfrmFlowProcess.btnAddTaskProcClick(Sender: TObject);
var
  aTaskProcName: string;
  aSaveData, aOutPutData: TParamObject;
  aRow: Integer;
begin
  inherited;
  if IMsgBox(SysService as IMsgBox).InputBox('流程', '流程名称', aTaskProcName) = mrok then
  begin
    aRow := FGridTaskProc.AddRow;
    FGridTaskProc.RowIndex := aRow;
    FGridTaskProc.SetCellValue('TaskProcName', aRow, aTaskProcName);
    FGridTaskProc.SetCellValue('DefaultProc', aRow, 0);
  end;
end;

procedure TfrmFlowProcess.btnDelTaskProcClick(Sender: TObject);
var
  i, j, aRow: Integer;
  aTaskProcName: string;
begin
  inherited;
  if IMsgBox(SysService as IMsgBox).MsgBox('数据删除后不能恢复，请确认删除！', '提示',
    mbtInformation, mbbOKCancel) <> mrok then Exit;

  aRow := FGridTaskProc.RowIndex;
  if (aRow >= FGridTaskProc.GetFirstRow) and (aRow <= FGridTaskProc.GetLastRow) then
  begin
    aTaskProcName := FGridTaskProc.GetCellValue('TaskProcName', aRow);
    for i := 0 to Length(FProcesse) - 1 do
    begin
      if FProcesse[i].AsString('TaskProcName') = aTaskProcName then
      begin
        FProcesse[i].Free;
        for j := i + 1 to Length(FProcesse) - 1 do
        begin
          FProcesse[i] := FProcesse[j];
        end;
        SetLength(FProcesse, Length(FProcesse) - 1);
      end;
    end;
    FGridTaskProc.DeleteRow(aRow);
  end;
end;

procedure TfrmFlowProcess.btnAddProcessClick(Sender: TObject);
var
  aRow, aRowD, aTaskID, aLen: Integer;
  aParam, aProcesse: TParamObject;
  aTaskProcName: string;
  aModelFun: IModelFun;
begin
  inherited;
  aRow := FGridTaskProc.RowIndex;
  if (aRow < FGridTaskProc.GetFirstRow) or (aRow > FGridTaskProc.GetLastRow) then Exit;

  aTaskID := ParamList.AsInteger('TaskID');
  aTaskProcName := FGridTaskProc.GetCellValue('TaskProcName', aRow);
  
  aParam := TParamObject.Create;
  aParam.Add('TaskID', aTaskID);
  try
    if ShowFlowItem(aParam) = mrOk then
    begin
      aModelFun := SysService as IModelFun;
      aRowD := FGridFlow.AddRow;
      FGridFlow.SetCellValue('TaskName', aRowD, aTaskProcName);
      FGridFlow.SetCellValue('TaskProcName', aRowD, aTaskProcName);
      FGridFlow.SetCellValue(GetBaseTypeid(btEtype), aRowD, aParam.AsString('OperId'));
      FGridFlow.SetCellValue(GetBaseTypeFullName(btEtype), aRowD,
        aModelFun.GetLocalValue(btEtype, GetBaseTypeFullName(btEtype), aParam.AsString('OperId')));

      FGridFlow.SetCellValue(GetBaseTypeUsercode(btEtype), aRowD,
        aModelFun.GetLocalValue(btEtype, GetBaseTypeUsercode(btEtype), aParam.AsString('OperId')));

      aProcesse := TParamObject.Create;
      aProcesse.Assign(aParam);
      aProcesse.Add('TaskProcName', aTaskProcName);
      aLen := Length(FProcesse) + 1;
      SetLength(FProcesse, aLen);
      FProcesse[aLen - 1] := aProcesse;
    end;
  finally
    aParam.Free;
  end;
end;

function TfrmFlowProcess.CheckData: Boolean;
begin
  Result := False;
//  if FGridTaskProc.RecordCount = 0 then
//  begin
//    IMsgBox(SysService as IMsgBox).MsgBox('没有设置流程，不能保存！');
//    Exit;
//  end;
//
//  if Length(FProcesse) = 0 then
//  begin
//    IMsgBox(SysService as IMsgBox).MsgBox('没有设置流程作业具体项目，不能保存！');
//    Exit;
//  end;
  Result := True;
end;

procedure TfrmFlowProcess.actOKExecute(Sender: TObject);
begin
  inherited;
  if CheckData() then
  begin
    if SaveData() then
    begin
      IMsgBox(SysService as IMsgBox).MsgBox('保存成功！');
      ModalResult := mrOk;
    end;
  end;
end;

function TfrmFlowProcess.SaveData: Boolean;
var
  aParam: TParamObject;
  i: Integer;
  aTaskProcName, aProcesseName, aOperType, aProceOrder, aOperId: string;
begin
  Result := False;
  aParam := TParamObject.Create;
  try
    aParam.Add('cMode', dctAdd);
    aParam.Add('@TaskID', ParamList.AsInteger('TaskID'));
    aParam.Add('@TType', cbbType.ItemIndex);
    aParam.Add('@TComment', '');

    aTaskProcName := '';
    aProcesseName := '';
    aOperType := '';
    aProceOrder := '';
    aOperId := '';
    for i := 0 to Length(FProcesse) - 1 do
    begin
      aTaskProcName := aTaskProcName + FProcesse[i].AsString('TaskProcName') + SaveBillChar;
      aProcesseName := aProcesseName + FProcesse[i].AsString('ProcesseName') + SaveBillChar;
      aOperType := aOperType + FProcesse[i].AsString('OperType') + SaveBillChar;
      aProceOrder := aProceOrder + FProcesse[i].AsString('ProceOrder') + SaveBillChar;
      aOperId := aOperId + FProcesse[i].AsString('OperId') + SaveBillChar;
    end;

    aParam.Add('@TaskProcName', aTaskProcName);
    aParam.Add('@ProcesseName', aProcesseName);
    aParam.Add('@OperType', aOperType);
    aParam.Add('@ProceOrder', aProceOrder);
    aParam.Add('@OperId', aOperId);

    if FModelFlow.SaveFlow(aParam) = 0 then
    begin
      Result := True;
    end;
  finally
    aParam.Free;
  end;
end;

end.
