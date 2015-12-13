{***************************
系统配置相关的接口
mx 2015-10-11
****************************}

unit uModelSysIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uModelOtherSet;

type
  //操作表的方式
  TTbxCheckType = (tctInsert, tctDel);

  //系统表格配置
  IModelTbxCfg = interface(IModelBase)
    ['{9AD99D8B-256C-49F7-B0AB-23DE9F311F84}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//查询表信息
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;//加入或者删除表
    procedure GetTbxInfoRec(ATbxId: Integer; ACdsBaseList: TClientDataSet);//得到一条具体记录
    function ModfifyTbxInfoRec(ATbxId: Integer; ATbxInfoRec: TParamObject): Boolean;//修改记录
  end;

  //本地化配置
  IModelBasicTypeCfg = interface(IModelBase)
    ['{2FDC076C-7ED3-4A38-9F7C-20DD7DB3A41C}']
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);//本地化配置表信息
  end;

var
  TSys_TbxType: TIDDisplayText;//表格类型

implementation

initialization
  TSys_TbxType := TIDDisplayText.Create;
  TSys_TbxType.AddItem('-1', '未定义');
  TSys_TbxType.AddItem('0', '基本信息');
  TSys_TbxType.AddItem('1', '单据');
  TSys_TbxType.AddItem('2', '其它');

finalization
  TSys_TbxType.Free;
  
end.
