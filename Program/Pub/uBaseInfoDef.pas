{***************************
基本信息的类型，基本单位的定义
mx 2014-12-18
****************************}
unit uBaseInfoDef;

interface

uses Classes, SysUtils, IniFiles, StrUtils, DB, uDefCom;

type
  //基本信息类型
  TBasicType = (btNo,
    btAtype, //会计科目
    btItype, //加载包
    btPtype, //商品
    btBtype, //单位
    btEtype, //职员
    btDtype, //部门
    btKtype, //仓库
    btAll);

function GetBaseTypesLevels(ABasic: TBasicType): Integer; //返回基本信息的层数，来判断是否分类等操作
function GetBaseTypeid(ABasic: TBasicType): string;//返回对应的id段名称
function GetBaseTypeKeyStr(ABasic: TBasicType): string;//返回对应的关键字
function GetBaseTypeSonnumStr(ABasic: TBasicType): string;//返回对应的儿子数字段名称
function GetBaseTypeTable(ABasic: TBasicType): string;//返回对应的表格名称
function IsSaveToLocal(ABasic: TBasicType): Boolean;//不需要本地化的东东，就加到这里

implementation

function GetBaseTypeid(ABasic: TBasicType): string;
begin
  case ABasic of
    btAtype: Result := 'AtypeId';
    btItype: Result := 'ITypeId';
    btPtype: Result := 'PTypeId';
    btBtype: Result := 'BTypeId';
    btEtype: Result := 'ETypeId';
    btDtype: Result := 'DTypeId';
    btKtype: Result := 'KTypeId';
  else
    Result := '';
  end;
end;

function GetBaseTypeKeyStr(ABasic: TBasicType): string;
begin
  case ABasic of
    btAtype: Result := 'A';
    btItype: Result := 'I';
    btPtype: Result := 'P';
    btBtype: Result := 'B';
    btEtype: Result := 'E';
    btDtype: Result := 'D';
    btKtype: Result := 'K';
  else
    Result := '';
  end;
end;

function GetBaseTypeTable(ABasic: TBasicType): string;
begin
  case ABasic of
    btItype: Result := 'tbx_Base_PackageInfo';
    btPtype: Result := 'tbx_Base_Ptype';
    btBtype: Result := 'tbx_Base_Btype';
    btEtype: Result := 'tbx_Base_Etype';
    btDtype: Result := 'tbx_Base_Dtype';
    btKtype: Result := 'tbx_Base_Ktype';
  else
    Result := '';
  end
end;

function GetBaseTypesLevels(ABasic: TBasicType): Integer;
begin
  case ABasic of
    btAtype: Result := 10;
    btPtype: Result := 5;
    btBtype: Result := 5;
    btEtype: Result := 5;
    btDtype: Result := 5;
    btKtype: Result := 5;
  else
    Result := 1;
  end;
end;

function GetBaseTypeSonnumStr(ABasic: TBasicType): string;
begin
  case ABasic of
    btAtype: Result := 'ASonnum';
    btPtype: Result := 'PSonnum';
    btBtype: Result := 'BSonnum';
    btEtype: Result := 'ESonnum';
    btDtype: Result := 'DSonnum';
    btKtype: Result := 'KSonnum';
  else
    Result := '';
  end;
end;

function IsSaveToLocal(ABasic: TBasicType): Boolean;
begin
  Result := not (ABasic in [btNo, btAtype, btAll]); //不需要本地化的东东，就加到这里
end;

end.

