{***************************
业务公共函数接口
获取本地化等公共函数
mx 2015-05-08
****************************}
unit uModelFunIntf;

interface

uses SysUtils, uParamObject, uBaseInfoDef, uDefCom;

type
 //TC选择后返回的
  TSelectBasicData = record
    TypeId: string;
    FullName: string;
    Usercode: string;
  end;

  TSelectBasicDatas = array of TSelectBasicData;

  //如要修改该枚举类型，只能在尾部添加，不能删除
  TSelectBasicOption = (opInsert, opModify, opDelete, opDisplayQty, opSelectClass,
    opAllSelect, opMultiSelect, opInsertVisible, opModifyVisible, opDeleteVisible,
    opSelectClassVisible, opAllSelectVisible, opSearch);

  TSelectBasicOptions = set of TSelectBasicOption;

  //调研TC的方式
  TSelectBasicMode = (sbtDblClick, sbtKeyDown, sbtBtnClick);
  //选择参数
  TSelectBasicParam = record
    SelectBasicMode: TSelectBasicMode;
    SearchType: Integer; //指快速查询等类型
    SearchString: string;
    DisplayStop: Integer; //是否显示停用
    Assistant0: string;
    Assistant1: string;
    Assistant2: string;
    Assistant3: string;
    Assistant4: string;
    Assistant5: string;
    Assistant6: string;
    Assistant7: string;
    Assistant8: string;
    Assistant9: string;
  end;

  TSelectBasicinfoEvent = procedure( Sender:TObject; ABasicType : TBasicType; ASelectParam : TSelectBasicParam;
  ASelectOptions : TSelectBasicOptions ; var AReturnArray  : TSelectBasicDatas; var AReturnCount : Integer) of object;
  
  //业务公共函数接口
  IModelFun = interface
    ['{C3B4809A-0778-4A97-85FE-96788D5563A0}']
    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string;
end;


implementation

end.

