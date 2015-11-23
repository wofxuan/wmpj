{***************************
ҵ�񹫹������ӿ�
��ȡ���ػ��ȹ�������
mx 2015-05-08
****************************}
unit uModelFunIntf;

interface

uses SysUtils, uParamObject, uBaseInfoDef, uDefCom, uOtherIntf;

type
 //TCѡ��󷵻ص�
  TSelectBasicData = record
    TypeId: string;
    FullName: string;
    Usercode: string;
  end;

  TSelectBasicDatas = array of TSelectBasicData;

  //��Ҫ�޸ĸ�ö�����ͣ�ֻ����β����ӣ�����ɾ��
  TSelectBasicOption = (opInsert, opModify, opDelete, opDisplayQty, opSelectClass,
    opAllSelect, opMultiSelect, opInsertVisible, opModifyVisible, opDeleteVisible,
    opSelectClassVisible, opAllSelectVisible, opSearch);

  TSelectBasicOptions = set of TSelectBasicOption;

  //����TC�ķ�ʽ
  TSelectBasicMode = (sbtDblClick, sbtKeyDown, sbtBtnClick);
  //ѡ�����
  TSelectBasicParam = record
    SelectBasicMode: TSelectBasicMode;
    SearchType: Integer; //ָ���ٲ�ѯ������
    SearchString: string;
    DisplayStop: Integer; //�Ƿ���ʾͣ��
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
  
  //ҵ�񹫹������ӿ�
  IModelFun = interface
    ['{C3B4809A-0778-4A97-85FE-96788D5563A0}']
    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string;
    function ShowMsgBox(AMsg: string; ACaption: string = ''; AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;
end;


implementation

end.

