unit uModelBaseTypeIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBaseTypeItype = interface(IModelBaseType) //������Ϣ�༭��-���ذ�
    ['{9743BAEE-5ADD-459E-8DFC-1168B55FDDDE}']
  end;

  IModelBaseTypePtype = interface(IModelBaseType) //������Ϣ�༭��-��Ʒ
    ['{759C8A8C-D902-4766-A655-450F880D582F}']
  end;

  IModelBaseTypeBtype = interface(IModelBaseType) //������Ϣ�༭��-��λ
    ['{DDD5E30A-E089-4E81-84AE-DC5A8D8ABEEE}']
  end;

  IModelBaseTypeEtype = interface(IModelBaseType) //������Ϣ�༭��-ְԱ
    ['{5E8A8A03-D074-4390-8E4D-F3AEA4A239BA}']
  end;

  IModelBaseTypeDtype = interface(IModelBaseType) //������Ϣ�༭��-����
    ['{A5C30EA0-E998-4232-8825-7B7BF37DC633}']
  end;

  IModelBaseTypeKtype = interface(IModelBaseType) //������Ϣ�༭��-�ֿ�
    ['{F6F65231-46D9-4B17-988B-8E685E1BD0CC}']                               
  end;
implementation

end.
