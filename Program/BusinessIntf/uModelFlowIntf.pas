{***************************
<<<<<<< HEAD
�����صĽӿ�
mx 2017-11-22
=======
������صĽӿ�
mx 2017-10-08
>>>>>>> b8d3165e57310d3e3c47babcf6deacb9bb33778a
****************************}

unit uModelFlowIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
<<<<<<< HEAD
  Flow_State_Stop = 2; //������ֹ
  //��ѯ����
  Flow_TaskType = 1; //��������
  Flow_TaskProc = 2; //������ҵ
  Flow_Process = 3; //������ҵ������Ŀ
  Flow_ProcePermi = 4; //������ҵ��Ŀ��Ա��
  Flow_ProcePath = 5; //��Ա����Ҫ��������������
  Flow_His = 6; //һ��ҵ�����е�������ʷ��¼
  Flow_OneWork = 7; //һ��ҵ������״̬
type

  //����������   ͨ��     �˻�    ��ֹ
  TFlowDoResult = (fdrAllow, fdrBack, fdrStop);
  
  IModelFlow = interface(IModelBase)
    ['{ED7AA819-445B-4BE1-866C-D52169F66C73}']
    function FlowData(AParam: TParamObject; ACdsFlow: TClientDataSet): Integer; //��˵��������
    function SaveFlow(ASaveData: TParamObject): Integer; //�������̣���Ŀ,�����Ա��
    function SaveOneFlow(AParam: TParamObject): Integer; //����һ��ҵ����������·��
    function DoOneFlow(AProcePathID: Integer; AResult: TFlowDoResult; AInfo: string): Integer; //����һ��ҵ�����·��
  end;

var
  TFlow_TType: TIDDisplayText;//��������
  TFlow_Statu: TIDDisplayText;//������ҵ״̬
  TFlow_OperType: TIDDisplayText;//��������
  TFlow_DoType: TIDDisplayText;//�������

implementation

initialization
  TFlow_TType := TIDDisplayText.Create;
  TFlow_TType.AddItem('0', '����ҵ��');
  TFlow_TType.AddItem('1', '����');

  TFlow_Statu := TIDDisplayText.Create;
  TFlow_Statu.AddItem('0', 'δ����');
  TFlow_Statu.AddItem('1', '����');

  TFlow_OperType := TIDDisplayText.Create;
  TFlow_OperType.AddItem('0', '���');   
  TFlow_OperType.AddItem('1', '֪��');
  TFlow_OperType.AddItem('1', 'ִ��');

  TFlow_DoType := TIDDisplayText.Create;
  TFlow_DoType.AddItem('0', 'δ����');
  TFlow_DoType.AddItem('1', 'ͬ��');
  TFlow_DoType.AddItem('2', '��ֹ');
  TFlow_DoType.AddItem('-1', '�˻�');

finalization
  TFlow_TType.Free;
  TFlow_Statu.Free;
  TFlow_OperType.Free;
  TFlow_DoType.Free;

=======
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

>>>>>>> b8d3165e57310d3e3c47babcf6deacb9bb33778a
end.

