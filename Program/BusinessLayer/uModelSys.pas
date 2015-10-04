unit uModelSys;

interface
uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelSysIntf;

type
  TModelTbxCfg = class(TModelBase, IModelTbxCfg)        //系统表格信息配置
  private
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);
  protected

  public
  
  end;
implementation

uses uModelFunCom;

{ TModelTbxCfg }

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
    if AType = 'D' then
      aSQL := 'SELECT tbxId, tbxName, tbxType, tbxComment FROM tbx_Sys_TbxCfg order by TbxRowIndex'
    else if AType = 'U' then
      aSQL := 'SELECT id tbxId, name tbxName FROM SysObjects WHERE XType = ''U'' ORDER BY tbxId'
    else
      aSQL := 'SELECT tbxId, tbxName, tbxType, tbxComment FROM tbx_Sys_TbxCfg order by TbxRowIndex';

    gMFCom.QuerySQL(aSQL, ACdsBaseList);
  finally
    aList.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelTbxCfg, IModelTbxCfg);
  
end.
