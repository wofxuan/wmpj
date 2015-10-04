unit uModelSysIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  //������ķ�ʽ
  TTbxCheckType = (tctInsert, tctDel);

  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//��ѯ����Ϣ
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//�������ɾ����
  end;

implementation

end.
