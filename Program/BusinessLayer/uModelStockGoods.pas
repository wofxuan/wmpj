unit uModelStockGoods;

interface
uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelStockGoodsInf;

type
  TModelStockGoods = class(TModelBase, IModelStockGoods)
    function LoadStockGoodsIni(AParam: TParamObject; ACdsIniData: TClientDataSet): Integer;
    function ModifyOneRec(AParam: TParamObject): Integer;
    function InitOver(AParam: TParamObject): Integer;
    function P_OneCheck(AParam: TParamObject): Integer;
    function QryCheck(AParam: TParamObject; ACdsCheckData: TClientDataSet): Integer;
    function SaveOneCheck(AParam: TParamObject): Integer;
  end;

implementation

uses uModelFunCom, uOtherIntf;

{ TModelStockGoods }

function TModelStockGoods.InitOver(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aErrorMsg: string;
begin
  try
    aRet := gMFCom.ExecProcByName('pbx_Sys_InitOver', AParam);
    if aRet <> 0 then
    begin
      aErrorMsg := AParam.AsString('@ErrorValue'); 
      gMFCom.ShowMsgBox(aErrorMsg, '��ʾ', mbtInformation);
    end
    else
    begin
      if AParam.AsInteger('@DoType') = 1 then
        gMFCom.ShowMsgBox('ϵͳ�ڳ������Ѿ����������Կ�ʼ�����ˣ�', '��ʾ', mbtInformation)
      else
        gMFCom.ShowMsgBox('ϵͳ�ָ����ڳ�״̬�����Լ����޸��ڳ���', '��ʾ', mbtInformation);
    end;
    Result := aRet;
  finally

  end;
end;

function TModelStockGoods.LoadStockGoodsIni(AParam: TParamObject;
  ACdsIniData: TClientDataSet): Integer;
begin
  try
    gMFCom.ExecProcBackData('pbx_Stock_LoadIni', AParam, ACdsIniData);
  finally

  end;
end;

function TModelStockGoods.ModifyOneRec(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aErrorMsg: string;
begin
  try
    aRet := gMFCom.ExecProcByName('pbx_Stock_ModifyIni', AParam);
    if aRet <> 0 then
    begin
      aErrorMsg := AParam.AsString('@ErrorValue'); 
      gMFCom.ShowMsgBox(aErrorMsg, '��ʾ', mbtInformation);
    end;
    Result := aRet;
  finally

  end;
end;

function TModelStockGoods.P_OneCheck(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aErrorMsg: string;
begin
  try
    aRet := gMFCom.ExecProcByName('pbx_Stock_OneCheck', AParam);
    if aRet <> 0 then
    begin
      aErrorMsg := AParam.AsString('@ErrorValue'); 
      gMFCom.ShowMsgBox(aErrorMsg, '��ʾ', mbtInformation);
    end;
    Result := aRet;
  finally
               
  end;
end;

function TModelStockGoods.QryCheck(AParam: TParamObject;
  ACdsCheckData: TClientDataSet): Integer;
begin
  try
    gMFCom.ExecProcBackData('pbx_Stock_QryCheck', AParam, ACdsCheckData);
  finally

  end;
end;

function TModelStockGoods.SaveOneCheck(AParam: TParamObject): Integer;
var
  aRet: Integer;
  aErrorMsg: string;
begin
  try
    aRet := gMFCom.ExecProcByName('pbx_Stock_SaveCheck', AParam);
    if aRet <> 0 then
    begin
      aErrorMsg := AParam.AsString('@ErrorValue'); 
      gMFCom.ShowMsgBox(aErrorMsg, '��ʾ', mbtInformation);
    end;
    Result := aRet;
  finally
               
  end;
end;

initialization
  gClassIntfManage.addClass(TModelStockGoods, IModelStockGoods);

end.


