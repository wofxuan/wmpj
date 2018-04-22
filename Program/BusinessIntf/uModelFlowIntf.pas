{***************************
<<<<<<< HEAD
审核相关的接口
mx 2017-11-22
=======
流程相关的接口
mx 2017-10-08
>>>>>>> b8d3165e57310d3e3c47babcf6deacb9bb33778a
****************************}

unit uModelFlowIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
<<<<<<< HEAD
  Flow_State_Stop = 2; //审批终止
  //查询类型
  Flow_TaskType = 1; //所有流程
  Flow_TaskProc = 2; //流程作业
  Flow_Process = 3; //流程作业具体项目
  Flow_ProcePermi = 4; //流程作业项目人员表
  Flow_ProcePath = 5; //此员工需要审批的所有流程
  Flow_His = 6; //一条业务所有的审批历史记录
  Flow_OneWork = 7; //一条业务审批状态
type

  //审批处理结果   通过     退回    终止
  TFlowDoResult = (fdrAllow, fdrBack, fdrStop);
  
  IModelFlow = interface(IModelBase)
    ['{ED7AA819-445B-4BE1-866C-D52169F66C73}']
    function FlowData(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //审核的相关数据
    function SaveFlow(ASaveData: TParamObject): Integer; //保存流程，项目,审核人员等
    function SaveOneFlow(AParam: TParamObject): Integer; //生成一条业务的所有审核路径
    function DoOneFlow(AProcePathID: Integer; AResult: TFlowDoResult; AInfo: string): Integer; //处理一条业务审核路径
  end;

var
  TFlow_TType: TIDDisplayText;//流程类型
  TFlow_Statu: TIDDisplayText;//流程作业状态
  TFlow_OperType: TIDDisplayText;//审批类型
  TFlow_DoType: TIDDisplayText;//审批结果

implementation

initialization
  TFlow_TType := TIDDisplayText.Create;
  TFlow_TType.AddItem('0', '单据业务');
  TFlow_TType.AddItem('1', '人事');

  TFlow_Statu := TIDDisplayText.Create;
  TFlow_Statu.AddItem('0', '未启用');
  TFlow_Statu.AddItem('1', '启用');

  TFlow_OperType := TIDDisplayText.Create;
  TFlow_OperType.AddItem('0', '审核');   
  TFlow_OperType.AddItem('1', '知会');
  TFlow_OperType.AddItem('1', '执行');

  TFlow_DoType := TIDDisplayText.Create;
  TFlow_DoType.AddItem('0', '未处理');
  TFlow_DoType.AddItem('1', '同意');
  TFlow_DoType.AddItem('2', '终止');
  TFlow_DoType.AddItem('-1', '退回');

finalization
  TFlow_TType.Free;
  TFlow_Statu.Free;
  TFlow_OperType.Free;
  TFlow_DoType.Free;

=======
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

>>>>>>> b8d3165e57310d3e3c47babcf6deacb9bb33778a
end.

