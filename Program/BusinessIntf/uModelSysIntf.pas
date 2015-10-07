unit uModelSysIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  //������ķ�ʽ
  TTbxCheckType = (tctInsert, tctDel);

  //ϵͳ�������
  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//��ѯ����Ϣ
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//�������ɾ����
  end;

  //���ػ�����
  IModelLocalBasicType = interface(IModelBase)
    ['{2FDC076C-7ED3-4A38-9F7C-20DD7DB3A41C}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//���ػ����ñ���Ϣ
  end;

implementation

end.
