unit uModelBaseListIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBaseListItype = interface(IModelBaseList) //���ذ���Ϣ
    ['{B6A35822-DE97-418C-B529-F69585E9996F}']
  end;

  IModelBaseListPtype = interface(IModelBaseList) //������Ϣ�б�-��Ʒ
    ['{C3E352D1-7029-4D8A-8F1F-F89476E56A56}']
  end;

  IModelBaseListBtype = interface(IModelBaseList) //������Ϣ�б�-��λ
    ['{D5AC51C5-7785-4D9B-AF70-227C04D19C4D}']
  end;

  IModelBaseListEtype = interface(IModelBaseList) //������Ϣ�б�-ְԱ
    ['{38DC320F-F653-4897-B99F-B9B7728982C6}']
  end;

  IModelBaseListDtype = interface(IModelBaseList) //������Ϣ�б�-����
    ['{0B6E8E27-4288-46A2-BAF5-DEE1D3938B71}']
  end;

  IModelBaseListKtype = interface(IModelBaseList) //������Ϣ�б�-�ֿ�     
    ['{60B602D6-134D-4340-8698-133946661A50}']
  end;
implementation

end.
