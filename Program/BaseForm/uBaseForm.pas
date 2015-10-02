unit uBaseForm;

interface

uses Classes, SysUtils, Dialogs, uSvcInfoIntf, uDefCom, uParamObject, uFactoryFormIntf;

type
  TFromFactory = class(TInterfacedObject, ISvcInfo, IFromFactory)
  private

  protected
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  {IFromFactory}
    function GetFormAsFromName(AFromName: string; AParam: TParamObject; AOwner: TComponent): IFormIntf; overload;
    function GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject; AOwner: TComponent): IFormIntf; overload;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses uSysFactory, uBaseFormPlugin;

procedure CreateFromFactory(out anInstance: IInterface);
begin
  anInstance := TFromFactory.Create;
end;

{ TExManagement }

constructor TFromFactory.Create;
begin

end;

destructor TFromFactory.Destroy;
begin

  inherited;
end;

function TFromFactory.GetComments: string;
begin
  Result := '用于业务显示窗体接口的操作';
end;

function TFromFactory.GetModuleName: string;
begin
  Result := '业务窗体接口(IExManagement)';
end;

function TFromFactory.GetTitle: string;
begin
  Result := '用于业务窗体接口操作';
end;

function TFromFactory.GetVersion: string;
begin
  Result := '20150508.001';
end;

function TFromFactory.GetFormAsFromName(AFromName: string; AParam: TParamObject;
  AOwner: TComponent): IFormIntf;
begin
  Result := IFormIntf(gFormManage.GetFormAsFromName(AFromName, AParam, AOwner));
end;

function TFromFactory.GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject;
  AOwner: TComponent): IFormIntf;
begin
  Result := IFormIntf(gFormManage.GetFormAsFromNo(AFromNo, AParam, AOwner));
end;

initialization
  TSingletonFactory.Create(IFromFactory, @CreateFromFactory);

finalization

end.


