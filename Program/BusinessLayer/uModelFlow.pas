unit uModelFlow;

interface

uses
  Classes, Windows, SysUtils, DBClient, Controls, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelFlowIntf;

type
  TModelFlow = class(TModelBase, IModelFlow) //流程设置
  private

  protected
    function GetOneFlow(ATaskID: string; ACdsTaskProc, ACdsProcess, ACdsProcePermi: TClientDataSet): Integer; //获取流程的相关信息
    function QueryFlow(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //查询过滤流程
    function SaveFlow(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //保存流程等信息
  public

  end;

implementation

uses uSysSvc, uModelFunCom, uOtherIntf, uMoudleNoDef;

function TModelFlow.GetOneFlow(ATaskID: string; ACdsTaskProc, ACdsProcess, ACdsProcePermi: TClientDataSet): Integer;
var
  aSQL: string;
begin
  Result := -1;
  aSQL := 'SELECT * FROM tbx_Flow_TaskProc';
  gMFCom.QuerySQL(aSQL, ACdsTaskProc);
  aSQL := 'SELECT * FROM tbx_Flow_Process';
  gMFCom.QuerySQL(aSQL, ACdsProcess);
  aSQL := 'SELECT * FROM tbx_Flow_ProcePermi';
  gMFCom.QuerySQL(aSQL, ACdsProcePermi);
  Result := 1;
end;

function TModelFlow.QueryFlow(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //查询过滤流程
var
  aList: TParamObject;
  aSQL: string;
begin
  aList := TParamObject.Create;
  try
//    aList.Add('@RUID', AUserID);
//    aList.Add('@RUType', 1);
//    aList.Add('@LimitType', ALimitType);
//    Result := gMFCom.ExecProcBackData('pbx_Limit_User', aList, ACdsLimit);
    aSQL := 'SELECT * FROM tbx_Flow_TaskType';
    Result := gMFCom.QuerySQL(aSQL, ACdsFlow);
  finally
    aList.Free;
  end;
end;

function TModelFlow.SaveFlow(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //保存流程等信息
begin

end;

initialization
  gClassIntfManage.addClass(TModelLimit, IModelFlow);

finalization

end.

