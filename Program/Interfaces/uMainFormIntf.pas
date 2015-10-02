unit uMainFormIntf;

interface

uses Forms, Classes, Graphics, uFactoryFormIntf;

type
  //������ʵ�ֵĽӿ�
  IMainForm = interface
    ['{C3DF922D-4AA5-4874-B0A3-72699DA671C8}']
    function CreateMenu(const Path: string; MenuClick: TNotifyEvent): TObject; //������ͨ�˵�
    procedure CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
  end;

implementation

end.
