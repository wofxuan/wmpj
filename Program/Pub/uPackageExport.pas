{------------------------------------
  ����˵�����������ĺ���
  �������ڣ�2014/08/13
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uPackageExport;

interface

type
  TLoad = procedure(Intf: IInterface); //���ذ������
  TInit = procedure; //��ʼ����(�������а�����ã�
  TFinal = procedure; //�����˳�ǰ����

  TInstallPackage = procedure; //��װ��
  TUnInstallPackage = procedure; //ж�ذ�

implementation

end.
