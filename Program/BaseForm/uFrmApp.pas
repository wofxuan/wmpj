{***************************
界面显示控件的一些操作
如绑定数据到TcxTreeView等
mx 2014-11-28
****************************}
unit uFrmApp;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, cxContainer, cxTreeView;

type
  PNodeData = ^TNodeData;   //一个树节点数据
  TNodeData = record
    Fullname: string;
    Typeid: string;
    Parid: string;
    Leveal: Integer;
  end;

procedure LoadBaseTVData(AMode: string; ATVClass: TcxTreeView); //根据类型加载树节点

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
          end;
        end;
        aNode := aNode.GetNext;
      end;
      if not Assigned(aNode) then   //找不到父类的时候，这个是根节点
      begin
        ATVClass.Items.AddChildObject(nil, aNodeData.Fullname, aNodeData);
      end;

      aCdsTemp.Next;
    end;
  finally
    aCdsTemp.Free;
  end;
end;

end.

