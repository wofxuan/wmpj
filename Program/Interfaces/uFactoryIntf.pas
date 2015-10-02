{------------------------------------
  ����˵���������ӿ�
  �������ڣ�2014/08/12
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uFactoryIntf;

interface

type
  TIntfCreatorFunc = procedure(out anInstance: IInterface);//ֱ�ӷ��ش�������
  TIntfClassFunc = function(AClassItem: Pointer): TObject;//���ݴ�������ַ��������

  ISysFactory = interface          
    ['{1E82A603-712A-4FBB-8323-95AAD6736F15}']
    procedure CreateInstance(const IID: TGUID; out Obj);
    procedure ReleaseInstance;
    function Supports(IID: TGUID): Boolean;
  end;

  //BPL��DLL������ʹ�ô˽ӿ���Ϊע��ӿ�, BPLҲ����ֱ�Ӽ̳�ISysFactory�ӿڵ�ʵ����ע��ӿڣ������ں����������
  IRegInf = interface
    ['{426E1E0B-0E88-45A5-A0D4-77BE99D3313E}']
    procedure RegIntfFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegSingletonFactory(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc);
    procedure RegObjFactory(IID: TGUID; Instance: TObject; OwnsObj: Boolean = False);

  end;

implementation

end.
