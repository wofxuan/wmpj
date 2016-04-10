{***************************
ϵͳ������صĽӿ�
mx 2015-10-11
****************************}

unit uModelSysIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uModelOtherSet;

type
  //������ķ�ʽ
  TTbxCheckType = (tctInsert, tctDel);

  //������ϵͳ���ù���
  IModelSys = interface(IModelBase)
    ['{E5AF1B6C-2720-4D28-85C9-A3E1762715BB}']
    function ReBuild(AParam: TParamObject): Integer;//ϵͳ�ؽ�
    procedure SetParam(const AName, AValue: string);//����ϵͳ����
    function GetParam(const AName: string): string;//��ȡϵͳ����
  end;

  //ϵͳ�������
  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//��ѯ����Ϣ
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//�������ɾ����
    procedure GetTbxInfoRec(ATbxId: Integer; ACdsBaseList: TClientDataSet);//�õ�һ�������¼
    function ModfifyTbxInfoRec(ATbxId: Integer; ATbxInfoRec: TParamObject): Boolean;//�޸ļ�¼
  end;

  //���ػ�����
  IModelBasicTypeCfg = interface(IModelBase)
    ['{2FDC076C-7ED3-4A38-9F7C-20DD7DB3A41C}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//���ػ����ñ���Ϣ
  end;

var
  TSys_TbxType: TIDDisplayText;//�������

implementation

initialization
  TSys_TbxType := TIDDisplayText.Create;
  TSys_TbxType.AddItem('-1', 'δ����');
  TSys_TbxType.AddItem('0', '������Ϣ');
  TSys_TbxType.AddItem('1', '����');
  TSys_TbxType.AddItem('2', '����');

finalization
  TSys_TbxType.Free;
  
end.
