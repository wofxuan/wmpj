{***************************
���湫�������Ĳ���
mx 2014-11-28
****************************}
unit uFunApp;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, uParamObject, uDefCom;

procedure OpenBillFrm(AVchType, AVchCode: Integer; AOpenState: TBillOpenState); //�򿪵���

implementation

uses uSysSvc, uVchTypeDef, uMoudleNoDef, uMainFormIntf, uOtherIntf;

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
      VchType_Order_Buy: (SysService as  IMainForm).CallFormClass(fnMdlBillOrderBuy, aParam);
      VchType_Order_Sale: (SysService as  IMainForm).CallFormClass(fnMdlBillOrderSale, aParam);
      VchType_Buy: (SysService as  IMainForm).CallFormClass(fnMdlBillBuy, aParam);
      VchType_Sale: (SysService as  IMainForm).CallFormClass(fnMdlBillSale, aParam);
    else
      raise(SysService as IExManagement).CreateFunEx('û�����õ�������[' + IntToStr(AVchType) + ']��Ӧ�Ĵ��壡');
    end;
  finally
    aParam.Free;
  end;
end;
  
end.
