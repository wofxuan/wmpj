unit uMainFormIntf;

interface

uses Forms, Classes, Graphics, Controls, uFactoryFormIntf, uParamObject;

type
  //������ʵ�ֵĽӿ�
  IMainForm = interface
    ['{C3DF922D-4AA5-4874-B0A3-72699DA671C8}']
    function CreateMenu(const Path: string; MenuClick: TNotifyEvent): TObject; //������ͨ�˵�
    procedure CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
    procedure CallFormClass(AFromNo: Integer; AParam: TParamObject); //�򿪴���
    function GetMDIShowClient: TWinControl; //����ͨ������MDI����һ����ʾ������
    procedure SetWindowState(AWindowState: TWindowState); //���ô���״̬����ȡ����¼��ʱ����˸һ��
  end;

  ILogin = interface
    ['{B0D86AEE-A84C-48BC-9620-727998CA0DC5}']
    function Login: Boolean; //��¼����
    procedure loading(AInfo: string); //���ڼ��ص�����
  end;
  
implementation

end.

