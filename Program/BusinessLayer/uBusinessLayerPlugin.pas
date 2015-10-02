unit uBusinessLayerPlugin;

interface

uses SysUtils, Classes, Windows, uPluginBase, uModelParent;

const
    Err_FrmExists = '接口%s已存在，不能重复注册！';
    Err_FrmNotSupport = '%s接口不存在，请先注册！';

Type
  TModelBaseClass = class of TModelBase;

  PClassIntfItem = ^TClassIntfItem;
  TClassIntfItem = record
    ClassItem: TModelBaseClass;
    IntfGUID: TGUID;
  end;

  TBusinessLayerPlugin = Class(TPlugin)
  private

  protected

  public
    Constructor Create(Intf: IInterface);override;
    Destructor Destroy;override;

    procedure Init; override;
    procedure final; override;
  end;

  TClassIntfManage = Class(TObject)
  private
    FClassIntfList: array of PClassIntfItem;

  protected
    function GetItemByName(AIntf: TGUID): PClassIntfItem;
  public
    Constructor Create;
    Destructor Destroy; override;

    function GetNewInstance(AModelIntf: TGUID): IInterface;//获取业务接口的实例
    procedure AddClass(AClassItem: Pointer; AIntf: TGUID);

  end;

var
  gClassIntfManage: TClassIntfManage;

implementation

uses uSysSvc, uPubFun, uFactoryIntf, uOtherIntf, uBasicDataLocalClass;

{ TBusinessLayerPlugin }

constructor TBusinessLayerPlugin.Create(Intf: IInterface);
begin
  inherited;

end;

destructor TBusinessLayerPlugin.Destroy;
begin

  inherited;
end;

procedure TBusinessLayerPlugin.final;
begin
  inherited;

end;

procedure TBusinessLayerPlugin.Init;
begin
  inherited;
  gBasicDataLocal.GetBasicDataAll();
end;

{ TClassIntfManage }

procedure TClassIntfManage.AddClass(AClassItem: Pointer; AIntf: TGUID);
var
  aItemCount: Integer;
  aItem: PClassIntfItem;
begin
  aItem :=  GetItemByName(AIntf);
  if Assigned(aItem) then
  begin
    raise (SysService as IExManagement).CreateSysEx(StringFormat(Err_FrmExists, [GUIDToString(AIntf)]));
  end;
  New(aItem);
  try
    aItem.ClassItem := AClassItem;
    aItem.IntfGUID := AIntf;

    aItemCount := Length(FClassIntfList) + 1;
    SetLength(FClassIntfList, aItemCount);
    FClassIntfList[aItemCount - 1] := aItem;
  except
    Dispose(aItem);
  end;
end;

constructor TClassIntfManage.Create;
begin
  SetLength(FClassIntfList, 0);
end;

destructor TClassIntfManage.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FClassIntfList) - 1 do
  begin
    Dispose(FClassIntfList[i]);
  end;
  SetLength(FClassIntfList, 0);
  
  inherited;
end;

function TClassIntfManage.GetNewInstance(AModelIntf: TGUID): IInterface;
var
  i: Integer;
  aIntf: TGUID;
  aClassItem: TModelBaseClass;
  aModelBase: TModelBase;
  aInstance: IInterface;
  aItemInf: PClassIntfItem;
begin
  aItemInf :=  GetItemByName(AModelIntf);
  if not Assigned(aItemInf) then
  begin
    raise (SysService as IExManagement).CreateSysEx(StringFormat(Err_FrmNotSupport, [GUIDToString(AModelIntf)]));
  end;

  aIntf := aItemInf.IntfGUID;
  aClassItem := aItemInf.ClassItem;

  aModelBase := TModelBase(AClassItem.NewInstance);  //方法的目的是要建立对象的实例空间;不能用TObject和TModelBase不知道为什么
  aModelBase.Create;

  aModelBase.GetInterface(AModelIntf, aInstance);
  Result := aInstance;
end;

function TClassIntfManage.GetItemByName(AIntf: TGUID): PClassIntfItem;
var
  i: Integer;
  aClassItem: TModelBaseClass;
  aModelBase: TModelBase;
  aItemInf: TGUID;
begin
  Result := nil;
  for i := 0 to Length(FClassIntfList) - 1 do
  begin
    aItemInf := FClassIntfList[i].IntfGUID;
    aClassItem := FClassIntfList[i].ClassItem;
    if IsEqualGUID(AIntf, aItemInf) then
    begin
      Result := FClassIntfList[i];
      Break;
    end;
  end;
end;

initialization
  gClassIntfManage := TClassIntfManage.Create;
  
finalization
  gClassIntfManage.Free;
  
end.

