{***************************
公共函数
服务端和客户端都能调用的公共的函数
mx 2014-11-28
****************************}
unit uPubFun;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Variants;

function StrToOleData(const AText: string): OleVariant; //STRING 的内容流化到 OLEVARIANT 中
function OleDataToStr(const AData: OleVariant): string; //由 OLEVARIANT 中加载 STRING 的内容
function StringEmpty(const AStr: string): Boolean; //字符串是否为空
function StringFormat(const AFormat: string; const AArgs: array of const): string; //格式字符串
function IsNumberic(AStr: string): Boolean; //字符串是否是数字

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

end.

