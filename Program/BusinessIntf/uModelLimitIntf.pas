{***************************
Ȩ����صĽӿ�
mx 2016-08-22
****************************}

unit uModelLimitIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  //Ȩ������
  Limit_Un = 0; //δ����
  Limit_Base = 1; //������Ϣ
  Limit_Bill = 2; //����
  Limit_Report = 3; //����
  Limit_Data = 4; //����
  Limit_Other = 5; //����

  Limit_Base_View = 1; //������ϢȨ��-�鿴
  Limit_Base_Add = 2; //������ϢȨ��-����
  Limit_Base_Class = 4; //������ϢȨ��-����
  Limit_Base_Modify = 8; //������ϢȨ��-�޸�
  Limit_Base_Del = 16; //������ϢȨ��-ɾ��
  Limit_Base_Print = 32; //������ϢȨ��-��ӡ

  Limit_Bill_View = 1; //����-�鿴
  Limit_Bill_Input = 2; //����-����
  Limit_Bill_Settle = 4; //����-����
  Limit_Bill_Print = 8; //����-��ӡ

  Limit_Save_Role = 1; //�����ɫ��Ϣ
  Limit_Modify_Role = 2; //�޸Ľ�ɫ��Ϣ
  Limit_Del_Role = 3; //ɾ����ɫ��Ϣ
  Limit_Save_RoleAction = 4; //������޸�һ����ɫ��Ӧ��Ȩ��
  Limit_Save_RU = 5; //����һ����ɫ���û���ӳ���ϵ
  Limit_Del_RU = 6; //ɾ��һ����ɫ���û���ӳ���ϵ

type
  IModelLimit = interface(IModelBase)
    ['{32E62488-975F-461D-AE3F-160AE3962F27}']
    function UserLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //�����û���Ӧ���͵�Ȩ��
    function LimitData(AParam: TParamObject; ACdsLimit: TClientDataSet): Integer; //����,��ɫ������
    function SaveLimit(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //�����ɫ�����ɫ���û�ӳ���
    function CheckLimit(ALimitDo: Integer; ALimitId, AUserId: string): Boolean; //�ж�ĳ���û��Ƿ����ĳ��Ȩ�޵�ĳ�ֲ���
    function GetLimitId(AKeyId: Integer): string; //ĳ��ģ���Ӧ��LimitId
  end;

implementation

end.

