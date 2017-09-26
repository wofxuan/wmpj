{------------------------------------
  ����˵�������󹤳��ӿڣ����󹤳�ͨ���˽ӿ�����������
  �������ڣ�2014/08/12
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uFactoryFormIntf;

interface

uses Classes, Controls, uParamObject, uDefCom;

type
  //ҵ����ӿ�
  IFormIntf = interface
    ['{2237D50E-2D63-4FF3-8E42-96AD31403C02}']
    procedure CreateParamList(AOwner: TComponent; AParam: TParamObject);
    procedure FrmShow;
    function FrmShowModal: Integer;
    function FrmShowStyle: TShowStyle;//������ʾ�����ͣ��Ƿ�modal, ������������
    procedure FrmFree;
    procedure FrmClose;
    procedure ResizeFrm(AParentForm: TWinControl);//����������С�����ı�
  end;

  //ҵ������ȿ��ƽӿ�
  IFromFactory = interface
    ['{084505D9-26AA-4265-8CDB-03D90F50FF33}']
    function GetFormAsFromName(AFromName: string; AParam: TParamObject; AOwner: TComponent): IFormIntf;
    function GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject; AOwner: TComponent): IFormIntf;
  end;

implementation

end.

