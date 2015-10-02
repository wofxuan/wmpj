{------------------------------------
  功能说明：包导出的函数
  创建日期：2014/08/13
  作者：mx
  版权：mx
-------------------------------------}
unit uPackageExport;

interface

type
  TLoad = procedure(Intf: IInterface); //加载包后调用
  TInit = procedure; //初始化包(加载所有包后调用）
  TFinal = procedure; //程序退出前调用

  TInstallPackage = procedure; //安装包
  TUnInstallPackage = procedure; //卸载包

implementation

end.

