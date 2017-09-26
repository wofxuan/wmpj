{------------------------------------
  功能说明：对象工厂接口，对象工程通过此接口来创建对象
  创建日期：2014/08/12
  作者：mx
  版权：mx
-------------------------------------}
unit uFactoryFormIntf;

interface

uses Classes, Controls, uParamObject, uDefCom;

type
  //业务窗体接口
  IFormIntf = interface
    ['{2237D50E-2D63-4FF3-8E42-96AD31403C02}']
    procedure CreateParamList(AOwner: TComponent; AParam: TParamObject);
    procedure FrmShow;
    function FrmShowModal: Integer;
    function FrmShowStyle: TShowStyle;//窗体显示的类型，是否modal, 或者在销毁中
    procedure FrmFree;
    procedure FrmClose;
    procedure ResizeFrm(AParentForm: TWinControl);//窗体容器大小发生改变
  end;

  //业务窗体调度控制接口
  IFromFactory = interface
    ['{084505D9-26AA-4265-8CDB-03D90F50FF33}']
    function GetFormAsFromName(AFromName: string; AParam: TParamObject; AOwner: TComponent): IFormIntf;
    function GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject; AOwner: TComponent): IFormIntf;
  end;

implementation

end.

