{***************************
业务逻辑接口控制
注册和获取业务逻辑模型的接口
mx 2015-05-08
****************************}
unit uModelControlIntf;

interface

uses SysUtils, uDefCom;

type

  //业务控制接口                                
  IModelControl = interface
    ['{079684DF-C6E6-4B7A-82AC-5EC93A95262E}']
    procedure RegModelIntf(AModelIntf: IInterface);
    function GetModelIntf(AModelIntf: TGUID): IInterface;
end;


implementation

end.

