unit uModelBaseList;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf;

type
  TModelBaseListItype = class(TModelBaseList, IModelBaseListItype) //���ذ�������Ϣ��������
  end;

  TModelBaseListPtype = class(TModelBaseList, IModelBaseListPtype) //������Ϣ-��Ʒ
  private

  protected

  public
    destructor Destroy; override;

  end;

  TModelBaseListBtype = class(TModelBaseList, IModelBaseListBtype) //������Ϣ-��λ
  end;

  TModelBaseListEtype = class(TModelBaseList, IModelBaseListEtype) //������Ϣ-ְԱ
  end;

  TModelBaseListDtype = class(TModelBaseList, IModelBaseListDtype) //������Ϣ-����
  end;

  TModelBaseListKtype = class(TModelBaseList, IModelBaseListKtype) //������Ϣ-�ֿ�
  end;
  
implementation

{ TTModelBaseListItype }

{ TModelBaseListPtype }

destructor TModelBaseListPtype.Destroy;
begin

  inherited;
end;

initialization
  gClassIntfManage.addClass(TModelBaseListItype, IModelBaseListItype);
  gClassIntfManage.addClass(TModelBaseListPtype, IModelBaseListPtype);
  gClassIntfManage.addClass(TModelBaseListBtype, IModelBaseListBtype);
  gClassIntfManage.addClass(TModelBaseListEtype, IModelBaseListEtype);
  gClassIntfManage.addClass(TModelBaseListDtype, IModelBaseListDtype);
  gClassIntfManage.addClass(TModelBaseListKtype, IModelBaseListKtype);

end.
