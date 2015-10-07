unit uModelSysIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  //操作表的方式
  TTbxCheckType = (tctInsert, tctDel);

  //系统表格配置
  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//查询表信息
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//加入或者删除表
  end;

  //本地化配置
  IModelLocalBasicType = interface(IModelBase)
    ['{2FDC076C-7ED3-4A38-9F7C-20DD7DB3A41C}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//本地化配置表信息
  end;

implementation

end.
