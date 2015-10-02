{ ------------------------------------
  功能说明：专门定义系统使用的固定的常量，数据库操作无关的
  创建日期：2014/07/08
  作者：mx
  版权：mx
  ------------------------------------- }
unit uDefCom;

interface

const
  cnNoneName = '【未指定】';
  ROOT_ID = '00000'; //根节点
  ROOT_OTHER = '99999';
  OneDeepLength = 5; //单独一个节点长度
  cnMAXDEEP = 5; //层次深度

  //消息对话框定义
  mrSett = 101; //保存单据
  mrDraft = 102; //存入草稿
  mrClose = 103; //废弃退出

  //报表的现实方式
  ReportMode = 'BrMode';
  ReportMode_List = 'L';
  ReportMode_Node = 'N';
  ReportMode_Bill = 'V';

  {商品成本模式}
  COSTMODE_AVERAGE = 0; //移动加权平均
  COSTMODE_FIFO = 1; //先进先出法
  COSTMODE_AIFO = 2; //后进先出法
  COSTMODE_HAND = 3; //手工指定法
  
type
  //表格列字段类型
  //字符串，整数，正整数(允许0)，小数，正小数
  //数量，单价，金额，折扣，日期，时间，日期时间
  TColField = (cfString, cfInt, cfPlusInt, cfFloat, cfPlusFloat, cfCheck,
    cfQty, cfPrice, cfTotal, cfDiscount, cfDate, cfTime, cfDatime);

  //tc选择模式      //按钮、回车、双击
  TSelectMode = (smNo, smButton, smEnter, smDblClick);

  //时间编辑显示方式
  TEditDisType = (edtDate, edtTime, edtDatime);

  //操作数据变化             增加、   复制新增、 删除、  修改、   分类、    查看
  TDataChangeType = (dctNo, dctAdd, dctAddCopy, dctDel, dctModif, dctClass,
    dctDis, dctInsert, dctAddSub);
  
  //窗体显示方式
  TShowStyle = (fssShow, fssShowModal);

function GetDataChangeType(AMode: string): TDataChangeType;//数据操作数据变化转化

implementation

function GetDataChangeType(AMode: string): TDataChangeType;
begin
  Result := dctNo;
  if AMode = '1' then
    Result := dctAdd
  else if AMode = '2' then
    Result := dctAddCopy
  else if AMode = '4' then
    Result := dctModif
  else if AMode = '6' then
    Result := dctDis
  else if AMode = '5' then
    Result := dctClass;
end;

end.

