{***************************
窗体模块编号
在窗体中的表格也共享此编号，如果一个窗体有多个表格，这定义多个常量来对应
mx 2014-12-03
****************************}
unit uMoudleNoDef;

interface

const
  //模块常量定义
  //格式：fn+类名 = 基数 + 累加
  //只能累加，不能删除或修改

  //基本信息
  fnBase = 1000;
  //单据
  fnBill = 2000;
  //报表
  fnReport = 3000;
  //系统配置
  fnSystem = 4000;
  //查询窗口
  fnDlgcond = 5000;
  //TC选择类
  fnTc = 6000;
  //测试时使用的， 发布时删除
  fnTest = 7000;


  //基本信息-----------------------------1000------------------------
  fnMdlBasePtypeList = fnBase + 0001; //商品
  fnMdlBaseBtypeList = fnBase + 0002; //单位
  fnMdlBaseEtypeList = fnBase + 0003; //职员
  fnMdlBaseDtypeList = fnBase + 0004; //部门
  fnMdlBaseKtypeList = fnBase + 0005; //仓库

  //单据---------------------------------2000-----------------------
  fnMdlBillOrderBuy = fnBill + 0001; //进货订单
  fnMdlBillOrderSale = fnBill + 0002; //销售订单
  fnMdlBillBuy = fnBill + 0003; //进货单
  fnMdlBillSale = fnBill + 0004; //销售单

  //报表-----------------------------------3000---------------------
  fnMdlReportGoods = fnReport + 0001; //商品库存情况
  fnMdlReportOrderBuy = fnReport + 0002; //进货订单统计
  fnMdlReportBuy = fnReport + 0003; //进货单统计
  fnMdlReportOrderSale = fnReport + 0004; //销售订单统计
  fnMdlReportSale = fnReport + 0005; //销售单统计

  //系统设置-------------------------------4000---------------------
  fnMdlLoadItemSet = fnSystem + 0001; //加载包设置
  fnMdlBaseTbxCfg = fnSystem + 0002; //表格信息配置
  fnMdlBasicTypeCfg = fnSystem + 0003; //本地化信息列配置
  fnMdlHelp_Calc = fnSystem + 0004; //计算器
  fnMdlHelp_Online = fnSystem + 0005; //在线帮助

  //系统设置-------------------------------7000---------------------
  fnMdlTTest = fnTest + 0001; //测试

implementation

end.

