{***************************
������ʾ�ؼ���һЩ����
������ݵ�TcxTreeView��
mx 2014-11-28
****************************}
unit uFrmApp;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, cxContainer, cxTreeView, cxDropDownEdit, uOtherDefine;

type
  PNodeData = ^TNodeData;   //һ�����ڵ�����
  TNodeData = record
    Fullname: string;
    Typeid: string;
    Parid: string;
    Leveal: Integer;
  end;

procedure LoadBaseTVData(AMode: string; ATVClass: TcxTreeView); //�������ͼ������ڵ�
procedure FreeBaseTVData(ATVClass: TcxTreeView); //�ͷ����ڵ㱣��Ķ���
procedure LoadCbbList(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText); //���������б�����
function GetCbbListID(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText): string; //��ȡ�����б�ǰ��Ӧ��ֵ
procedure SetCbbListID(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText; AID: string); //���������б�ID��Ӧ��index

implementation

uses uSysSvc, uDefCom, uDBIntf, ComCtrls;

procedure LoadBaseTVData(AMode: string; ATVClass: TcxTreeView);
var
  aCdsTemp: TClientDataSet;
  aSQLStr: string;
  aNode: TTreeNode;
  aNodeData, aParNodeData: PNodeData;
begin
  if Trim(AMode) = EmptyStr then Exit;
  if AMode = 'tbx_Base_Ptype' then
  begin
    aSQLStr := 'SELECT PTypeId typeid, parid, leveal, PFullname fullname FROM tbx_Base_Ptype WHERE PTypeId = ' + ROOT_ID + ' OR PSonnum >0 ORDER BY leveal, PRec ';
  end
  else
  begin
    Exit;
  end;
  
  aCdsTemp := TClientDataSet.Create(nil);
  try
    (SysService as IDBAccess).QuerySQL(aSQLStr, aCdsTemp);

    ATVClass.Items.Clear;
    ATVClass.Items.BeginUpdate;
    aCdsTemp.First;
    while not aCdsTemp.Eof do
    begin
      New(aNodeData);
      aNodeData.Leveal := aCdsTemp.FieldByName('leveal').AsInteger;
      aNodeData.Fullname := aCdsTemp.FieldByName('fullname').AsString;
      aNodeData.Typeid := aCdsTemp.FieldByName('typeid').AsString;
      aNodeData.Parid := aCdsTemp.FieldByName('parid').AsString;

      aNode := ATVClass.Items.GetFirstNode;
      while Assigned(aNode) do
      begin
        aParNodeData := aNode.Data;
        if Assigned(aParNodeData) then
        begin
          if aParNodeData.Typeid = aNodeData.Parid then
          begin
            ATVClass.Items.AddChildObject(aNode, aNodeData.Fullname, aNodeData);
            Break;
          end;
        end;
        aNode := aNode.GetNext;
      end;
      if not Assigned(aNode) then   //�Ҳ��������ʱ������Ǹ��ڵ�
      begin
        ATVClass.Items.AddChildObject(nil, aNodeData.Fullname, aNodeData);
      end;

      aCdsTemp.Next;
    end;
  finally
    ATVClass.Items.EndUpdate;
    aCdsTemp.Free;
  end;
end;

procedure FreeBaseTVData(ATVClass: TcxTreeView);
var
  aNode: TTreeNode;
  aNodeData: PNodeData;
begin
  aNode := ATVClass.Items.GetFirstNode;
  while Assigned(aNode) do
  begin
    aNodeData := aNode.Data;
    if Assigned(aNodeData) then
    begin
      Dispose(aNodeData);
    end;
    aNode := aNode.GetNext;
  end;
end;

procedure LoadCbbList(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText);
var
  i: Integer;
begin
  ACbbClass.Clear;
  try
    ACbbClass.Properties.BeginUpdate;
    for i := 0 to AIDDT.Count - 1 do
    begin
      ACbbClass.Properties.Items.Add(AIDDT.ValueFromIndex[i]);
    end;
    if ACbbClass.Properties.Items.Count > 0 then
    begin
      ACbbClass.ItemIndex := 0;
    end;
  finally
    ACbbClass.Properties.EndUpdate;
  end;
end;

procedure SetCbbListID(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText; AID: string);
var
  i, aIndex: Integer;
  aDisplayText: string;
begin
  try
    for i := 0 to AIDDT.Count - 1 do
    begin
      if AID = AIDDT.Names[i] then
      begin
        aDisplayText := AIDDT.ValueFromIndex[i];
        aIndex := ACbbClass.Properties.Items.IndexOf(aDisplayText);
        ACbbClass.ItemIndex := aIndex;
        Break;
      end;
    end;
  finally

  end;
end;

function GetCbbListID(ACbbClass: TcxComboBox; AIDDT: TIDDisplayText): string;
var
  i: Integer;
begin
  Result := '';
  try
    for i := 0 to AIDDT.Count - 1 do
    begin
      if ACbbClass.Text = AIDDT.ValueFromIndex[i] then
      begin
        Result := AIDDT.Names[i];
        Break;
      end;
    end;
  finally

  end;
end;

end.

