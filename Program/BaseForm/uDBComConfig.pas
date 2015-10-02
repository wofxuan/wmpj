{***************************
界面控件与存储过程参数字段配置
为了减少对界面控件的值的获取和赋值
mx 2015-04-28
****************************}
unit uDBComConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Controls, cxGrid, cxGridCustomView,cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uParamObject, cxButtons, ExtCtrls, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxDropDownEdit, ComCtrls, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, cxGridLevel, cxClasses, cxMemo;

type
  //记录一个界面控件和对应参数等信息
  PDBComItem = ^TDBComItem;
  TDBComItem = record
    Component: TControl;                                    //绑定的控件
    SetDBName: string;                                      //赋值时的字段
    GetDBName: string;                                      //取值时的字段
  end;

  TDBComArray = array of PDBComItem;

  //管理和控制一个界面里面的控件对应的数据库参数
  TFormDBComItem = class(TObject)
  private
    FDBComList: TDBComArray;

  protected

  public
    constructor Create;
    destructor Destroy; override;

    procedure GetDataFormParam(AParam: TParamObject);           //从TParamObject中取值
    procedure SetDataToParam(AParam: TParamObject);           //给ParamObject赋值
    
    function AddItem(AControl: TControl; ASetDBNane: string; AGetDBName: string): PDBComItem; overload;//通过已有的控件添加一个数据项
    function AddItem(AControl: TControl; ADBNane: string): PDBComItem; overload;
    procedure ClearItemData;
    property DBComList: TDBComArray read FDBComList;
  end;

implementation

uses uSysSvc, uOtherIntf, cxCheckBox, Graphics;


{ TFormDBComItem }

function TFormDBComItem.AddItem(AControl: TControl; ASetDBNane,
  AGetDBName: string): PDBComItem;
var
  aLen: Integer;
  aItem: PDBComItem;
begin
  aItem := New(PDBComItem);
  aItem.Component := AControl;
  aItem.SetDBName := ASetDBNane;
  aItem.GetDBName := AGetDBName;
  aLen := Length(FDBComList) + 1;
  SetLength(FDBComList, aLen);
  FDBComList[aLen - 1] := aItem;
end;

function TFormDBComItem.AddItem(AControl: TControl;
  ADBNane: string): PDBComItem;
begin
  AddItem(AControl, ADBNane, ADBNane);
end;

procedure TFormDBComItem.ClearItemData;
var
  i: Integer;
  aItem: PDBComItem;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      TcxButtonEdit(aItem.Component).Text := '';
    end
    else if aItem.Component is TcxComboBox then
    begin
      if TcxComboBox(aItem.Component).Properties.Items.Count > 0 then
        TcxComboBox(aItem.Component).ItemIndex := 0
      else
        TcxComboBox(aItem.Component).ItemIndex := -1;
    end
    else if aItem.Component is TcxCheckBox then
    begin
      TcxCheckBox(aItem.Component).Checked := False;
    end
    else if aItem.Component is TcxMemo then
    begin
      TcxMemo(aItem.Component).Text := '';
    end
    else 
    begin
      raise (SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + '],请设置清空数据方式！');
    end;
  end;
end;

constructor TFormDBComItem.Create;
begin
  SetLength(FDBComList, 0);
end;

destructor TFormDBComItem.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FDBComList) - 1 do
  begin
    Dispose(FDBComList[i]);
  end;
  SetLength(FDBComList, 0);
  inherited;
end;

procedure TFormDBComItem.GetDataFormParam(AParam: TParamObject);
var
  i: Integer;
  aItem: PDBComItem;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      TcxButtonEdit(aItem.Component).Text := AParam.AsString(aItem.GetDBName);
    end
    else if aItem.Component is TcxComboBox then
    begin
      TcxComboBox(aItem.Component).ItemIndex := AParam.AsInteger(aItem.GetDBName);
    end
    else if aItem.Component is TcxCheckBox then
    begin
      TcxCheckBox(aItem.Component).Checked := AParam.AsInteger(aItem.GetDBName) = 1;
    end
    else if aItem.Component is TcxMemo then
    begin
      TcxMemo(aItem.Component).Text := AParam.AsString(aItem.GetDBName);
    end
    else 
    begin
      raise (SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + '],请设置赋值方式！');
    end;
  end;
end;

procedure TFormDBComItem.SetDataToParam(AParam: TParamObject);
var
  i: Integer;
  aItem: PDBComItem;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      AParam.Add('@' + aItem.SetDBName, Trim(TcxButtonEdit(aItem.Component).Text));
    end
    else if aItem.Component is TcxComboBox then
    begin
      AParam.Add('@' + aItem.SetDBName, TcxComboBox(aItem.Component).ItemIndex);
    end
    else if aItem.Component is TcxCheckBox then
    begin
      if TcxCheckBox(aItem.Component).Checked then
        AParam.Add('@' + aItem.SetDBName, 1)
      else
        AParam.Add('@' + aItem.SetDBName, 0);
    end
    else if aItem.Component is TcxMemo then
    begin
      AParam.Add('@' + aItem.SetDBName, Trim(TcxButtonEdit(aItem.Component).Text));
    end
    else
    begin
      raise (SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName+ '],请设置取值方式！');
    end;
  end;
end;

initialization

finalization

end.

