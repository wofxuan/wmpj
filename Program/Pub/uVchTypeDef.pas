unit uVchTypeDef;

interface

uses
  Forms, SysUtils, Graphics, Windows, Classes, Controls, Variants;

const

  //单据定义
  VchType_Order_Buy = 1; //进货订单
  VchType_Order_Sale = 2; //销售订单

  VchType_Buy = 3; //进货单
  VchType_Sale = 4; //销售单


  //订单集合
  OrderVchtypes = [
    VchType_Order_Buy, //进货订单
    VchType_Order_Sale //销售订单
    ];

implementation

initialization

finalization


end.

