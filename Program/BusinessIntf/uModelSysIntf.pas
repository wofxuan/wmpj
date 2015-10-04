unit uModelSysIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  //操作表的方式
  TTbxCheckType = (tctInsert, tctDel);

  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//查询表信息
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//加入或者删除表
  end;

implementation

end.
