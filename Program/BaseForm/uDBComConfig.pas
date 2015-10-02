{***************************
����ؼ���洢���̲����ֶ�����
Ϊ�˼��ٶԽ���ؼ���ֵ�Ļ�ȡ�͸�ֵ
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
  //��¼һ������ؼ��Ͷ�Ӧ��������Ϣ
  PDBComItem = ^TDBComItem;
  TDBComItem = record
    Component: TControl;                                    //�󶨵Ŀؼ�
    SetDBName: string;                                      //��ֵʱ���ֶ�
    GetDBName: string;                                      //ȡֵʱ���ֶ�
  end;

  TDBComArray = array of PDBComItem;

  //�����Ϳ���һ����������Ŀؼ���Ӧ�����ݿ����
  TFormDBComItem = class(TObject)
  private
    FDBComList: TDBComArray;

  protected

  public
    constructor Create;
    destructor Destroy; override;

    procedure GetDataFormParam(AParam: TParamObject);           //��TParamObject��ȡֵ
    procedure SetDataToParam(AParam: TParamObject);           //��ParamObject��ֵ
    
    function AddItem(AControl: TControl; ASetDBNane: string; AGetDBName: string): PDBComItem; overload;//ͨ�����еĿؼ�����һ��������
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
      raise (SysService as IExManagement).CreateSysEx('��δ֪���͵Ŀؼ�[' + aItem.Component.ClassName + '],������������ݷ�ʽ��');
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
      raise (SysService as IExManagement).CreateSysEx('��δ֪���͵Ŀؼ�[' + aItem.Component.ClassName + '],�����ø�ֵ��ʽ��');
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
      raise (SysService as IExManagement).CreateSysEx('��δ֪���͵Ŀؼ�[' + aItem.Component.ClassName+ '],������ȡֵ��ʽ��');
    end;
  end;
end;

initialization

finalization

end.
