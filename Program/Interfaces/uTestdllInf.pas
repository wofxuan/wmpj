{***************************

mx 2014-12-28
****************************}
unit uTestdllInf;

interface

uses SysUtils;

type
  //异常处理接口
  ITestdll = interface
    ['{A02A782B-C7EB-485B-9F8B-CFA58F0514C0}']
    function TestAAA(AMsg: string): string;
end;

implementation

end.

