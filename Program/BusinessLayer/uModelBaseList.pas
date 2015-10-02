unit uModelBaseList;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf;

type
  TModelBaseListItype = class(TModelBaseList, IModelBaseListItype) //加载包基本信息处理领域
  end;

  TModelBaseListPtype = class(TModelBaseList, IModelBaseListPtype) //基本信息-商品
  private

  protected

  public
    destructor Destroy; override;

  end;

  TModelBaseListBtype = class(TModelBaseList, IModelBaseListBtype) //基本信息-单位
  end;

  TModelBaseListEtype = class(TModelBaseList, IModelBaseListEtype) //基本信息-职员
  end;

  TModelBaseListDtype = class(TModelBaseList, IModelBaseListDtype) //基本信息-部门
  end;

  TModelBaseListKtype = class(TModelBaseList, IModelBaseListKtype) //基本信息-仓库
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

