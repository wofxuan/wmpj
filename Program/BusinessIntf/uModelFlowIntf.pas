{***************************
������صĽӿ�
mx 2017-10-08
****************************}

unit uModelFlowIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  Flow_Save_Process = 1; //������޸�������ҵ������Ŀ
  Flow_Del_Process = 2; //ɾ��������ҵ������Ŀ
  Flow_Save_ProcePermi = 3; //������޸�һ�������Ա
  Flow_Del_ProcePermi = 4; //ɾ��һ�������Ա

type
  IModelFlow = interface(IModelBase)
    ['{BFAECA86-D63D-438A-B272-28A75F058449}']
    function GetOneFlow(ATaskID: string; ACdsTaskProc, ACdsProcess, ACdsProcePermi: TClientDataSet): Integer; //��ȡ���̵������Ϣ
    function QueryFlow(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //��ѯ��������
    function SaveFlow(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //�������̵���Ϣ
  end;

implementation

end.

