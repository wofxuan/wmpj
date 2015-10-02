{***************************
其它操作
异常处理，信息提示,跟业务和数据库不相关的操作
mx 2014-12-28
****************************}
unit uOtherIntf;

interface

uses SysUtils, uDefCom;

type
  //消息对话框定义
  //消息类型        警告        错误          信息                            自定义
  TMessageBoxType = (mbtWarning, mbtError, mbtInformation, mbtConfirmation, mbtCustom);
  //消息按钮          保存单据   存入草稿   废弃退出   是     否      确定   取消
  TMessageBoxButton = (mbbSett, mbbDraft, mbbClose, mbbYes, mbbNo, mbbOK, mbbCancel);

  TMessageBoxButtons = set of TMessageBoxButton;

  //日志类型  系统错误日志  函数错误日志
  TLogType = (ltErrSys, ltErrFun);

  //异常处理接口
  IExManagement = interface
    ['{4F3E33B1-D8C5-4BF2-B521-A3CE2DB3FB8B}']
    function CreateSysEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception; //创建系统级异常,一般是框架的异常
    function CreateFunEx(const AshowMsg: string; const AWriteMsg: string = ''): Exception; //创建函数级异常，业务函数的异常
  end;

  //提示框窗口
  IMsgBox = interface
    ['{95EA0C64-62DD-4ED9-84DC-5257592CE598}']
    function MsgBox(AMsg: string; ACaption: string = ''; AMsgType: TMessageBoxType = mbtInformation;
      AButtons: TMessageBoxButtons = [mbbOk]): Integer;
  end;

  //系统日志接口
  ILog = interface
    ['{B92B1E3F-11B1-4C39-A532-4A1C6285DBE3}']
    procedure WriteLogDB(ALogType: TLogType; const AStr: string); //保存日志到数据库中
    procedure WriteLogTxt(ALogType: TLogType; const AErr: string); //保存到本地的文本文件中
  end;

const
  mbbYesNoCancel = [mbbYes, mbbNo, mbbCancel]; //是   否   取消
  mbbOkCancel = [mbbOk, mbbCancel]; //确定 取消
  mbbSettDraftClose = [mbbSett, mbbDraft, mbbClose]; //保存单据  存入草稿  废弃退出
  mbbSettClose = [mbbSett, mbbClose]; //保存单据  废弃退出
  mbbSettCloseCancel = [mbbSett, mbbClose, mbbCancel]; //保存单据  废弃退出  取消

implementation

end.

