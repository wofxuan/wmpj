{------------------------------------
  功能说明：工厂接口
  创建日期：2014/08/12
  作者：mx
  版权：mx
-------------------------------------}
unit uFactoryIntf;

interface

type
  TIntfCreatorFunc = procedure(out anInstance: IInterface);//直接返回创建对象
  TIntfClassFunc = function(AClassItem: Pointer): TObject;//根据传入的类地址创建对象

  ISysFactory = interface          
    ['{1E82A603-712A-4FBB-8323-95AAD6736F15}']
    procedure CreateInstance(const IID: TGUID; out Obj);
    procedure ReleaseInstance;
    function Supports(IID: TGUID): Boolean;
  end;

  //BPL和DLL都可以使用此接口作为注册接口, BPL也可以直接继承ISysFactory接口的实现类注册接口，可以在函数里面调用
  IRegInf = interface
    ['{426E1E0B-0E88-45A5-A0D4-77BE99D3313E}']
    procedure RegIntfFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegSingletonFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegObjFactory(IID: TGUID; Instance: TObject; OwnsObj: Boolean = False);

  end;

implementation

end.

