unit uVchTypeDef;

interface

uses
  Forms, SysUtils, Graphics, Windows, Classes, Controls, Variants;

const

  //���ݶ���
  VchType_Order_Buy = 1; //��������
  VchType_Order_Sale = 2; //���۶���

  VchType_Buy = 3; //������
  VchType_Sale = 4; //���۵�

  VchType_Allot = 5; //������

  //��������
  OrderVchtypes = [
    VchType_Order_Buy, //��������
    VchType_Order_Sale //���۶���
    ];

implementation

initialization

finalization


end.

