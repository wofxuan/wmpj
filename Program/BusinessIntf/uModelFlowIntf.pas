{***************************
流程相关的接口
mx 2017-10-08
****************************}

unit uModelFlowIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  Flow_Save_Process = 1; //保存或修改流程作业具体项目
  Flow_Del_Process = 2; //删除流程作业具体项目
  Flow_Save_ProcePermi = 3; //保存或修改一条审核人员
  Flow_Del_ProcePermi = 4; //删除一条审核人员

type
  IModelFlow = interface(IModelBase)
    ['{BFAECA86-D63D-438A-B272-28A75F058449}']
    function GetOneFlow(ATaskID: string; ACdsTaskProc, ACdsProcess, ACdsProcePermi: TClientDataSet): Integer; //获取流程的相关信息
    function QueryFlow(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //查询过滤流程
    function SaveFlow(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //保存流程等信息
  end;

implementation

end.

