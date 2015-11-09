-----------------------清空数据
--DROP TABLE tbx_Base_PackageInfo
--GO
--DROP TABLE tbx_Sys_FrmParams
--GO 
--DROP TABLE tbx_Sys_DefSQL
--GO 
--DROP TABLE tbx_Sys_TbxCfg
--GO 
--DROP TABLE tbx_Base_Ptype
--GO 
--DROP TABLE tbx_Base_Btype
--GO 
--DROP TABLE tbx_Base_Dtype
--GO 
--DROP TABLE tbx_Base_Etype
--GO 
--DROP TABLE tbx_Base_Ktype
--GO 
--------------------------

--记录加载包的相关信息,基本类型对应btItype
IF OBJECT_ID('dbo.tbx_Base_PackageInfo') IS NULL 
    CREATE TABLE [dbo].[tbx_Base_PackageInfo]
        (
          [ITypeId] VARCHAR(50) ,
          [Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
          [ISonnum] INT NOT NULL DEFAULT 0 ,
          [Soncount] INT NOT NULL DEFAULT 0 , 
          [Leveal] INT NOT NULL DEFAULT 1 ,
          [IUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
          [IFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
          [IComment] VARCHAR(255) NOT NULL DEFAULT '' ,
          [INamepy] VARCHAR(66) NOT NULL DEFAULT '' ,
          [IRec] INT NOT NULL IDENTITY(1, 1),
          [Parrec] INT NOT NULL DEFAULT 0,
          [RowIndex] INT NOT NULL DEFAULT 0 ,
          [Deleted] BIT NOT NULL DEFAULT 0,
          [Updatetag] INT NOT NULL DEFAULT 0,  
          --以上是基本信息必须的字段，下面是自定义的字段
          [ISystem] INT NOT NULL DEFAULT 0 
          CONSTRAINT PK_tbx_Base_PackageInfo PRIMARY KEY (ITypeId)
        )
    
GO

--商品信息
IF OBJECT_ID('dbo.tbx_Base_Ptype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Ptype
	(
		[PTypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[PSonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[PUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[PFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[PComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[PNamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[PRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[Name] VARCHAR(66) NOT NULL DEFAULT (''),		--简称
		[Standard] VARCHAR(120) NOT NULL DEFAULT (''),--型号
		[Model] VARCHAR(60) NOT NULL DEFAULT (''),--规格
		[Area] VARCHAR(30) NOT NULL DEFAULT (''),--产地
		[UsefulLifeday] INT NOT NULL DEFAULT (0), --有效期
		[Costmode] INT NOT NULL DEFAULT (0),--成本方式
		[IsStop] INT NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Ptype PRIMARY KEY ([PTypeId])
	)
	INSERT dbo.tbx_Base_Ptype( PTypeId ,Parid ,Leveal ,PUsercode ,PFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部商品')
END
GO 
	
--单位信息
IF OBJECT_ID('dbo.tbx_Base_Btype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Btype
	(
		[BTypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[BSonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[BUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[BFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[BComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[BNamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[BRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[Name] VARCHAR(66) NOT NULL DEFAULT (''),		--简称
		[Address] VARCHAR(1000) NOT NULL DEFAULT (''),	
		[Tel] VARCHAR(66) NOT NULL DEFAULT (''),
		[EMail] VARCHAR(100) NOT NULL DEFAULT (''),
		[Contact1] VARCHAR(120) NOT NULL DEFAULT (''),--联系人一
		[Contact2] VARCHAR(120) NOT NULL DEFAULT (''),--联系人二
		[LinkerTel1] VARCHAR(60) NOT NULL DEFAULT (''),--联系电话一
		[LinkerTel2] VARCHAR(60) NOT NULL DEFAULT (''),--联系电话二
		[DefEtype] VARCHAR(50) NOT NULL DEFAULT (''),--默认经手人
		[BankOfDeposit] VARCHAR(50) NOT NULL DEFAULT (''),--开户银行
		[BankAccounts] VARCHAR(50) NOT NULL DEFAULT (''),--银行账号
		[PostCode] VARCHAR(50) NOT NULL DEFAULT (''),--邮政编码
		[Fax] VARCHAR(50) NOT NULL DEFAULT (''),--传真
		[TaxNumber] VARCHAR(50) NOT NULL DEFAULT (''),--税号
		[Rtypeid] VARCHAR(50) NOT NULL DEFAULT (''),--地区
		[IsStop] INT NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Btype PRIMARY KEY ([BTypeId])
	)
	INSERT dbo.tbx_Base_Btype( BTypeId ,Parid ,Leveal ,BUsercode ,BFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部单位')
END
GO 

--职员信息
IF OBJECT_ID('dbo.tbx_Base_Etype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Etype
	(
		[ETypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[ESonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[EUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[EFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[EComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[ENamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[ERec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[DTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,--所属部门
		[Tel] VARCHAR(20) NOT NULL DEFAULT '' ,--电话
		[Address] VARCHAR(80) NOT NULL DEFAULT '' ,--地址
		[Birthday] VARCHAR(10) NOT NULL DEFAULT '1980-01-01' ,--生日
		[EMail] VARCHAR (100) NOT NULL DEFAULT (''),--EMail
		[Job] VARCHAR(100) NOT NULL DEFAULT (''),--职位
		[TopTotal] NUMERIC (22, 10) NOT NULL DEFAULT (0),--每单优惠限额
		[LowLimitDiscount] NUMERIC (22, 10) NOT NULL DEFAULT (0),--最低折扣下限
		
		[IsStop] INT NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Etype PRIMARY KEY ([ETypeId])
	)
	INSERT dbo.tbx_Base_Etype( ETypeId ,Parid ,Leveal ,EUsercode ,EFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部职员')
END
GO 

--仓库信息
IF OBJECT_ID('dbo.tbx_Base_Ktype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Ktype
	(
		[KTypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[KSonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[KUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[KFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[KComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[KNamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[KRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[Name] VARCHAR (66) NOT NULL DEFAULT (''),--简称
		[Address] VARCHAR (256) NOT NULL DEFAULT (''),--地址
		[Person] VARCHAR (100) NOT NULL DEFAULT (''),--负责人
		[Tel] VARCHAR (50) NOT NULL DEFAULT (''),--负责人电话
		[IsStop] int  NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Ktype PRIMARY KEY ([KTypeId])
	)
	INSERT dbo.tbx_Base_Ktype( KTypeId ,Parid ,Leveal ,KUsercode ,KFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部仓库')
END
GO 

--部门信息
IF OBJECT_ID('dbo.tbx_Base_Dtype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Dtype
	(
		[DTypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[DSonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[DUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[DFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[DComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[DNamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[DRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[IsStop] int  NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Dtype PRIMARY KEY ([DTypeId])
	)
	INSERT dbo.tbx_Base_Dtype( DTypeId ,Parid ,Leveal ,DUsercode ,DFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部部门')
END
GO 

--系统-所有用户表格定义的相关信息
IF OBJECT_ID('dbo.tbx_Sys_TbxCfg') IS NULL 
    CREATE TABLE [dbo].[tbx_Sys_TbxCfg]
        (
          [TbxId] INT NOT NULL , --表格在SysObjects表的系统ID
          [TbxName] VARCHAR(50) NOT NULL DEFAULT '' ,
          [TbxDefName] VARCHAR(50) NOT NULL DEFAULT '' ,--别名
          [TbxType] INT NOT NULL DEFAULT -1 , --表格类型：-1未定义；0基本信息；1单据；2其它
          [TbxRowIndex] INT NOT NULL DEFAULT 0 ,--排列顺序
          [TbxComment] VARCHAR(200) NOT NULL DEFAULT '' , 
          CONSTRAINT PK_tbx_Sys_TbxCfg PRIMARY KEY ( TbxId )
        )
        
GO

--系统-数量，单价，金额，折扣，税率，关系和比率(%)的小数位数配置
IF OBJECT_ID('dbo.tbx_Sys_DitDef') IS NULL 
	CREATE TABLE [dbo].[tbx_Sys_DitDef]
	(
		[DitId] INT NOT NULL IDENTITY(1, 1),
		[DitDefName] VARCHAR (100) NOT NULL  DEFAULT (''),
		[DitDefValue] VARCHAR (100) NOT NULL  DEFAULT (''),
		[DitDefComment] VARCHAR (100) NOT NULL  DEFAULT ('')
		) ON [PRIMARY]
	GO


--单据-进货或者销售订单主表
IF OBJECT_ID('dbo.tbx_Bill_Order_M') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_Order_M]
        (
          [VchCode] INT NOT NULL IDENTITY(1, 1), --单据Id
          [InputDate] VARCHAR(10) DEFAULT '' ,--录得日期
          [Number] VARCHAR(40) DEFAULT '' ,--单据编号
          [VchType] INT NOT NULL DEFAULT (0) ,--单据类型
		  [Summary] VARCHAR(256) NOT NULL  DEFAULT (''),--摘要，可以自动生成
		  [Comment] VARCHAR(256) NOT NULL  DEFAULT (''),--附加说明
		  [BtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--供货或收货单位
		  [EtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--经手人
		  [DtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--部门
		  [KtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--发货或者收货仓库
		  [KtypeId2] VARCHAR(50) NOT NULL DEFAULT (''),--发货或者收货仓库,调拨单等时候
		  [Period] SMALLINT NOT NULL DEFAULT (1),--对应的月度期间1-12之间
		  [YearPeriod] INT NOT NULL DEFAULT (1),--对应的年度期间一直递增
		  [RedWord] CHAR(1) NOT NULL DEFAULT ('F'),--是否是红冲生成的单据 F不是,T是
		  [Redold] CHAR(1) NOT NULL DEFAULT ('F'),--是否被红冲 F没有,T有
		  [InputNo] VARCHAR(50) NOT NULL DEFAULT (''),--制单人
		  [InputNO1] VARCHAR(50) NOT NULL DEFAULT (''),--多级审核的时候记录审核人
		  [InputNO2] VARCHAR(50) NOT NULL DEFAULT (''),
		  [InputNO3] VARCHAR(50) NOT NULL DEFAULT (''),
		  [InputNO4] VARCHAR(50) NOT NULL DEFAULT (''),
		  [InputNO5] VARCHAR(50) NOT NULL DEFAULT (''),
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),--单据所有明细总金额
		  [Defdiscount] NUMERIC(22, 10) NOT NULL DEFAULT (0),--整单折扣
		  [Savedate] DATETIME NULL DEFAULT (GETDATE()),--存盘时间
		  [AuditState] INT NOT NULL DEFAULT ((-1)),--审核状态 -1:普通单据; 0:待审核; 1:审核中; 2:审核完成
		  --以上是单据类型表必须定义的字段
		  
		  [OrderOver] INT NOT NULL DEFAULT (0),--是否完成 0否，1是
		  [UserOver] INT NOT NULL DEFAULT (0), --0 未被调用， 其它:已经单元或者完成
		  [GatheringDate] VARCHAR(10) NOT NULL DEFAULT (''),--交货日期
          CONSTRAINT PK_tbx_Bill_Order_M PRIMARY KEY ( [VchCode] )
        )
        
GO

--单据-进货或者销售订单从表
IF OBJECT_ID('dbo.tbx_Bill_Order_D') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_Order_D]
        (  
		  [VchCode] INT NOT NULL DEFAULT (0), --主表单据Id
          [VchType] INT NOT NULL DEFAULT (0) ,--单据类型
          [DlyOrder] INT NOT NULL IDENTITY(1, 1),--数据库中行序号,可以用来关联行的其它相关信息
          [ColRowNo] INT NOT NULL DEFAULT (0),--界面显示的行顺序
          [AtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--会计科目
		  [BtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--供货或收货单位
		  [EtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--经手人
		  [DtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--部门
		  [KtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--发货或者收货仓库
		  [KtypeId2] VARCHAR(50) NOT NULL DEFAULT (''),--发货或者收货仓库,调拨单等时候
		  [PtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--商品
		  
		  [Costmode] INT NOT NULL DEFAULT (0),--商品成本算法
		  [Unit] INT NOT NULL DEFAULT (1),--多单位的时候对应的单位
		  [UnitRate] NUMERIC(22, 10) NOT NULL DEFAULT (0),--此单位跟基本单位的换算关系
		  
		  [BlockNo] VARCHAR(20) NOT NULL DEFAULT (''),--批号
		  [ProDate] VARCHAR(10) NOT NULL DEFAULT (''),--生产日期
		  [UsefulEndDate] VARCHAR(10) NOT NULL DEFAULT (''),--有效期至
		  [JhDate] VARCHAR(50) NOT NULL DEFAULT (''),--交货日期
			
		  [GoodsNo] INT NOT NULL DEFAULT (0),--当时出库类单据选择手工指定发的时候，记录对应选择的库存表的GoodsOrder

		  [Qty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--数量,记录基本数量
		  [Price] NUMERIC(22, 10) NOT NULL DEFAULT (0),--价格,记录基本数量对应的价格
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),--金额
		  
		  [DisCount] NUMERIC(22, 10) NOT NULL DEFAULT (1),--折扣
		  [DisCountPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--折后单价
		  [DisCountTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--折后金额
		  
		  [TaxRate] NUMERIC(22, 10) NOT NULL DEFAULT (0),--税率
		  [TaxPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--含税单价
		  [TaxTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--含税金额

		  [AssQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--数量,多单位等时显示换算后的数量
		  [AssPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--价格,多单位等是显示换算后的价格
		  [AssDiscountPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--折后单价，多单位等是显示换算后的价格
		  [AssTaxPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--含税单价，多单位等是显示换算后的价格

		  [CostPrice] NUMERIC (22, 10) NOT NULL DEFAULT (0),--成本单价
		  [CostTotal] NUMERIC (22, 10) NOT NULL DEFAULT (0),--成本金额
		
		  [OrderVchType] INT NOT NULL DEFAULT (0),--调用的其它单据的类型(调用询价单或者销售订单等)
		  [OrderCode] INT NOT NULL DEFAULT (0),--调用的其它单据的主表ID
		  [OrderDlyCode] INT NOT NULL DEFAULT (0),--调用的其它单据的从表ID
		  
		  [PStutas] INT NOT NULL DEFAULT (0),--是否是赠品；0不是；1是
		  [ToQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--到货数量
		  [Redword] CHAR(2) NOT NULL DEFAULT ('F'),--是否是红冲生成的单据 F不是,T是
		  [InputDate] VARCHAR(10)NOT NULL DEFAULT (''),--主表的录单日期
		  [Period] SMALLINT NOT NULL DEFAULT (1),--对应的月度期间1-12之间
		  [YearPeriod] INT NOT NULL DEFAULT (1),--对应的年度期间一直递增
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 2是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_Order_D PRIMARY KEY ( [VchCode] )
        )
        
GO

--记录MoudleNo对应的窗体和默认参数
IF OBJECT_ID('dbo.tbx_Sys_FrmParams') IS NULL 
    CREATE TABLE [dbo].[tbx_Sys_FrmParams]
        (
          [FMPID] INT IDENTITY(1, 1) ,
          [MoudleNo] INT NOT NULL DEFAULT 0 ,
          [FMPKey] VARCHAR(50) NOT NULL DEFAULT '' ,
          [DefaultCaption] VARCHAR(50) NOT NULL ,
          [ShowCaption] VARCHAR(50) NOT NULL ,
          [ClassName] VARCHAR(50) NOT NULL ,
          [ParamList] VARCHAR(200) NOT NULL DEFAULT '' ,
          [DefaultParams] VARCHAR(200) NOT NULL DEFAULT '' 
          CONSTRAINT PK_tbx_Sys_FrmParams PRIMARY KEY ( FMPID )
        )
        
GO

--记录定义的SQL语句
IF OBJECT_ID('dbo.tbx_Sys_DefSQL') IS NULL 
    CREATE TABLE [dbo].[tbx_Sys_DefSQL]
        (
          [DSLID] INT IDENTITY(1, 1) ,
          [SQLNo] INT NOT NULL DEFAULT 0 ,
          [DSLKey] VARCHAR(50) NOT NULL DEFAULT '' ,
          [SQLStr] VARCHAR(5000) NOT NULL DEFAULT '' ,
          [DSLRemark] VARCHAR(200) NOT NULL DEFAULT '' , 
          [DSLCreateTime] DATETIME NOT NULL DEFAULT 0 ,
          [DSLUpdateTime] DATETIME NOT NULL DEFAULT 0 
          CONSTRAINT PK_tbx_Sys_DefSQL PRIMARY KEY ( DSLID )
        )
        
GO

TRUNCATE TABLE  dbo.tbx_Base_PackageInfo
GO 
---初始化加载项
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00000' ,'' ,7 ,7 ,0 ,'全部加载项' ,'全部加载项' ,'全部加载项' ,'全部加载项' ,1, 0)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00001' ,'00000' ,0 ,0 ,1 ,'Other.bpl' ,'Other.bpl' ,'Other.bpl' ,'其它操作' ,1, 0)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00002' ,'00000' ,0 ,0 ,1 ,'BusinessIntf.bpl' ,'BusinessIntf.bpl' ,'BusinessIntf.bpl' ,'业务接口' ,1, 1)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00003' ,'00000' ,0 ,0 ,1 ,'BusinessLayer.bpl' ,'BusinessLayer.bpl' ,'BusinessLayer.bpl' ,'业务层' ,1, 2)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00004' ,'00000' ,0 ,0 ,1 ,'BaseForm.bpl' ,'BaseForm.bpl' ,'BaseForm.bpl' ,'父类窗体' ,1, 3)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00005' ,'00000' ,0 ,0 ,1 ,'SysConfig.bpl' ,'SysConfig.bpl' ,'SysConfig.bpl' ,'系统设置' ,1, 4)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00006' ,'00000' ,0 ,0 ,1 ,'BaseInfo.bpl' ,'BaseInfo.bpl' ,'BaseInfo.bpl' ,'基本信息' ,1, 5)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00007' ,'00000' ,0 ,0 ,1 ,'BillForm.bpl' ,'BillForm.bpl' ,'BillForm.bpl' ,'单据' ,1, 6)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00008' ,'00000' ,0 ,0 ,1 ,'TestBpl.bpl' ,'TestBpl.bpl' ,'TestBpl.bpl' ,'测试BPL' ,0, 7)
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00009' ,'00000' ,0 ,0 ,1 ,'Testdll.dll' ,'Testdll.dll' ,'Testdll.dll' ,'测试DLL' ,0, 8)
GO 

TRUNCATE TABLE  dbo.tbx_Sys_FrmParams
GO 
--初始化窗体和对应的模块编号参数, MoudleNo要与uMoudleNoDef的对应
INSERT INTO dbo.tbx_Sys_FrmParams ( MoudleNo ,FMPKey ,DefaultCaption ,ShowCaption ,ClassName ,ParamList , DefaultParams )
VALUES  (101, '{1382E20F-642F-4662-A863-7F90F6E04CC7}' , '系统加载模块' , '系统加载模块' , 'TfrmLoadItemSet' , '' , '' )
GO

TRUNCATE TABLE  tbx_Sys_DefSQL
GO
--初始化定义的SQL语句
INSERT INTO dbo.tbx_Sys_DefSQL ( SQLNo ,DSLKey ,SQLStr ,DSLRemark ,DSLCreateTime ,DSLUpdateTime)
VALUES  (4001 ,'{DF1C4EA1-D1F2-4150-99CB-317DF61FB17E}' ,'select * from tbx_Base_PackageInfo' ,'查询要加载的包' , GETDATE() ,GETDATE())
GO
INSERT INTO dbo.tbx_Sys_DefSQL ( SQLNo ,DSLKey ,SQLStr ,DSLRemark ,DSLCreateTime ,DSLUpdateTime)
VALUES  (1001 ,'{968FCBAC-74E3-43BA-80D3-21248ED828E1}' ,'select * from tbx_Base_Ptype where' ,'商品信息' , GETDATE() ,GETDATE())
GO


TRUNCATE TABLE dbo.tbx_Sys_DitDef
--数量等的小数位数
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitQty' , '4' ,'数量位数')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitPrice' , '8' ,'单价位数')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitTotal' , '2' ,'金额位数')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitDisCount' , '4' ,'折扣位数')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitTax' , '0' ,'税率位数')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitUnitRate' , '6' ,'关系')
INSERT INTO dbo.tbx_Sys_DitDef( DitDefName ,DitDefValue ,DitDefComment)
VALUES  ( 'DitcentRate' , '2' ,'比率(%)')