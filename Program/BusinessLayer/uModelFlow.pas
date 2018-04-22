unit uModelFlow;

interface

uses
  Classes, Windows, SysUtils, DBClient, Controls, uPubFun, uParamObject,
  uBusinessLayerPlugin, uBaseInfoDef, uModelParent, uModelFlowIntf;

type
  TModelFlow = class(TModelBase, IModelFlow) //审核
  private
  protected
    function FlowData(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //审核的相关数据
    function SaveFlow(ASaveData: TParamObject): Integer; //保存流程，项目,审核人员等
    function SaveOneFlow(AParam: TParamObject): Integer;
    function DoOneFlow(AProcePathID: Integer; AResult: TFlowDoResult; AInfo: string): Integer; //处理一条业务审核路径
  public
  end;

implementation

uses
  uSysSvc, uModelFunCom, uOtherIntf, uMoudleNoDef, uDefCom;

{ TModelFlow }

function TModelFlow.DoOneFlow(AProcePathID: Integer;
  AResult: TFlowDoResult; AInfo: string): Integer;
var
  aParam: TParamObject;
  aProceResult: Integer;
begin
  Result := -1;
  aParam := TParamObject.Create;
  try
    aProceResult := 0;
    aParam.Add('@ETypeId', OperatorID);
    aParam.Add('@ProcePathID', AProcePathID);
    if AResult = fdrAllow then
      aProceResult := 1
    else if AResult = fdrBack then
      aProceResult := -1
    else if AResult = fdrStop then
      aProceResult := 2;
      
    aParam.Add('@ProceResult', aProceResult);
    aParam.Add('@FlowInfo', AInfo);

    Result := gMFCom.ExecProcByName('pbx_Flow_DoOne', aParam);
    if Result <> 0 then
    begin
      gMFCom.ShowMsgBox(aParam.AsString('@ErrorValue'), '提示', mbtInformation);
    end;
  finally
    aParam.free;
  end;
end;

function TModelFlow.FlowData(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer;
var
  aBillID, aBillType: Integer;
  aWorkID, aCustom: string;
begin
  if AParam.AsInteger('@QryType') in [Flow_His, Flow_OneWork] then
  begin
    aBillID := AParam.AsInteger('@BillID');
    aBillType := AParam.AsInteger('@BillType');
    aWorkID := AParam.AsString('@WorkID');
    aCustom := ' fpp.BillID = ' + IntToStr(aBillID) + ' AND fpp.BillType = '
      + IntToStr(aBillType) + ' AND fpp.WorkID =' + QuotedStr(aWorkID);
    AParam.Add('@Custom', aCustom);
  end;

  Result := gMFCom.ExecProcBackData('pbx_Flow_QryData', AParam, ACdsFlow);
end;

function TModelFlow.SaveFlow(ASaveData: TParamObject): Integer;
var
  aTaskProc, aSQL, aMode, aTaskProcName, aSucMsg: string;
  aDefaultProc, aTaskID, aTaskProcID: Integer;
  aDct: TDataChangeType;
begin
  Result := -1;
  aSQL := EmptyStr;
  aMode := Trim(ASaveData.AsString('cMode'));
  aDct := GetDataChangeType(aMode);
  if not (aDct in [dctAdd, dctModif, dctDel]) then
  begin
    gMFCom.ShowMsgBox('指定操作方式不正确！', '错误', mbtError);
    Exit;
  end;
  if aDct in [dctAdd, dctModif] then
    Result := gMFCom.ExecProcByName('pbx_Flow_Save_Set', ASaveData)
  else if aDct = dctDel then
  begin
    if gMFCom.ShowMsgBox('数据删除后不能恢复，请确认删除！', '提示', mbtInformation,
      mbbOKCancel) <> mrok then
      Exit;
    Result := gMFCom.ExecProcByName('pbx_Flow_Del', ASaveData);
  end;

  if Result <> 0 then
  begin
    gMFCom.ShowMsgBox(ASaveData.AsString('@ErrorValue'), '提示', mbtInformation);
  end;
end;

function TModelFlow.SaveOneFlow(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aCdsTmp: TClientDataSet;
  aQry: TParamObject;
begin
  Result := 0;
  aCdsTmp := TClientDataSet.Create(nil);
  aQry := TParamObject.Create;
  try
    aQry.Add('@QryType', Flow_TaskType);
    aQry.Add('@Custom', '');
    gMFCom.ExecProcBackData('pbx_Flow_QryData', aQry, aCdsTmp);
    if aCdsTmp.IsEmpty then
      Exit;

    aCdsTmp.First;
    while not aCdsTmp.Eof do
    begin
      if (aCdsTmp.FieldByName('WorkID').AsString = AParam.AsString('WorkID'))
        and (aCdsTmp.FieldByName('Statu').AsInteger = 1) then
      begin
        aQry.Clear;
        aQry.Add('@CETypeId', OperatorID);
        aQry.Add('@Info', AParam.AsString('Info'));
        aQry.Add('@WorkID', AParam.AsString('WorkID'));
        aQry.Add('@BillID', AParam.AsInteger('BillID'));
        aQry.Add('@BillType', AParam.AsInteger('BillType'));
        aQry.Add('@TaskProcID', 0); //执行默认的审批流程

        Result := 1;
        aRet := gMFCom.ExecProcByName('pbx_Flow_AddWork', aQry);
        if aRet <> 0 then
        begin
          gMFCom.ShowMsgBox(aQry.AsString('@ErrorValue'), '提示', mbtInformation);
          Result := -1;
        end
        else
        begin
          gMFCom.ShowMsgBox('提交流程审批成功', '提示', mbtInformation);
        end;
        Exit;
      end;
      aCdsTmp.Next;
    end;
  finally
    aQry.Free;
    aCdsTmp.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelFlow, IModelFlow);

finalization

end.

