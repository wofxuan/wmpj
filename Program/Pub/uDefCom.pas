{ ------------------------------------
  ����˵����ר�Ŷ���ϵͳʹ�õĹ̶��ĳ��������ݿ�����޹ص�
  �������ڣ�2014/07/08
  ���ߣ�mx
  ��Ȩ��mx
  ------------------------------------- }
unit uDefCom;

interface

const
  cnNoneName = '��δָ����';
  ROOT_ID = '00000'; //���ڵ�
  ROOT_OTHER = '99999';
  OneDeepLength = 5; //����һ���ڵ㳤��
  cnMAXDEEP = 5; //������

  //��Ϣ�Ի�����
  mrSett = 101; //���浥��
  mrDraft = 102; //����ݸ�
  mrClose = 103; //�����˳�

  //�������ʵ��ʽ
  ReportMode = 'BrMode';
  ReportMode_List = 'L';
  ReportMode_Node = 'N';
  ReportMode_Bill = 'V';

  {��Ʒ�ɱ�ģʽ}
  COSTMODE_AVERAGE = 0; //�ƶ���Ȩƽ��
  COSTMODE_FIFO = 1; //�Ƚ��ȳ���
  COSTMODE_AIFO = 2; //����ȳ���
  COSTMODE_HAND = 3; //�ֹ�ָ����

type
  //������ֶ�����
  //�ַ�����������������(����0)��С������С��, boolen
  //���������ۣ����ۿۣ����ڣ�ʱ�䣬����ʱ��
  TColField = (cfString, cfInt, cfPlusInt, cfFloat, cfPlusFloat, cfCheck,
    cfQty, cfPrice, cfTotal, cfDiscount, cfDate, cfTime, cfDatime);

  //tcѡ��ģʽ      //��ť���س���˫��
  TSelectMode = (smNo, smButton, smEnter, smDblClick);

  //ʱ��༭��ʾ��ʽ
  TEditDisType = (edtDate, edtTime, edtDatime);

  //�������ݱ仯             ���ӡ�   ���������� ɾ����  �޸ġ�   ���ࡢ    �鿴
  TDataChangeType = (dctNo, dctAdd, dctAddCopy, dctDel, dctModif, dctClass,
    dctDis, dctInsert, dctAddSub);

  //����״̬
  TBillOpenState = (bosNew, bosEdit, bosView, bosSett, bosModi); //��������ʲô״̬��
  TBillCurrState = (bcsEdit, bcsAudit, bcsView, bcsEditAudit); //���ݵ�ǰ��״̬
  TBillBlock = (stBody, stBankCash, stPref, stSubject, stFeeCash); //���壬�ո����˻����Żݣ� ��Ŀ���飬�˷��ո����˻�
  TBillSaveState = (sbNone, soSettle, soDraft, soCancel, soAnswer); //���ݱ�������״̬  Settle���ˣ� Draft�ݸ壬Answerѯ��


  //������ʾ��ʽ
  TShowStyle = (fssShow, fssShowModal);

function GetDataChangeType(AMode: string): TDataChangeType; //���ݲ������ݱ仯ת��

implementation

function GetDataChangeType(AMode: string): TDataChangeType;
begin
  Result := dctNo;
  if AMode = '1' then
    Result := dctAdd
  else if AMode = '2' then
    Result := dctAddCopy
  else if AMode = '4' then
    Result := dctModif
  else if AMode = '6' then
    Result := dctDis
  else if AMode = '5' then
    Result := dctClass;
end;

end.

