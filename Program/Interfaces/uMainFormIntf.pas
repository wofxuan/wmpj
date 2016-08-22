unit uMainFormIntf;

interface

uses Forms, Classes, Graphics, Controls, uFactoryFormIntf, uParamObject;

type
  //主窗口实现的接口
  IMainForm = interface
    ['{C3DF922D-4AA5-4874-B0A3-72699DA671C8}']
    function CreateMenu(const Path: string; MenuClick: TNotifyEvent): TObject; //创建普通菜单
    procedure CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
    procedure CallFormClass(AFromNo: Integer; AParam: TParamObject); //打开窗体
    function GetMDIShowClient: TWinControl; //让普通窗体像MDI窗体一样显示点区域
  end;

implementation

end.

