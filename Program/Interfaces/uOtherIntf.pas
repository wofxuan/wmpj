{***************************
��������
�쳣������Ϣ��ʾ,��ҵ������ݿⲻ��صĲ���
mx 2014-12-28
****************************}
unit uOtherIntf;

interface

uses SysUtils, uDefCom;

type
  //��Ϣ�Ի�����
  //��Ϣ����        ����        ����          ��Ϣ           ѯ��                 �Զ���
  TMessageBoxType = (mbtWarning, mbtError, mbtInformation, mbtConfirmation, mbtCustom);
  //��Ϣ��ť          ���浥��   ����ݸ�   �����˳�   ��     ��      ȷ��   ȡ��
  TMessageBoxButton = (mbbSett, mbbDraft, mbbClose, mbbYes, mbbNo, mbbOK, mbbCancel);

  TMessageBoxButtons = set of TMessageBoxButton;

  //��־����  ϵͳ������־  ����������־
  TLogType = (ltErrSys, ltErrFun);

  //�쳣����ӿ�
  IExManagement = interface
    ['{4F3E33B1-D8C5-4BF2-B521-A3CE2DB3FB8B}']
    function CreateSysEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception; //����ϵͳ���쳣,һ���ǿ�ܵ��쳣
    function CreateFunEx(const AshowMsg: string; const AWriteMsg: string = ''): Exception; //�����������쳣��ҵ�������쳣
  end;

  //�����򴰿�
  IMsgBox = interface
    ['{95EA0C64-62DD-4ED9-84DC-5257592CE598}']
    function MsgBox(AMsg: string; ACaption: string = ''; AMsgType: TMessageBoxType = mbtInformation;
      AButtons: TMessageBoxButtons = [mbbOk]): Integer; //��ʾ��
    function InputBox(const ACaption, APrompt: string; var ADefautValue: string; AMaxLen:
      Integer = 0; ADataType: TColField = cfString): Integer;//�����
  end;

  //ϵͳ��־�ӿ�
  ILog = interface
    ['{B92B1E3F-11B1-4C39-A532-4A1C6285DBE3}']
    procedure WriteLogDB(ALogType: TLogType; const AStr: string); //������־�����ݿ���
    procedure WriteLogTxt(ALogType: TLogType; const AErr: string); //���浽���ص��ı��ļ���
  end;

const
  mbbYesNoCancel = [mbbYes, mbbNo, mbbCancel]; //��   ��   ȡ��
  mbbOkCancel = [mbbOk, mbbCancel]; //ȷ�� ȡ��
  mbbSettDraftClose = [mbbSett, mbbDraft, mbbClose]; //���浥��  ����ݸ�  �����˳�
  mbbSettClose = [mbbSett, mbbClose]; //���浥��  �����˳�
  mbbSettCloseCancel = [mbbSett, mbbClose, mbbCancel]; //���浥��  �����˳�  ȡ��

implementation

end.

