{***************************
����ģ����
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
  //��������
  fnAssist= 5000;
//  ��ѯ����
//  fnDlgcond = 5000;
//  TCѡ����
//  fnTc = 6000;
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
  fnMdlBillAllot = fnBill + 0005; //������
  fnMdlBillGathering = fnBill + 0006; //�տ
  fnMdlBillPayment = fnBill + 0007; //���

  //����-----------------------------------3000---------------------
  fnMdlReportGoods = fnReport + 0001; //��Ʒ������
  fnMdlReportOrderBuy = fnReport + 0002; //��������ͳ��
  fnMdlReportBuy = fnReport + 0003; //������ͳ��
  fnMdlReportOrderSale = fnReport + 0004; //���۶���ͳ��
  fnMdlReportSale = fnReport + 0005; //���۵�ͳ��

  //ϵͳ����-------------------------------4000---------------------
  fnMdlLoadItemSet = fnSystem + 0001; //���ذ�����
  fnMdlBaseTbxCfg = fnSystem + 0002; //�����Ϣ����
  fnMdlBasicTypeCfg = fnSystem + 0003; //���ػ���Ϣ������
  fnMdlHelp_Calc = fnSystem + 0004; //������
  fnMdlHelp_Online = fnSystem + 0005; //���߰���
  fnMdlStockGoodsIni = fnSystem + 0006; //�ڳ������Ʒ
  fnDialogInitOver = fnSystem + 0007; //���ˣ�������
  fnDialogReBuild = fnSystem + 0008; //ϵͳ�ؽ�
  fnMdlCheckGoods = fnSystem + 0009; //�ֿ��̵�
  fnMdlLimitRole = fnSystem + 0010; //Ȩ�޹���-��ɫ����
  fnDialogLimitSet = fnSystem + 0011; //Ȩ�޹���-�û�����
  fnFlow = fnSystem + 0012; //��������

  //����-------------------------------7000---------------------
  fnMdlTTest = fnTest + 0001; //����

  //��������
  fnMdlMyFlow = fnAssist + 0001; //�ҵ�����
  fnFlowWork = fnAssist + 0002; //��������
  
implementation

end.

