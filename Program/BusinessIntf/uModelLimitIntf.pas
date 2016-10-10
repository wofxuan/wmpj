{***************************
权限相关的接口
mx 2016-08-22
****************************}

unit uModelLimitIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  //权限类型
  Limit_Un = 0; //未配置
  Limit_Base = 1; //基本信息
  Limit_Bill = 2; //单据
  Limit_Report = 3; //报表
  Limit_Data = 4; //数据
  Limit_Other = 5; //其它

  Limit_Base_View = 1; //基本信息权限-查看
  Limit_Base_Add = 2; //基本信息权限-新增
  Limit_Base_Class = 4; //基本信息权限-分类
  Limit_Base_Modify = 8; //基本信息权限-修改
  Limit_Base_Del = 16; //基本信息权限-删除
  Limit_Base_Print = 32; //基本信息权限-打印

  Limit_Bill_View = 1; //单据-查看
  Limit_Bill_Input = 2; //单据-输入
  Limit_Bill_Settle = 4; //单据-过账
  Limit_Bill_Print = 8; //单据-打印

  Limit_Save_Role = 1; //保存角色信息
  Limit_Modify_Role = 2; //修改角色信息
  Limit_Del_Role = 3; //删除角色信息
  Limit_Save_RoleAction = 4; //保存或修改一条角色对应的权限
  Limit_Save_RU = 5; //增加一条角色和用户点映射关系
  Limit_Del_RU = 6; //删除一条角色和用户点映射关系

type
  IModelLimit = interface(IModelBase)
    ['{32E62488-975F-461D-AE3F-160AE3962F27}']
    function UserLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //加载用户对应类型的权限
    function LimitData(AParam: TParamObject; ACdsLimit: TClientDataSet): Integer; //功能,角色等数据
    function SaveLimit(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //保存角色，或角色与用户映射等
    function CheckLimit(ALimitDo: Integer; ALimitId, AUserId: string): Boolean; //判断某个用户是否具有某种权限点某种操作
    function GetLimitId(AKeyId: Integer): string; //某个模块对应的LimitId
  end;

implementation

end.

