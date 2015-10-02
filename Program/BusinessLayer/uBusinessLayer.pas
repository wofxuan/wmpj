unit uBusinessLayer;

interface

uses SysUtils, Dialogs, uSvcInfoIntf, uDefCom, uModelControlIntf;

type
  TModelControl = class(TInterfacedObject, ISvcInfo, IModelControl)
  private

  protected
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  {IIModelControl}
    procedure RegModelIntf(AModelIntf: IInterface);
    function GetModelIntf(AModelIntf: TGUID): IInterface;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses uSysFactory, uBusinessLayerPlugin;

procedure CreateModelControl(out anInstance: IInterface);
begin
  anInstance := TModelControl.Create;
end;

{ TExManagement }

constructor TModelControl.Create;
begin

end;

destructor TModelControl.Destroy;
begin

  inherited;
end;

function TModelControl.GetComments: string;
begin
  Result := '用于业务接口的操作';
end;

function TModelControl.GetModuleName: string;
begin
  Result := '业务接口(IExManagement)';
end;

function TModelControl.GetTitle: string;
begin
  Result := '用于业务接口操作';
end;

function TModelControl.GetVersion: string;
begin
  Result := '20150508.001';
end;

procedure TModelControl.RegModelIntf(AModelIntf: IInterface);
begin

end;

function TModelControl.GetModelIntf(AModelIntf: TGUID): IInterface;
begin
  Result := gClassIntfManage.GetNewInstance(AModelIntf);
end;

initialization
  TSingletonFactory.Create(IModelControl, @CreateModelControl);

finalization

end.

