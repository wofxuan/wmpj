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
    btVtype, //单据
    btAll);

function GetBaseTypesLevels(ABasic: TBasicType): Integer; //返回基本信息的层数，来判断是否分类等操作
function GetBaseTypeid(ABasic: TBasicType): string;//返回对应的id段名称
function GetBaseTypeFullName(ABasic: TBasicType): string;//返回对应的全名段名称
function GetBaseTypeUsercode(ABasic: TBasicType): string;//返回对应的编号段名称
function GetBaseTypeKeyStr(ABasic: TBasicType): string;//返回对应的关键字
function GetBaseTypeSonnumStr(ABasic: TBasicType): string;//返回对应的儿子数字段名称
function GetBaseTypeTable(ABasic: TBasicType): string;//返回对应的表格名称
function IsSaveToLocal(ABasic: TBasicType): Boolean;//不需要本地化的东东，就加到这里
function BasicTypeToString(ABasic: TBasicType; AName: string = ''): string;//基本信息转化为字符串
function GetBasicTypeCaption(ABasic: TBasicType): string;//对应的标题

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
    btVtype: Result := 'VTypeId';
  else
    Result := '';
  end;
end;

function GetBaseTypeFullName(ABasic: TBasicType): string;
begin
  case ABasic of
    btAtype: Result := 'AFullname';
    btItype: Result := 'IFullname';
    btPtype: Result := 'PFullname';
    btBtype: Result := 'BFullname';
    btEtype: Result := 'EFullname';
    btDtype: Result := 'DFullname';
    btKtype: Result := 'KFullname';
    btVtype: Result := 'VFullname';
  else
    Result := '';
  end;
end;

function GetBaseTypeUsercode(ABasic: TBasicType): string;
begin
  case ABasic of
    btAtype: Result := 'AUsercode';
    btItype: Result := 'IUsercode';
    btPtype: Result := 'PUsercode';
    btBtype: Result := 'BUsercode';
    btEtype: Result := 'EUsercode';
    btDtype: Result := 'DUsercode';
    btKtype: Result := 'KUsercode';
    btVtype: Result := 'VUsercode';
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
    btVtype: Result := 'V';
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
    btVtype: Result := 'tbx_Base_Vtype';
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
    btVtype: Result := 5;
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
    btVtype: Result := 'VSonnum';
  else
    Result := '';
  end;
end;

function IsSaveToLocal(ABasic: TBasicType): Boolean;
begin
  Result := not (ABasic in [btNo, btAtype, btAll]); //不需要本地化的东东，就加到这里
end;

function BasicTypeToString(ABasic: TBasicType; AName: string = ''): string;
var
  aBtString: string;
begin
  case ABasic of
    btAtype: aBtString := 'btAtype';
    btBtype: aBtString := 'btBtype';
    btEtype: aBtString := 'btEtype';
    btKtype: aBtString := 'btKtype';
    btPtype: aBtString := 'btPtype';
    btDtype: aBtString := 'btDtype';
    btVtype: aBtString := 'btVtype';
  else
    aBtString := 'btUtype';
  end;
  Result := aBtString + AName;
end;

function GetBasicTypeCaption(ABasic: TBasicType): string;
var
  aBtString: string;
begin
  case ABasic of
    btAtype: aBtString := '会计科目';
    btBtype: aBtString := '单位';
    btEtype: aBtString := '职员';
    btKtype: aBtString := '仓库';
    btPtype: aBtString := '商品';
    btDtype: aBtString := '部门';
    btVtype: aBtString := '单据';
  else
    aBtString := '未定义';
  end;
  Result := aBtString;
end;

end.

