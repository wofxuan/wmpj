unit uOther;

interface

uses SysUtils, Dialogs, Controls, Forms, uSvcInfoIntf, uDefCom, uOtherIntf;

const
  LogDir = 'Log';//������־��Ŀ¼
  
type
  TExManagement = class(TInterfacedObject, ISvcInfo, IExManagement)
  private

  protected
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  {IExManagement}
    function CreateSysEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception; //����ϵͳ���쳣
    function CreateFunEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception; //�����������쳣
  public

  end;

  TMsgBox = class(TInterfacedObject, ISvcInfo, IMsgBox)
  private

  protected
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  {IMsgBox}
    function MsgBox(AMsg: string; ACaption: string = ''; AMsgType: TMessageBoxType = mbtInformation;
      AButtons: TMessageBoxButtons = [mbbOk]): Integer;
    function InputBox(const ACaption, APrompt: string; var ADefautValue: string; AMaxLen:
      Integer = 0; ADataType: TColField = cfString): Integer;
  public

  end;

type
  TLogObj = class(TInterfacedObject, ISvcInfo, ILog)
  private

  protected
    {ILog}
    procedure WriteLogDB(ALogType: TLogType; const AStr: string);
    procedure WriteLogTxt(ALogType: TLogType; const AErr: string); 
    {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  public
    constructor Create;
  end;

implementation

uses uSysSvc, uSysFactory, uExDef, uPubFun, uFrmMsgBox, uFrmInputBox;

{ TExManagement }

function TExManagement.CreateFunEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception;
begin
  if not StringEmpty(AWriteMsg) then
  begin
    (SysService as ILog).WriteLogTxt(ltErrFun, AWriteMsg);
  end;
  Result := EFunException.Create(AShowMsg);
end;

function TExManagement.CreateSysEx(const AShowMsg: string; const AWriteMsg: string = ''): Exception;
begin
  if not StringEmpty(AWriteMsg) then
  begin
    (SysService as ILog).WriteLogTxt(ltErrSys, AWriteMsg);
  end;
  Result := ESysException.Create(AShowMsg);
end;

function TExManagement.GetComments: string;
begin
  Result := '�����쳣����';
end;

function TExManagement.GetModuleName: string;
begin
  Result := '�쳣�����ӿ�(IExManagement)';
end;

function TExManagement.GetTitle: string;
begin
  Result := '�����쳣����';
end;

function TExManagement.GetVersion: string;
begin
  Result := '20141203.001';
end;

{ TMsgBox }

function TMsgBox.GetComments: string;
begin
  Result := '���ڶԻ������';
end;

function TMsgBox.GetModuleName: string;
begin
  Result := ExtractFileName(SysUtils.GetModuleName(HInstance));
end;

function TMsgBox.GetTitle: string;
begin
  Result := '���ڶԻ������';
end;

function TMsgBox.GetVersion: string;
begin
  Result := '20150829';
end;

function TMsgBox.InputBox(const ACaption, APrompt: string;
  var ADefautValue: string; AMaxLen: Integer;
  ADataType: TColField): Integer;
begin
  with TfrmInputBox.Create(nil) do
  try
    Captions := ACaption;
    Prompt := APrompt;
    InputValue := ADefautValue;
    MaxLen := AMaxLen;
    DataType := ADataType;
    Result := ShowModal;
    if Result = mrok then
    begin
      ADefautValue := Trim(edtInput.Text);
    end;
  finally
    Free
  end;
end;

function TMsgBox.MsgBox(AMsg, ACaption: string; AMsgType: TMessageBoxType;
  AButtons: TMessageBoxButtons): Integer;
var
  aFrm: TfrmMsgBox;
begin
  aFrm := TfrmMsgBox.Create(Application); //Ҫ��Application��Ȼ���ܳ���
  try
    aFrm.Captions := ACaption;
    aFrm.Messages := AMsg;
    aFrm.MsgType := AMsgType;
    aFrm.Buttons := AButtons;
    Result := aFrm.ShowModal;
  finally
    aFrm.Free
  end;
end;

{ TLogObj }

constructor TLogObj.Create;
var
  aLogDir: string;
begin
  inherited;
  aLogDir := ExtractFilePath(Paramstr(0)) + LogDir;
  if not DirectoryExists(aLogDir) then
  begin
    ForceDirectories(aLogDir);  
  end;
end;

function TLogObj.GetComments: string;
begin
  Result := '��װ��־��ز���';
end;

function TLogObj.GetModuleName: string;
begin
  Result := ExtractFileName(SysUtils.GetModuleName(HInstance));
end;

function TLogObj.GetTitle: string;
begin
  Result := '��װ��־��ز���';
end;

function TLogObj.GetVersion: string;
begin
  Result := '20150829';
end;

procedure TLogObj.WriteLogTxt(ALogType: TLogType; const AErr: string);
var
  aFileName, aErrMsg: string;
  aFileHandle: TextFile;
begin
  aFileName := ExtractFilePath(Paramstr(0)) + LogDir + '\' + FormatDateTime('YYYY-MM-DD', Now) + '.txt'; ;
  assignfile(aFileHandle, aFileName);
  try
    if FileExists(aFileName) then
      append(aFileHandle) //Reset(FileHandle)
    else ReWrite(aFileHandle);

    case ALogType of
      ltErrSys: aErrMsg := 'ϵͳ����';
      ltErrFun: aErrMsg := '��������';
    else
      aErrMsg := 'δ֪��������'
    end;
    aErrMsg := FormatDateTime('[HH:MM:SS]', now) + '  ' + aErrMsg + ':' + AErr;
    WriteLn(aFileHandle, aErrMsg);
  finally
    CloseFile(aFileHandle);
  end;
end;

procedure TLogObj.WriteLogDB(ALogType: TLogType; const AStr: string);
begin
  //�������Ҫд�����ݱ�����
  raise Exception.Create('δʵ�֡�����');
end;

procedure CreateExManagement(out anInstance: IInterface);
begin
  anInstance := TExManagement.Create;
end;

procedure CreateMsgBox(out anInstance: IInterface);
begin
  anInstance := TMsgBox.Create;
end;

procedure CreateLogObj(out anInstance: IInterface);
begin
  anInstance := TLogObj.Create;
end;

initialization
  TSingletonFactory.Create(IExManagement, @CreateExManagement);
  TIntfFactory.Create(IMsgBox, @CreateMsgBox);
  TSingletonFactory.Create(ILog, @CreateLogObj);

finalization

end.

