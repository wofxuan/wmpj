{***************************
业务公共函数接口
获取本地化等公共函数
mx 2015-05-08
****************************}
unit uModelFunIntf;

interface

uses SysUtils, uParamObject, uBaseInfoDef, uDefCom;

type

  //业务公共函数接口
  IModelFun = interface
    ['{C3B4809A-0778-4A97-85FE-96788D5563A0}']
    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string;
end;


implementation

end.

