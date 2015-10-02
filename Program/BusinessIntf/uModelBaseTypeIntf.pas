unit uModelBaseTypeIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBaseTypeItype = interface(IModelBaseType) //基本信息编辑框-加载包
    ['{9743BAEE-5ADD-459E-8DFC-1168B55FDDDE}']
  end;

  IModelBaseTypePtype = interface(IModelBaseType) //基本信息编辑框-商品
    ['{759C8A8C-D902-4766-A655-450F880D582F}']
  end;

  IModelBaseTypeBtype = interface(IModelBaseType) //基本信息编辑框-单位
    ['{DDD5E30A-E089-4E81-84AE-DC5A8D8ABEEE}']
  end;

  IModelBaseTypeEtype = interface(IModelBaseType) //基本信息编辑框-职员
    ['{5E8A8A03-D074-4390-8E4D-F3AEA4A239BA}']
  end;

  IModelBaseTypeDtype = interface(IModelBaseType) //基本信息编辑框-部门
    ['{A5C30EA0-E998-4232-8825-7B7BF37DC633}']
  end;

  IModelBaseTypeKtype = interface(IModelBaseType) //基本信息编辑框-仓库
    ['{F6F65231-46D9-4B17-988B-8E685E1BD0CC}']                               
  end;
implementation

end.

