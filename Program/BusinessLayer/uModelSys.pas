unit uModelSys;

interface
uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelSysIntf;

type
  TModelTbxCfg = class(TModelBase, IModelTbxCfg)        //系统表格信息配置
  private
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;
  protected

  public
  
  end;
implementation

uses uModelFunCom, uOtherIntf;

{ TModelTbxCfg }

function TModelTbxCfg.CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;
var
  aList: TParamObject;
  aSQL, aErrorMsg: string;
  aRet: Integer;
begin
  inherited;
  Result := False;
  aList := TParamObject.Create;
  try
    aList.Add('@OperatorID', gMFCom.OperatorID);
    if ACheckType = tctInsert then
      aList.Add('@CheckType', 'Insert')
    else if ACheckType = tctDel then
      aList.Add('@CheckType', 'Del');
    aRet := gMFCom.ExecProcByName('pbx_Sys_CheckTbxCfg', aList);
    if aRet <> 0 then
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Exit;
    end;
    Result := True;
  finally
    aList.Free;
  end;
end;

procedure TModelTbxCfg.LoadGridData(AType: string; ACdsBaseList: TClientDataSet);
var
  aList: TParamObject;
  aSQL: string;
begin
  inherited;
  aList := TParamObject.Create;
  try
//    aList.Add('@cMode', GetBaseTypeKeyStr(BasicType));
//    aList.Add('@szTypeid', ATypeid);
//    aList.Add('@OperatorID', gMFCom.OperatorID);
    if AType = 'L' then
    begin
      aSQL := 'SELECT tbxId, tbxName, tbxType, tbxComment FROM tbx_Sys_TbxCfg order by TbxRowIndex';
    end
    else if AType = 'U' then
    begin
      aSQL := 'SELECT so.name tbxName FROM SysObjects so LEFT JOIN tbx_Sys_TbxCfg tst ON tst.TbxId = so.id WHERE XType = ''U'' AND ( tst.TbxId IS NULL )';
    end
    else if AType = 'D' then
    begin
      aSQL := 'SELECT tbxName FROM dbo.tbx_Sys_TbxCfg WHERE TbxId NOT IN (SELECT id FROM SysObjects WHERE XType = ''U'')';
    end;
    
    gMFCom.QuerySQL(aSQL, ACdsBaseList);
  finally
    aList.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelTbxCfg, IModelTbxCfg);
  
end.
