{***************************
����ģ����
�ڴ����еı��Ҳ����˱�ţ����һ�������ж������ⶨ������������Ӧ
mx 2014-12-03
****************************}
unit uMoudleNoDef;

interface

const
  //ģ�鳣������
  //��ʽ��fn+���� = ���� + �ۼ�
  //ֻ���ۼӣ�����ɾ�����޸�

  //������Ϣ
  fnBase = 1000;
  //����
  fnBill = 2000;
  //����
  fnReport = 3000;
  //ϵͳ����
  fnSystem = 4000;
  //��ѯ����
  fnDlgcond = 5000;
  //TCѡ����
  fnTc = 6000;
  //����ʱʹ�õģ� ����ʱɾ��
  fnTest = 7000;


  //������Ϣ-----------------------------1000------------------------
  fnMdlBasePtypeList = fnBase + 0001; //��Ʒ
  fnMdlBaseBtypeList = fnBase + 0002; //��λ
  fnMdlBaseEtypeList = fnBase + 0003; //ְԱ
  fnMdlBaseDtypeList = fnBase + 0004; //����
  fnMdlBaseKtypeList = fnBase + 0005; //�ֿ�

  //����---------------------------------2000-----------------------
  fnMdlBillOrderBuy = fnBill + 0001; //��������
  fnMdlBillOrderSale = fnBill + 0002; //���۶���
  fnMdlBillBuy = fnBill + 0003; //������
  fnMdlBillSale = fnBill + 0004; //���۵�

  //����-----------------------------------3000---------------------
  fnMdlReportGoods = fnReport + 0001; //��Ʒ������
  fnMdlReportOrderBuy = fnReport + 0002; //��������ͳ��
  fnMdlReportBuy = fnReport + 0003; //������ͳ��

  //ϵͳ����-------------------------------4000---------------------
  fnMdlLoadItemSet = fnSystem + 0001; //���ذ�����
  fnMdlBaseTbxCfg = fnSystem + 0002; //�����Ϣ����
  fnMdlBasicTypeCfg = fnSystem + 0003; //���ػ���Ϣ������
  fnMdlHelp_Calc = fnSystem + 0004; //������
  fnMdlHelp_Online = fnSystem + 0005; //���߰���

  //ϵͳ����-------------------------------7000---------------------
  fnMdlTTest = fnTest + 0001; //����

implementation

end.

