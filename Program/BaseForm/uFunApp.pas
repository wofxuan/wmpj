{***************************
界面公共函数的操作
mx 2014-11-28
****************************}
unit uFunApp;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, uParamObject, uDefCom, uModelLimitIntf;

procedure OpenBillFrm(AVchType, AVchCode: Integer; AOpenState: TBillOpenState); //打开单据

function CheckLimit(AMoudleNo, ALimitDo: Integer; AIsShowMsg: Boolean = True): Boolean; //权限检查


implementation

uses uSysSvc, uVchTypeDef, uMoudleNoDef, uMainFormIntf, uOtherIntf, uModelControlIntf;

function CheckLimit(AMoudleNo, ALimitDo: Integer; AIsShowMsg: Boolean = True): Boolean; //权限检查
var
  aModelLimit: IModelLimit;
  aLimitId: string;
begin
  Result := False;
  aModelLimit := IModelLimit((SysService as IModelControl).GetModelIntf(IModelLimit));
  aLimitId := aModelLimit.GetLimitId(AMoudleNo);
  if AIsShowMsg then
  begin
    aModelLimit.CheckLimit(ALimitDo, aLimitId, OperatorID);
  end
  else
  begin
    try
      aModelLimit.CheckLimit(ALimitDo, aLimitId, OperatorID);
    except
      Exit;
    end;
  end;
  Result := True;
end;

procedure OpenBillFrm(AVchType, AVchCode: Integer; AOpenState: TBillOpenState);
var
  aParam: TParamObject;
begin
  aParam := TParamObject.Create;
  try
    aParam.Add('VchType', aVchType);
    aParam.Add('VchCode', aVchCode);
    aParam.Add('bosState', Ord(AOpenState));
    case AVchType of
      VchType_Order_Buy: (SysService as IMainForm).CallFormClass(fnMdlBillOrderBuy, aParam);
      VchType_Order_Sale: (SysService as IMainForm).CallFormClass(fnMdlBillOrderSale, aParam);
      VchType_Buy: (SysService as IMainForm).CallFormClass(fnMdlBillBuy, aParam);
      VchType_Sale: (SysService as IMainForm).CallFormClass(fnMdlBillSale, aParam);
    else
      raise(SysService as IExManagement).CreateFunEx('没有配置单据类型[' + IntToStr(AVchType) + ']对应的窗体！');
    end;
  finally
    aParam.Free;
  end;
end;

end.

