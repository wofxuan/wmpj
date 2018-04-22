unit uFrmWMPG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMainFormIntf, uFactoryFormIntf, StdCtrls, uDBIntf, DB, DBClient, Menus, uSysMenu,
  ComCtrls, ExtCtrls, cxControls, cxPC, uParamObject, SyncObjs, uFrmNav;

type
  TFrmWMPG = class(TForm, IMainForm)
    statList: TStatusBar;
    imgTop: TImage;
    tclFrmList: TcxTabControl;
    pnlMDIClient: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tclFrmListCanClose(Sender: TObject; var ACanClose: Boolean);
    procedure tclFrmListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pnlMDIClientResize(Sender: TObject);
  private
    { Private declarations }
    FMenuObject: TSysMenu;
    FFrmNav: TfrmNav;

    //IMainForm
    function CreateMenu(const Path: string; MenuClick: TNotifyEvent): TObject;
    procedure CloseFom(AFormIntf: IFormIntf; var ACanClose: Boolean);
    procedure CallFormClass(AFromNo: Integer; AParam: TParamObject); //打开窗体
    function GetMDIShowClient: TWinControl;
    procedure SetWindowState(AWindowState: TWindowState);

    procedure OnShowMDI(Sender: TObject; ACaption: string; AFormIntf: IFormIntf);
  public
    { Public declarations }
  end;

var
  FrmWMPG: TFrmWMPG;

implementation

uses uSysSvc, uFactoryIntf, uOtherIntf, uTestdllInf, uDefCom;

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
      tclFrmList.Tabs.BeginUpdate;
      try
        TFrmObj(tclFrmList.Tabs.Objects[aIndex]).Free;
        tclFrmList.Tabs.Objects[aIndex] := nil;
        tclFrmList.Tabs.Delete(aIndex);
        ACanClose := True;
      finally
        tclFrmList.Tabs.EndUpdate;
        tclFrmListChange(tclFrmList)
      end;
      Break;
    end;
  end;
end;

procedure TFrmWMPG.FormCreate(Sender: TObject);
var
  aRegInf: IRegInf;
begin
  {加载菜单}
  FMenuObject := TSysMenu.Create(Self, Self);
  FMenuObject.OnShowMDI := OnShowMDI;
  Self.Menu := FMenuObject.GetMainMenu;

  aRegInf := SysService as IRegInf;
  aRegInf.RegObjFactory(IMainForm, Self);
end;

procedure TFrmWMPG.FormShow(Sender: TObject);
begin
  FFrmNav := TfrmNav.Create(nil);
  FFrmNav.Parent := Self;
  FFrmNav.Show;
  pnlMDIClient.Visible := False;
  statList.Panels[0].Text := OperatorID;
//  OperatorID := '00000';
end;

procedure TFrmWMPG.FormDestroy(Sender: TObject);
begin
  FFrmNav.Free;
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
//    TFrmObj(tclFrmList.Tabs.Objects[aIndex]).Free;
    ACanClose := False;
  end
  else
  begin
    aMsgBox := SysService as IMsgBox;
    aMsgBox.MsgBox('导航图页面不能关闭！');
    ACanClose := False;
  end;
end;

procedure TFrmWMPG.tclFrmListChange(Sender: TObject);
var
  aIndex: Integer;
  aFrmObj: TFrmObj;
begin
  aIndex := tclFrmList.TabIndex;
  if aIndex > 0 then
  begin
    aFrmObj := TFrmObj(tclFrmList.Tabs.Objects[aIndex]);
    pnlMDIClient.Visible := True;
    FFrmNav.Visible := False;
//    Perform(WM_SETREDRAW, 0, 0); //锁屏幕, 防止在切换MDI窗体的时候闪烁
//    try
    aFrmObj.FrmMDI.FrmShow;
//    finally
//      Perform(WM_SETREDRAW, 1, 0); //解锁屏幕并重画
//      RedrawWindow(Handle, nil, 0, RDW_FRAME + RDW_INVALIDATE + RDW_ALLCHILDREN + RDW_NOINTERNALPAINT);//重绘客户区
//    end;
  end
  else
  begin
    pnlMDIClient.Visible := False;
    FFrmNav.Visible := True;
  end;
end;

procedure TFrmWMPG.CallFormClass(AFromNo: Integer; AParam: TParamObject);
begin
  FMenuObject.CallFormClass(AFromNo, AParam);
end;

function TFrmWMPG.GetMDIShowClient: TWinControl;
begin
  Result := pnlMDIClient;
end;

procedure TFrmWMPG.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
begin
  CanClose := False;
  while tclFrmList.Tabs.Count > 1 do
  begin
    TFrmObj(tclFrmList.Tabs.Objects[1]).FrmMDI.FrmClose();
  end;
  CanClose := True;
end;

procedure TFrmWMPG.SetWindowState(AWindowState: TWindowState);
begin
  WindowState := AWindowState;
end;

procedure TFrmWMPG.pnlMDIClientResize(Sender: TObject);
var
  aIndex: Integer;
  aMsgBox: IMsgBox;
begin
//  aIndex := tclFrmList.TabIndex;
  if Assigned(tclFrmList) then
  begin
    for aIndex := 1 to tclFrmList.Tabs.Count - 1 do
    begin
      TFrmObj(tclFrmList.Tabs.Objects[aIndex]).FrmMDI.ResizeFrm(pnlMDIClient);
    end;
  end;

  if Assigned(FFrmNav) then
  begin
    FFrmNav.Width := pnlMDIClient.Width;
    FFrmNav.Height := pnlMDIClient.Height;
  end;
end;
end.

