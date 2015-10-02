{***************************
������Ϣ�����ͣ�������λ�Ķ���
mx 2014-12-18
****************************}
unit uBaseInfoDef;

interface

uses Classes, SysUtils, IniFiles, StrUtils, DB, uDefCom;

type
  //������Ϣ����
  TBasicType = (btNo,
    btAtype, //��ƿ�Ŀ
    btItype, //���ذ�
    btPtype, //��Ʒ
    btBtype, //��λ
    btEtype, //ְԱ
    btDtype, //����
    btKtype, //�ֿ�
    btAll);

function GetBaseTypesLevels(ABasic: TBasicType): Integer; //���ػ�����Ϣ�Ĳ��������ж��Ƿ����Ȳ���
function GetBaseTypeid(ABasic: TBasicType): string;//���ض�Ӧ��id������
function GetBaseTypeKeyStr(ABasic: TBasicType): string;//���ض�Ӧ�Ĺؼ���
function GetBaseTypeSonnumStr(ABasic: TBasicType): string;//���ض�Ӧ�Ķ������ֶ�����
function GetBaseTypeTable(ABasic: TBasicType): string;//���ض�Ӧ�ı�������
function IsSaveToLocal(ABasic: TBasicType): Boolean;//����Ҫ���ػ��Ķ������ͼӵ�����

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
  Result := not (ABasic in [btNo, btAtype, btAll]); //����Ҫ���ػ��Ķ������ͼӵ�����
end;

end.
