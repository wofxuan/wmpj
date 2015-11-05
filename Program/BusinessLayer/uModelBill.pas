unit uModelBill;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelBillIntf;

type
  TModelBillOrder = class(TModelBill, IModelBillOrder) //µ¥¾Ý-¶©µ¥
  end;

implementation

initialization
  gClassIntfManage.addClass(TModelBillOrder, IModelBillOrder);

end.
