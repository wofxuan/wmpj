unit uModelBaseListIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBaseListItype = interface(IModelBaseList) //加载包信息
    ['{B6A35822-DE97-418C-B529-F69585E9996F}']
  end;

  IModelBaseListPtype = interface(IModelBaseList) //基本信息列表-商品
    ['{C3E352D1-7029-4D8A-8F1F-F89476E56A56}']
  end;

  IModelBaseListBtype = interface(IModelBaseList) //基本信息列表-单位
    ['{D5AC51C5-7785-4D9B-AF70-227C04D19C4D}']
  end;

  IModelBaseListEtype = interface(IModelBaseList) //基本信息列表-职员
    ['{38DC320F-F653-4897-B99F-B9B7728982C6}']
  end;

  IModelBaseListDtype = interface(IModelBaseList) //基本信息列表-部门
    ['{0B6E8E27-4288-46A2-BAF5-DEE1D3938B71}']
  end;

  IModelBaseListKtype = interface(IModelBaseList) //基本信息列表-仓库     
    ['{60B602D6-134D-4340-8698-133946661A50}']
  end;
implementation

end.

