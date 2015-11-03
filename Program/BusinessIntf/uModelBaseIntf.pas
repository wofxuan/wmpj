unit uModelBaseIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uDefCom, uBillData;

type
  IModelBase = interface(IInterface)
    ['{D4A81B24-B133-4DC4-9BEE-DF637C894A81}']
    procedure SetParamList(const Value: TParamObject);
  end;

  //������Ϣ������
  IModelBaseType = interface(IModelBase)
    ['{40DF4178-D8D6-4816-80D1-D48D8DC7ED2E}']
    procedure OnSetDataEvent(AOnSetDataEvent: TParamDataEvent);//�����ݿ��е���ʾ������
    procedure OnGetDataEvent(AOnGetDataEvent: TParamDataEvent);//�ѽ��������д����������
    function IniData(ATypeId: string): Integer;
    function DataChangeType: TDataChangeType; // ��ǰҵ��������ݱ仯����
    function SaveData: Boolean; //��������
    function CurTypeId: string; //��ǰID
    procedure SetBasicType(const Value: TBasicType);
  end;

  //������Ϣ�б�
  IModelBaseList = interface(IModelBase)
    ['{DBBF9289-8356-45B8-B433-065088B600B7}']
    function GetBasicType: TBasicType;
    procedure SetBasicType(const Value: TBasicType);
    procedure LoadGridData(ATypeid, ACustom: string; ACdsBaseList: TClientDataSet);
    function DeleteRec(ATypeId: string): Boolean; //ɾ��һ����¼
  end;

  //���ݲ���
  IModelBill = interface(IModelBase)
    ['{192C9A3B-07F4-43E9-952D-8C486AF158C3}']
    function SaveBill(const ABillData: TBillData; AOutPutData: TParamObject): Integer; //���浥��
  end;
  
implementation

end.

