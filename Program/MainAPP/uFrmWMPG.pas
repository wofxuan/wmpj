unit uFrmWMPG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMainFormIntf, uFactoryFormIntf, StdCtrls, uDBIntf, DB, DBClient, Menus, uSysMenu,
  ComCtrls, ExtCtrls, cxControls, cxPC, uParamObject, SyncObjs;

type
  TFrmWMPG = class(TForm, IMainForm)
    statList: TStatusBar;
    imgTop: TImage;
    tclFrmList: TcxTabControl;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tclFrmListCanClose(Sender: TObject; var ACanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tclFrmListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FMenuObject: TSysMenu;
    FClientInstance: TFarProc;
    FPrevClientProc: TFarProc;
    FCs: TCriticalSection;

    procedure ClientWndProc(var aMessage: TMessage);
    //IMainForm
    function CreateMenu(const Path: string; MenuClick: TNotifyEvent): TObject;
    procedure CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
    procedure CallFormClass(AFromNo: Integer; AParam: TParamObject); //�򿪴���

    procedure OnShowMDI(Sender: TObject; ACaption: string; AFormIntf: IFormIntf);

    procedure ActiveChild;
    procedure RemoveChild;
  public
    { Public declarations }
  end;

var
  FrmWMPG: TFrmWMPG;

implementation

uses uSysSvc, uFactoryIntf, uOtherIntf, uTestdllInf;

{$R *.dfm}

{ TFrmWMPG }

function TFrmWMPG.CreateMenu(const Path: string;
  MenuClick: TNotifyEvent): TObject;
begin

end;

procedure TFrmWMPG.CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
var
  aIndex: Integer;
  aMsgBox: IMsgBox;
begin
  for aIndex := 1 to tclFrmList.Tabs.Count - 1 do
  begin
    if TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI = AFormIntf then
    begin
//      TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI.FrmClose;
      TFrmObj(tclFrmList.Tabs.Objects[aIndex]).Free;
      tclFrmList.Tabs.Delete(aIndex);
      ACanClose := True;
      Break;
    end;
  end;
end;

procedure TFrmWMPG.FormCreate(Sender: TObject);
begin
  {���ز˵�}
  FMenuObject := TSysMenu.Create(Self, Self);
  FMenuObject.OnShowMDI := OnShowMDI;
  Self.Menu := FMenuObject.GetMainMenu;
  FCs := TCriticalSection.Create;

  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
  FClientInstance := MakeObjectInstance(ClientWndProc);
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
end;

procedure TFrmWMPG.FormShow(Sender: TObject);
var
  aRegInf: IRegInf;
begin
  aRegInf := SysService as IRegInf;
  aRegInf.RegObjFactory(IMainForm, Self);
end;

procedure TFrmWMPG.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  //����ֻ�ܷ���close���ͷţ���Destroy���ͷŻᱨ�ڴ����
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FPrevClientProc));
  for i := 1 to tclFrmList.Tabs.Count - 1 do
  begin
    TFrmObj(tclFrmList.Tabs.Objects[i]).FrmMDI.FrmFree;
    TFrmObj(tclFrmList.Tabs.Objects[i]).Free;
  end;
end;

procedure TFrmWMPG.FormDestroy(Sender: TObject);
begin
  FCs.Free;
  FMenuObject.Free;
end;

procedure TFrmWMPG.OnShowMDI(Sender: TObject; ACaption: string; AFormIntf: IFormIntf);
var
  aFrmObj: TFrmObj;
  aIndex: Integer;
begin
  aFrmObj := TFrmObj.Create(AFormIntf);
  aIndex := tclFrmList.Tabs.AddObject(ACaption, aFrmObj);
  tclFrmList.TabIndex := aIndex;
end;

procedure TFrmWMPG.tclFrmListCanClose(Sender: TObject;
  var ACanClose: Boolean);
var
  aIndex: Integer;
  aMsgBox: IMsgBox;
