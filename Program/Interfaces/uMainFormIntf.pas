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
  end;

implementation

end.

