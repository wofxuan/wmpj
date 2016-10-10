{***************************
��������
����˺Ϳͻ��˶��ܵ��õĹ����ĺ���
mx 2014-11-28
****************************}
unit uPubFun;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Variants;

function StrToOleData(const AText: string): OleVariant; //STRING ������������ OLEVARIANT ��
function OleDataToStr(const AData: OleVariant): string; //�� OLEVARIANT �м��� STRING ������
function StringEmpty(const AStr: string): Boolean; //�ַ����Ƿ�Ϊ��
function StringFormat(const AFormat: string; const AArgs: array of const): string; //��ʽ�ַ���
function IsNumberic(AStr: string): Boolean; //�ַ����Ƿ�������
function StringToInt(const AStr: string; ADefault: Integer = 0): Integer; //�ַ���ת��Ϊ����
function IntToString(const AStr: Integer): string; //������Ϊ�ַ���ת

function IfThen(condition: Boolean; const ATrue, AFalse: string): string;
function IfThenExt(condition: Boolean; const ATrue, AFalse: Extended): Extended;
function IfThenInt(condition: Boolean; const ATrue, AFalse: Integer): Integer;
function IfThenBool(condition: Boolean; const ATrue, AFalse: Boolean): Boolean;

implementation

function StrToOleData(const AText: string): OleVariant;
var
  nSize: Integer;
  pData: Pointer;
begin
  nSize := Length(AText);
  if nSize = 0 then
    Result := null
  else
  begin
    Result := VarArrayCreate([0, nSize - 1], varByte);
    pData := VarArrayLock(Result);
    try
      Move(Pchar(AText)^, pData^, nSize);
    finally
      VarArrayUnlock(Result);
    end;
  end;
end;

function OleDataToStr(const AData: OleVariant): string;
var
  nSize: Integer;
  pData: Pointer;
begin
  if AData = Null then
    Result := ''
  else
  begin
    nSize := VarArrayHighBound(AData, 1) - VarArrayLowBound(AData, 1) + 1;
    SetLength(Result, nSize);
    pData := VarArrayLock(AData);
    try
      Move(pData^, Pchar(Result)^, nSize);
    finally
      VarArrayUnlock(AData);
    end;
  end;
end;

function StringEmpty(const AStr: string): Boolean;
begin
  Result := False;
  if Trim(AStr) = EmptyStr then
  begin
    Result := True;
  end;
end;

function StringFormat(const AFormat: string; const AArgs: array of const): string;
begin
  Result := Format(AFormat, AArgs)
end;

function IsNumberic(AStr: string): Boolean;
var
  i: integer;
begin
  Result := False;
  if StringEmpty(AStr) then Exit;
  AStr := trim(AStr);
  for i := 1 to length(AStr) do
  begin
    if not (AStr[i] in ['0'..'9']) then 
    begin
      Result := false; 
      exit;
    end;
  end;
  Result := True;
end;

function StringToInt(const AStr: string; ADefault: Integer = 0): Integer;
begin
  Result := StrToIntDef(AStr, ADefault);
end;

function IntToString(const AStr: Integer): string;
begin
  Result := IntToStr(AStr);
end;

function IfThen(condition: Boolean; const ATrue, AFalse: string): string;
begin
  if condition then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThenExt(condition: Boolean; const ATrue, AFalse: Extended): Extended;
begin
  if condition then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThenInt(condition: Boolean; const ATrue, AFalse: Integer): Integer;
begin
  if condition then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThenBool(condition: Boolean; const ATrue, AFalse: Boolean): Boolean;
begin
  if condition then
    Result := ATrue
  else
    Result := AFalse;
end;

end.