begin
  aIndex := tclFrmList.TabIndex;
  if aIndex > 0 then
  begin
    TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI.FrmClose;
    TFrmObj(tclFrmList.Tabs.Objects[aIndex]).Free;
    ACanClose := True;
  end
  else
  begin
    aMsgBox := SysService as IMsgBox;
    aMsgBox.MsgBox('����ͼҳ�治�ܹرգ�');
    ACanClose := False;
  end;
end;

procedure TFrmWMPG.tclFrmListChange(Sender: TObject);
var
  aIndex: Integer;
begin
  aIndex := tclFrmList.TabIndex;
  if aIndex > 0 then
  begin
//    Perform(WM_SETREDRAW, 0, 0); //����Ļ, ��ֹ���л�MDI�����ʱ����˸
//    try
    TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI.FrmShow;
//    finally
//      Perform(WM_SETREDRAW, 1, 0); //������Ļ���ػ�
//      RedrawWindow(Handle, nil, 0, RDW_FRAME + RDW_INVALIDATE + RDW_ALLCHILDREN + RDW_NOINTERNALPAINT);//�ػ�ͻ���
//    end;
  end;
end;

procedure TFrmWMPG.ClientWndProc(var aMessage: TMessage);
  procedure DoDefault;
  begin
    with aMessage do
      Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
  end;
begin
  with aMessage do
    case Msg of
      //��MDI�Ӵ�������ʱing...
      WM_MDIDESTROY:
        begin
          DoDefault;
          RemoveChild;
          ActiveChild();
        end;
      //��ͨ������˵��ϵ��Ӵ��ڲ˵������
      WM_MDIACTIVATE, WM_MDINEXT:
        begin
          DoDefault;
          ActiveChild();
        end;
      //���������MDI�Ӵ���ʱ����
      WM_MOUSEACTIVATE:
        begin
          DoDefault;
          ActiveChild();
        end;
      //�������Ӵ����ˢ�´��ڲ˵���ʱ����
      WM_MDIREFRESHMENU:
        begin
          DoDefault;
//          AddChild;
        end;
    else
      DoDefault;
    end;
end;

procedure TFrmWMPG.ActiveChild;
var
  aIndex: Integer;
  aIFormIntf: IFormIntf;
begin
  if not Assigned(ActiveMDIChild) then Exit;
  ActiveMDIChild.GetInterface(IFormIntf, aIFormIntf);
  for aIndex := 1 to tclFrmList.Tabs.Count - 1 do
  begin
    if TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI = aIFormIntf then
    begin
      tclFrmList.TabIndex := aIndex;
      Break;
    end;
  end;
end;

procedure TFrmWMPG.RemoveChild;
var
  aIndex: Integer;
  I: Integer;
  aFind, aUpdateDo: Boolean;
  aIFormIntf: IFormIntf;
begin
  aUpdateDo := True;
  while aUpdateDo do
  begin
    FCs.Enter;
    tclFrmList.Tabs.BeginUpdate;
    try
      if tclFrmList.Tabs.Count <= 1 then Exit;

      for aIndex := 1 to tclFrmList.Tabs.Count - 1 do
      begin
        aFind := True;
        for I := MDIChildCount - 1 downto 0 do
        begin
          if MDIChildren[I].Caption = EmptyStr then
          begin
            MDIChildren[I].GetInterface(IFormIntf, aIFormIntf);
            if TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI = aIFormIntf then
            begin
              aFind := False;
              Break;
            end;
          end;
        end;

        if not aFind then
        begin
          TFrmObj(tclFrmList.Tabs.Objects[aIndex]).Free;
          tclFrmList.Tabs.Delete(aIndex);
          Break;
        end;
      end;
      if (aIndex >= tclFrmList.Tabs.Count) then aUpdateDo := False;
    finally
      tclFrmList.Tabs.EndUpdate;
      FCs.Leave;
    end;
  end;
end;

procedure TFrmWMPG.CallFormClass(AFromNo: Integer; AParam: TParamObject);
begin
  FMenuObject.CallFormClass(AFromNo, AParam);
end;

end.

