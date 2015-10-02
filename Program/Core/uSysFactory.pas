{------------------------------------
  功能说明：接口工厂
  创建日期：2014/08/12
  作者：mx
  版权：mx
-------------------------------------}
unit uSysFactory;

interface

uses Classes, SysUtils, uFactoryIntf, uSysSvc;

type
  //工厂基类
  TBaseFactory = class(TInterfacedObject, ISysFactory)
  private
  protected
    FIntfGUID: TGUID;
    {ISysFactory}
    procedure CreateInstance(const IID: TGUID; out Obj); virtual; abstract;
    procedure ReleaseInstance; virtual; abstract;
    function Supports(IID: TGUID): Boolean; virtual;
  public
    constructor Create(const IID: TGUID);                   //virtual;
    destructor Destroy; override;
  end;

  //接口工厂 通过本工厂注册的接口用户每次获取接口都会创建一个实例,当用户使用完成后自动释放实例.
  TIntfFactory = class(TBaseFactory)
  private
    FIntfCreatorFunc: TIntfCreatorFunc;
  protected
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  public
    constructor Create(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc); virtual;
    destructor Destroy; override;
  end;

  //单例工厂  通过本工厂注册的接口不管用户获取多少次接口,内存中都只有一个实例,而且只有到退出系统才会释放这个实例.
  TSingletonFactory = class(TIntfFactory)
  private
    FInstance: IInterface;
  protected
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  public
    constructor Create(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc); override;
    destructor Destroy; override;
  end;

  //实例工厂 实例工厂注册方式和前两种不一样,它主要用于把外部对象实现的接口注册进系统.
  //比如主窗体实现了IMainForm,因为程序运行时主窗体已经创建了,这时就需要用TObjFactory向系统注册IMainform接口.
  //注意:系统不允许使用TObjFactory或TObjFactoryEx注册由TInterfacedObject对象及其子类实现的接口,
  //因为TInterfacedObject在接口引用计数为0时会自动释放,这样很容易引发实例被提前释放或重复释放的问题.
  TObjFactory = class(TBaseFactory)
  private
    FOwnsObj: Boolean;
    FInstance: TObject;
    FRefIntf: IInterface;
  protected
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  public
    constructor Create(IID: TGUID; Instance: TObject; OwnsObj: Boolean = False);
    destructor Destroy; override;
  end;

  //在其它包中可以通过这个来注册
  TRegInf = class(TInterfacedObject, IRegInf)
  private

  protected
  {IRegSysFactory}
    procedure RegIntfFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegSingletonFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegObjFactory(IID: TGUID; Instance: TObject; OwnsObj: Boolean = False);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses uSysFactoryMgr;

const
  Err_IntfExists = '接口%s已存在，不能重复注册！';
  Err_IntfNotSupport = '对象不支持%s接口！';
{ TBaseFactory }

constructor TBaseFactory.Create(const IID: TGUID);
begin
  if FactoryManager.Exists(IID) then
  begin
    raise Exception.CreateFmt(Err_IntfExists, [GUIDToString(IID)]);
  end;

  FIntfGUID := IID;
  FactoryManager.RegistryFactory(Self);
end;

destructor TBaseFactory.Destroy;
begin

  inherited;
end;

function TBaseFactory.Supports(IID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IID, FIntfGUID);
end;

{ TIntfFactory }

constructor TIntfFactory.Create(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
begin
  self.FIntfCreatorFunc := IntfCreatorFunc;
  inherited Create(IID);
end;

procedure TIntfFactory.CreateInstance(const IID: TGUID; out Obj);
var
  tmpIntf: IInterface;
begin
  self.FIntfCreatorFunc(tmpIntf);
  tmpIntf.QueryInterface(IID, Obj);
end;

destructor TIntfFactory.Destroy;
begin

  inherited;
end;

procedure TIntfFactory.ReleaseInstance;
begin

end;

{ TSingletonFactory }

constructor TSingletonFactory.Create(IID: TGUID;
  IntfCreatorFunc: TIntfCreatorFunc);
begin
  FInstance := nil;
  inherited Create(IID, IntfCreatorFunc);
end;

procedure TSingletonFactory.CreateInstance(const IID: TGUID; out Obj);
begin
  if FInstance = nil then
    inherited Createinstance(IID, FInstance);

  if FInstance.QueryInterface(IID, Obj) <> S_OK then
    raise Exception.CreateFmt(Err_IntfNotSupport, [GUIDToString(IID)]);
end;

destructor TSingletonFactory.Destroy;
begin
  FInstance := nil;
  inherited;
end;

procedure TSingletonFactory.ReleaseInstance;
begin
  FInstance := nil;                                         //释放
end;

{ TObjFactory }

constructor TObjFactory.Create(IID: TGUID; Instance: TObject; OwnsObj: Boolean);
begin
  if not Instance.GetInterface(IID, FRefIntf) then
    raise Exception.CreateFmt('对象%s未实现%s接口！', [Instance.ClassName, GUIDToString(IID)]);

  if (Instance is TInterfacedObject) then
    raise Exception.Create('不要用TObjFactory注册TInterfacedObject及其子类实现的接口！');

  FOwnsObj := OwnsObj;
  FInstance := Instance;
  inherited Create(IID);
end;

procedure TObjFactory.CreateInstance(const IID: TGUID; out Obj);
begin
  IInterface(Obj) := FRefIntf;
end;

destructor TObjFactory.Destroy;
begin

  inherited;
end;

procedure TObjFactory.ReleaseInstance;
begin
  inherited;
  FRefIntf := nil;
  if FOwnsObj then
    FreeAndNil(FInstance);
end;

{ TRegSysFactory }

constructor TRegInf.Create;
begin

end;

destructor TRegInf.Destroy;
begin

  inherited;
end;

procedure TRegInf.RegIntfFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
begin
  TIntfFactory.Create(IID, IntfCreatorFunc);
end;

procedure TRegInf.RegObjFactory(IID: TGUID; Instance: TObject;
  OwnsObj: Boolean);
begin
  TObjFactory.Create(IID, Instance, OwnsObj);
end;

procedure TRegInf.RegSingletonFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
begin
  TSingletonFactory.Create(IID, IntfCreatorFunc);
end;

procedure CreateRegInf(out anInstance: IInterface);
begin
  anInstance := TRegInf.Create;
end;

initialization
  TSingletonFactory.Create(IRegInf, @CreateRegInf);

finalization

end.

