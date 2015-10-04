unit uFrmParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uFactoryFormIntf, uParamObject, ExtCtrls,
  ActnList, uBaseInfoDef, uGridConfig, uDBComConfig, uDefCom;

type
  TfrmParent = class(TForm, IFormIntf)
    actlstEvent: TActionList;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    FMoudleNo: Integer;                                     //模块的编号和uMoudleNoDef单元的常量对应
    FParamList: TParamObject;                               //初始化是传入的参数
    FTitle: string;                                         //窗体工具栏显示的名称
    FDBComItem: TFormDBComItem;                             //配置界面控件和数据字段

  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    
    { IFormIntf }
    procedure CreateParamList(AOwner: TComponent; AParam: TParamObject);
    procedure FrmShow;
    function FrmShowModal: Integer;
    procedure FrmFree;
    procedure FrmClose;
    function FrmShowStyle: TShowStyle; virtual; abstract;//窗体显示的类型，是否modal

    procedure BeforeFormShow; virtual;
    procedure InitParamList; virtual;                       //产品可以在窗口创建之前先对参数进行处理；不要对界面的控件进行处理
    procedure BeforeFormDestroy; virtual;
    procedure SetTitle(const Value: string); virtual;
    procedure IniView; virtual;                             //初始化视图
    procedure IniData; virtual;
  public
    { Public declarations }
    constructor CreateFrmParamList(AOwner: TComponent; AParam: TParamObject); virtual; //带参数的创建
    property MoudleNo: Integer read FMoudleNo write FMoudleNo;
    property ParamList: TParamObject read FParamList write FParamList;
    class function GetMdlDisName: string; virtual;          //得到模块显示名称
    property Title: string read FTitle write SetTitle;      //代表了子类的lbltitle.caption
    property DBComItem: TFormDBComItem read FDBComItem write FDBComItem;
    
  end;

var
  frmParent: TfrmParent;

implementation

uses uSysSvc, uDBIntf, uMoudleNoDef;

{$R *.dfm}

{ TParentForm }

procedure TfrmParent.BeforeFormDestroy;
begin
  ParamList.Free;
end;

procedure TfrmParent.BeforeFormShow;
begin
  if Self.GetMdlDisName <> '' then
    Self.Title := Self.GetMdlDisName;

  IniView;
end;

procedure TfrmParent.CreateParamList(AOwner: TComponent;
  AParam: TParamObject);
begin
  CreateFrmParamList(AOwner, AParam);
end;

procedure TfrmParent.FormShow(Sender: TObject);
begin
  FDBComItem := TFormDBComItem.Create;
  BeforeFormShow();
end;

procedure TfrmParent.InitParamList;
begin

end;

procedure TfrmParent.FormDestroy(Sender: TObject);
begin
  BeforeFormDestroy();
  FDBComItem.Free;
end;

constructor TfrmParent.CreateFrmParamList(AOwner: TComponent;
  AParam: TParamObject);
begin
  ParamList := TParamObject.Create;
  if Assigned(AParam) then ParamList.Params := AParam.Params;
  InitParamList();
  inherited Create(AOwner);
  //赋窗体标题
  if Self.GetMdlDisName <> EmptyStr then
    Self.Caption := Self.GetMdlDisName;
end;

procedure TfrmParent.FrmShow;
begin
  Self.Show;
end;

procedure TfrmParent.FrmFree;
begin
  Self.Free;
end;

procedure TfrmParent.FrmClose;
begin
  Self.Close;
end;

function TfrmParent.FrmShowModal: Integer;
begin
  Result := Self.ShowModal;
end;

class function TfrmParent.GetMdlDisName: string;
begin
  Result := '';
end;

procedure TfrmParent.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TfrmParent.IniData;
begin

end;

procedure TfrmParent.IniView;
begin

end;

function TfrmParent._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmParent._Release: Integer;
begin
  Result := -1;
end;

function TfrmParent.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

initialization

end.

