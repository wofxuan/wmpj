{------------------------------------
  ����˵�����ӿڹ���
  �������ڣ�2014/08/12
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uSysFactory;

interface

uses Classes, SysUtils, uFactoryIntf, uSysSvc;

type
  //��������
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

  //�ӿڹ��� ͨ��������ע��Ľӿ��û�ÿ�λ�ȡ�ӿڶ��ᴴ��һ��ʵ��,���û�ʹ����ɺ��Զ��ͷ�ʵ��.
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

  //��������  ͨ��������ע��Ľӿڲ����û���ȡ���ٴνӿ�,�ڴ��ж�ֻ��һ��ʵ��,����ֻ�е��˳�ϵͳ�Ż��ͷ����ʵ��.
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

  //ʵ������ ʵ������ע�᷽ʽ��ǰ���ֲ�һ��,����Ҫ���ڰ��ⲿ����ʵ�ֵĽӿ�ע���ϵͳ.
  //����������ʵ����IMainForm,��Ϊ��������ʱ�������Ѿ�������,��ʱ����Ҫ��TObjFactory��ϵͳע��IMainform�ӿ�.
  //ע��:ϵͳ������ʹ��TObjFactory��TObjFactoryExע����TInterfacedObject����������ʵ�ֵĽӿ�,
  //��ΪTInterfacedObject�ڽӿ����ü���Ϊ0ʱ���Զ��ͷ�,��������������ʵ������ǰ�ͷŻ��ظ��ͷŵ�����.
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

  //���������п���ͨ�������ע��
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
  Err_IntfExists = '�ӿ�%s�Ѵ��ڣ������ظ�ע�ᣡ';
  Err_IntfNotSupport = '����֧��%s�ӿڣ�';
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
  FInstance := nil;                                         //�ͷ�
end;

{ TObjFactory }

constructor TObjFactory.Create(IID: TGUID; Instance: TObject; OwnsObj: Boolean);
begin
  if not Instance.GetInterface(IID, FRefIntf) then
    raise Exception.CreateFmt('����%sδʵ��%s�ӿڣ�', [Instance.ClassName, GUIDToString(IID)]);

  if (Instance is TInterfacedObject) then
    raise Exception.Create('��Ҫ��TObjFactoryע��TInterfacedObject��������ʵ�ֵĽӿڣ�');

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
