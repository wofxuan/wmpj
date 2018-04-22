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
		
		[Name] VARCHAR(66) NOT NULL DEFAULT (''),--简称
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
	
--商品的多单位信息
IF OBJECT_ID('dbo.tbx_Base_PtypeUnit') IS NULL 
	CREATE TABLE [dbo].[tbx_Base_PtypeUnit]
	(
		[PTypeId] VARCHAR(50) NOT NULL  DEFAULT (''),
		[UnitName] VARCHAR (10) NOT NULL  DEFAULT (''),--辅助单位的名称
		[URate] NUMERIC(22, 10) NOT NULL DEFAULT (0),--和基本单位的比例如1:100
		[IsBase] INT NOT NULL  DEFAULT (0),--是否是系统基本的单位
		[BarCode] VARCHAR(60) NOT NULL  DEFAULT (''),--商品对应的条码
		[Comment] VARCHAR (200) NOT NULL  DEFAULT (''),
		[OrdId] VARCHAR (21) NOT NULL  DEFAULT ('')	--顺序，0：系统默认，1：辅助单位1,2：辅助单位2
		CONSTRAINT PK_tbx_Base_PtypeUnit PRIMARY KEY ([PTypeId], [OrdId]) ON [PRIMARY]
		)
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
		
		[Name] VARCHAR(66) NOT NULL DEFAULT (''),--简称
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
		
		[IsStop] INT  NOT NULL DEFAULT (0)--是否停用 
		CONSTRAINT PK_tbx_Base_Dtype PRIMARY KEY ([DTypeId])
	)
	INSERT dbo.tbx_Base_Dtype( DTypeId ,Parid ,Leveal ,DUsercode ,DFullname)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部部门')
END
GO 

--单据类型
IF OBJECT_ID('dbo.tbx_Base_Vtype') IS NULL 
BEGIN
	CREATE TABLE tbx_Base_Vtype
	(
		[VTypeId] VARCHAR(50) ,
		[Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
		[VSonnum] INT NOT NULL DEFAULT 0 ,
		[Soncount] INT NOT NULL DEFAULT 0 , 
		[Leveal] INT NOT NULL DEFAULT 1 ,
		[VUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[VFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[VComment] VARCHAR(255) NOT NULL DEFAULT '' ,
		[VNamepy] VARCHAR(66) NOT NULL DEFAULT (''),
		[VRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] BIT NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0,
		
		[VchType] INT  NOT NULL DEFAULT (0), --定义的单据MoudleNo好
		[NumberPrefix] VARCHAR(255) NOT NULL DEFAULT '', --单据编号前缀 如:XS
		[SNFormat] VARCHAR(255) NOT NULL DEFAULT '' --单据编号生成格式 如:"XS" - yyyy - mm - dd - [000] 
		CONSTRAINT PK_tbx_Base_Vtype PRIMARY KEY ([VTypeId])
	)
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VSonnum, Soncount)
	VALUES  ( '00000' ,'0' ,0 ,'000000000' ,'全部单据', 7, 7)
	
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00001' ,'00000' ,1 ,'00001' ,'进货订单', 1, 'JHD', '"JHD" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00002' ,'00000' ,1 ,'00002' ,'销售订单', 2, 'XSD', '"SHD" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00003' ,'00000' ,1 ,'00003' ,'进货单', 3, 'JH', '"JH" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00004' ,'00000' ,1 ,'00004' ,'销售单', 4, 'XS', '"XS" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00005' ,'00000' ,1 ,'00005' ,'调拨单', 5, 'DB', '"DB" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00006' ,'00000' ,1 ,'00006' ,'收款单', 6, 'SKD', '"SKD" - yyyy - mm - dd - [000]')
	INSERT dbo.tbx_Base_Vtype( VTypeId ,Parid ,Leveal ,VUsercode ,VFullname, VchType, NumberPrefix, SNFormat)
	VALUES  ( '00007' ,'00000' ,1 ,'00007' ,'付款单', 7, 'FKD', '"FKD" - yyyy - mm - dd - [000]')
END
GO 

--科目信息
IF OBJECT_ID('dbo.tbx_Base_Atype') IS NULL 
BEGIN
    CREATE TABLE [dbo].[tbx_Base_Atype]
        (
          [ATypeId] VARCHAR(50) ,
          [Parid] VARCHAR(50) NOT NULL DEFAULT '' ,
          [ASonnum] INT NOT NULL DEFAULT 0 ,
          [Soncount] INT NOT NULL DEFAULT 0 , 
          [Leveal] INT NOT NULL DEFAULT 1 ,
          [AUsercode] VARCHAR(66) NOT NULL DEFAULT '' ,
          [AFullname] VARCHAR(66) NOT NULL DEFAULT '' ,
          [AComment] VARCHAR(255) NOT NULL DEFAULT '' ,
          [ANamepy] VARCHAR(66) NOT NULL DEFAULT '' ,
          [ARec] INT NOT NULL IDENTITY(1, 1),
          [Parrec] INT NOT NULL DEFAULT 0,
          [RowIndex] INT NOT NULL DEFAULT 0 ,
          [Deleted] BIT NOT NULL DEFAULT 0,
          [Updatetag] INT NOT NULL DEFAULT 0,  
          --以上是基本信息必须的字段，下面是自定义的字段
          [AName] VARCHAR(66) NOT NULL DEFAULT (''),--简称
          [SysRow] BIT NOT NULL DEFAULT 0,--系统默认科目
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),--当前金额
		  [Total00] NUMERIC(22, 10) NOT NULL DEFAULT (0),--期初金额
		  [TTL01] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL02] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL03] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL04] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL05] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL06] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL07] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL08] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL09] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL10] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL11] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [TTL12] NUMERIC(22, 10) NOT NULL DEFAULT (0)
          CONSTRAINT PK_tbx_Base_Atype PRIMARY KEY ([ATypeId])
        )
	SET IDENTITY_INSERT [dbo].[tbx_Base_Atype] ON
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00000', N'root', 8, 200, 0, N'00', N'全部科目', N' ', N'', 1, 0, 0, 0, 1, N'科目', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00001', N'00000', 9, 200, 1, N'01', N'【资产类】', N'', N'zcl', 2, 1, 0, 0, 54, N'资产类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100001', N'00001', 0, 200, 2, N'011', N'库存商品', N'', N'kcsp', 3, 54, 0, 0, 55, N'库存商品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100002', N'00001', 3, 200, 2, N'012', N'固定资产合计', N'', N'gdzchj', 4, 54, 1, 0, 56, N'固定资产', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000010000200001', N'0000100002', 0, 200, 3, N'0121', N'固定资产_甲', N'', N'gdzcj', 5, 56, 0, 0, 57, N'固资_甲', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100003', N'00001', 1, 200, 2, N'101', N'现金合计', N'', N'xjhj', 6, 54, 2, 0, 60, N'现金合计', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000010000300001', N'0000100003', 0, 0, 3, N'101', N'现    金', N'', N'xj', 7, 60, 0, 0, 117, N'现    金', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100004', N'00001', 5, 200, 2, N'014', N'『全部银行存款合计』', N'', N'qbyhckhj', 8, 54, 3, 0, 61, N'银行存款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000010000400001', N'0000100004', 0, 200, 3, N'0141', N'建设银行', N'', N'jsyh', 9, 61, 0, 0, 62, N'建设银行', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100005', N'00001', 0, 200, 2, N'016', N'『应收款合计』', N'', N'yskhj', 10, 54, 4, 0, 68, N'  应收款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100006', N'00001', 0, 200, 2, N'017', N'『借出商品』', N'', N'jcsp', 11, 54, 5, 0, 69, N'借出商品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100007', N'00001', 0, 200, 2, N'015', N'待摊费用', N'', N'dtfy', 12, 54, 6, 0, 67, N'待摊费用', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100008', N'00001', 0, 200, 2, N'018', N'委托商品款', N'', N'wtspk', 13, 54, 7, 0, 101, N'委托商品款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100009', N'00001', 0, 200, 2, N'1151', N'预付账款', N'', N'yfzk', 14, 54, 8, 0, 105, N'预付账款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100010', N'00001', 0, 0, 2, N'1408', N'委托加工物资', N'', N'wtjgwz', 15, 54, 9, 0, 0, N'委托加工物资', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100011', N'00001', 0, 0, 2, N'1241', N'自制半成品', N'', N'zzbcp', 16, 54, 10, 0, 125, N'自制半成品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100012', N'00001', 0, 0, 2, N'1606', N'固定资产清理', N'', N'gdzcql', 17, 54, 11, 0, 0, N'固定资产清理', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000100013', N'00001', 0, 0, 2, N'1604', N'在建工程', N'', N'zjgc', 18, 54, 12, 0, 0, N'在建工程', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00002', N'00000', 4, 200, 1, N'02', N'【负债类】', N'', N'fzl', 19, 1, 1, 0, 70, N'负债类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200001', N'00002', 0, 200, 2, N'021', N'『应付款合计』', N'', N'yfkhj', 20, 70, 0, 0, 71, N'  应付款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200002', N'00002', 0, 200, 2, N'022', N'『借入商品』', N'', N'jrsp', 21, 70, 1, 0, 72, N'借入商品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200003', N'00002', 0, 200, 2, N'', N'受托商品', N'', N'stsp', 22, 70, 2, 0, 104, N'受托商品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200004', N'00002', 0, 200, 2, N'', N'应交税金', N'', N'yjsj', 23, 70, 3, 0, 99, N'应交税金', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200005', N'00002', 0, 200, 2, N'2131', N'预收账款', N'', N'yszk', 24, 70, 4, 0, 106, N'预收账款', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000200006', N'00002', 0, 200, 2, N'023', N'会员储值', N'', N'hycz', 25, 70, 5, 0, 107, N'会员储值', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00003', N'00000', 3, 200, 1, N'03', N'【收入类】', N'', N'srl', 26, 1, 2, 0, 73, N'收入类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000300001', N'00003', 0, 200, 2, N'031', N'『销售收入』', N'', N'xssr', 27, 73, 0, 0, 74, N'销售收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000300002', N'00003', 8, 200, 2, N'032', N'『商品类收入』', N'', N'splsr', 28, 73, 1, 0, 75, N'商品收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200001', N'0000300002', 0, 200, 3, N'0321', N'商品报溢收入', N'', N'spbysr', 29, 75, 0, 0, 76, N'商品报溢', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200002', N'0000300002', 0, 200, 3, N'', N'其它入库收入', N'', N'qtrksr', 30, 75, 1, 0, 77, N'其它入库收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200003', N'0000300002', 0, 200, 3, N'0322', N'成本调价收入', N'', N'cbtjsr', 31, 75, 2, 0, 78, N'调价收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200004', N'0000300002', 0, 200, 3, N'0323', N'进货退货差价', N'', N'jhthcj', 32, 75, 3, 0, 79, N'结算差价', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200005', N'0000300002', 0, 200, 3, N'0324', N'变价调拨差价', N'', N'bjdbcj', 33, 75, 4, 0, 80, N'调拨差价', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200006', N'0000300002', 0, 200, 3, N'0325', N'商品拆装差价', N'', N'spczcj', 34, 75, 5, 0, 81, N'拆装差价', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200007', N'0000300002', 0, 200, 3, N'0326', N'借转进货结算与成本差', N'', N'jzjhjsycbc', 35, 75, 6, 0, 82, N'其它收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000200008', N'0000300002', 0, 200, 3, N'0327', N'配送差价', N'', N'pscj', 36, 0, 8, 0, 0, N'配送差价', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000300003', N'00003', 3, 200, 2, N'033', N'『其它收入』', N'', N'qtsr', 37, 73, 2, 0, 83, N'其它收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000300001', N'0000300003', 0, 200, 3, N'0331', N'调账收入', N'', N'tzsr', 38, 83, 0, 0, 84, N'调账收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000300002', N'0000300003', 0, 200, 3, N'0332', N'利息收入', N'', N'lxsr', 39, 83, 1, 0, 85, N'利息收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000030000300003', N'0000300003', 0, 200, 3, N'', N'其它', N'', N'qt', 40, 83, 2, 0, 86, N'其它....', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000300004', N'00003', 0, 200, 2, N'6051', N'其它业务收入', N'', N'qtywsr', 41, 73, 3, 0, 0, N'其它业务收入', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00004', N'00000', 3, 200, 1, N'04', N'【支出类】', N'', N'zcl', 42, 1, 3, 0, 87, N'支出类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000400001', N'00004', 0, 200, 2, N'041', N'『销售成本』', N'', N'xscb', 43, 87, 0, 0, 88, N'销售成本', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000400002', N'00004', 2, 200, 2, N'042', N'『商品类支出』', N'', N'splzc', 44, 87, 2, 0, 89, N'商品支出', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000200001', N'0000400002', 0, 200, 3, N'0421', N'商品报损', N'', N'spbs', 45, 89, 0, 0, 90, N'商品报损', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000200002', N'0000400002', 0, 200, 3, N'0422', N'其它出库费用', N'', N'qtckfy', 46, 89, 1, 0, 91, N'其它出库费用', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000400003', N'00004', 3, 200, 2, N'043', N'『费用合计』', N'', N'fyhj', 47, 87, 3, 0, 92, N'费用合计', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300001', N'0000400003', 0, 200, 3, N'0431', N'调账亏损', N'', N'tzks', 48, 92, 0, 0, 93, N'调账亏损', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300002', N'0000400003', 0, 200, 3, N'0432', N'固定资产折旧', N'', N'gdzczj', 49, 92, 1, 0, 94, N'资产折旧', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300003', N'0000400003', 0, 0, 3, N'0438', N'积分转储值', N'', N'jfzcz', 50, 92, 3, 0, 120, N'积分转储值', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300004', N'0000400003', 0, 0, 3, N'0440', N'积分换商品', N'', N'jfhsp', 51, 92, 4, 0, 121, N'积分换商品', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300005', N'0000400003', 0, 0, 3, N'0441', N'运费', N'', N'yf', 52, 92, 5, 0, 0, N'运费', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000300006', N'0000400003', 0, 0, 3, N'0443', N'礼品赠送', N'', N'lpzs', 53, 0, 6, 0, 0, N'礼品赠送', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000040000390000', N'0000400003', 0, 200, 3, N'0439', N'优惠', N'', N'yh', 54, 92, 2, 0, 100, N'优惠', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000400004', N'00004', 0, 200, 2, N'5405', N'其它业务支出', N'', N'qtywzc', 55, 0, 1, 0, 0, N'其它业务支出', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00005', N'00000', 2, 200, 1, N'05', N'【权益合计】', N'', N'qyhj', 56, 1, 4, 0, 96, N'权益类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000500001', N'00005', 0, 200, 2, N'3101', N'实收资本', N'', N'sszb', 57, 96, 0, 0, 97, N'实收资本', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000500002', N'00005', 0, 200, 2, N'3131', N'本年利润', N'', N'bnlr', 58, 96, 1, 0, 98, N'本年利润', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000500003', N'00005', 1, 1, 2, N'3141', N'利润分配', N'', N'lrfp', 59, 96, 2, 0, 118, N'利润分配', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000050000300001', N'0000500003', 0, 0, 3, N'314101', N'未分配利润', N'', N'wfplr', 60, 121, 0, 0, 119, N'未分配利润', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'00006', N'00000', 2, 200, 1, N'06', N'【成本类】', N'', N'cbl', 61, 1, 5, 0, 122, N'成本类', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000600001', N'00006', 1, 1, 2, N'4101', N'生产成本', N'', N'sccb', 62, 195, 0, 0, 122, N'生产成本', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'000060000100001', N'0000600001', 0, 0, 3, N'410101', N'基本生产成本', N'', N'jbsccb', 63, 196, 0, 0, 122, N'基本生产成本', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000600002', N'00006', 0, 0, 2, N'4105', N'制造费用', N'', N'zcfy', 64, 195, 0, 0, 123, N'制造费用', 1)
	INSERT [dbo].[tbx_Base_Atype] ([ATypeId], [Parid], [ASonnum], [Soncount], [Leveal], [AUsercode], [AFullname], [AComment], [ANamepy], [ARec], [Parrec], [RowIndex], [Deleted], [Updatetag], [AName], [SysRow]) VALUES (N'0000600003', N'00006', 0, 0, 2, N'4107', N'劳务成本', N'', N'lwcb', 65, 195, 0, 0, 124, N'劳务成本', 1)
	SET IDENTITY_INSERT [dbo].[tbx_Base_Atype] OFF
END   
GO

--单据-单据号的记录
IF OBJECT_ID('dbo.tbx_Bill_NumberRecords') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_NumberRecords]
        (
          [ComputerID] VARCHAR(10) NOT NULL ,--计算机号,可以在所有单据中加前缀
          [VchType] INT NOT NULL DEFAULT ( 0 ) ,--单据类型
          [LoopType] INT NOT NULL DEFAULT ( 1 ) ,--编号循环类型，是一天0，一月1，还是一年2，开始重新生成
          [Period] INT NOT NULL DEFAULT ( 0 ) ,--此记录所在的循环期间
          [MaxNo] INT NOT NULL DEFAULT ( 0 ) ,--此记录条件下产生的最大单据号
          CONSTRAINT PK_tbx_Bill_NumberRecords PRIMARY KEY ( [ComputerID], [VchType], [Period], [MaxNo] ) ON [PRIMARY]
        )
        
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

--系统-相关的配置参数
IF OBJECT_ID('dbo.tbx_Sys_Param') IS NULL 
BEGIN
    CREATE TABLE [dbo].[tbx_Sys_Param]
        (
          [PKey] VARCHAR(50) NOT NULL DEFAULT NEWID() ,
          [PName] VARCHAR(50) NOT NULL DEFAULT '' ,--名称
          [PValue] VARCHAR(1024) NOT NULL DEFAULT '' ,--参数值
          [RowIndex] INT NOT NULL DEFAULT 0 ,--排列顺序
          [PComment] VARCHAR(512) NOT NULL DEFAULT '' ,--备注
          CONSTRAINT PK_tbx_Sys_Param PRIMARY KEY ( PKey )
        )
	 INSERT dbo.tbx_Sys_Param ( PKey, PName, PValue, PComment )
	 VALUES ( '6803F1DE-3B23-481E-92FE-A4F4107E55F7', 'InitOver', '0', '开账标志,1开账,0未开账' ) 
END
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
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_Order_D PRIMARY KEY ( [DlyOrder] )
        )
        
GO

--单据-进货,销售或者其它要过账单据的主表
IF OBJECT_ID('dbo.tbx_Bill_M') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_M]
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
		  [AuditState] INT NOT NULL DEFAULT (-1),--审核状态 -1:普通单据; 0:待审核; 1:审核中; 2:审核完成
		  [Draft] INT NOT NULL DEFAULT (0),--过账标志 1草稿，2过账
		  --以上是单据类型表必须定义的字段
		  
		  [PostNo] VARCHAR(50) NOT NULL DEFAULT (''),--单据过账人ID
		  [Attach] INT NOT NULL DEFAULT (0),--附件ID
		  [GatheringDate] VARCHAR(10) NOT NULL DEFAULT (''),--交货日期
		  [InvoceTag] INT NOT NULL DEFAULT (0),--对账标记
		  [VipCardID] INT NOT NULL DEFAULT (0),--会员卡ID，0没有，>0会员卡ID
		  [VipDiscount] NUMERIC(22, 10) DEFAULT (0),--会员卡设置的折扣
		  [IsRetail] INT NOT NULL DEFAULT (0),--零售单标志，0不是，1是
		  [FromOrderCode] INT NOT NULL DEFAULT (0),--收款单,付款单的时候,记录进货单,销售单ID
		  [ModifyEtypeId] VARCHAR(50) NOT NULL DEFAULT (''),--过账后,修改单据的人员ID
		  [ModifyDate] VARCHAR(20) NOT NULL DEFAULT (''),--过账后,修改单据的时间
		  [MenID] INT NOT NULL DEFAULT (0),--如果是门店上传的单据记录门店ID
		  [IsFaxed] INT NOT NULL DEFAULT (0),--如果是门店，上传标志
          CONSTRAINT PK_tbx_Bill_M PRIMARY KEY ( [VchCode] )
        )
        
GO

--单据-进货,销售或者其它要过账单据的草稿从表
IF OBJECT_ID('dbo.tbx_Bill_D_Bak') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_D_Bak]
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
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  [VipCardId] INT NOT NULL DEFAULT (0),--会员卡号
		  [PromoVchcode] NUMERIC(10, 0) NOT NULL DEFAULT (0),--促销单号
		  [InPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库单价
		  [InTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库金额
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_D_Bak PRIMARY KEY ( [DlyOrder] )
        )
        
GO

--单据-进货单的从表
IF OBJECT_ID('dbo.tbx_Bill_Buy_D') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_Buy_D]
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
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  [VipCardId] INT NOT NULL DEFAULT (0),--会员卡号
		  [PromoVchcode] NUMERIC(10, 0) NOT NULL DEFAULT (0),--促销单号
		  [InPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库单价
		  [InTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库金额
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_Buy_D PRIMARY KEY ( [DlyOrder] )
        )
        
GO

--单据-销售单的从表
IF OBJECT_ID('dbo.tbx_Bill_Sale_D') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_Sale_D]
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
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  [VipCardId] INT NOT NULL DEFAULT (0),--会员卡号
		  [PromoVchcode] NUMERIC(10, 0) NOT NULL DEFAULT (0),--促销单号
		  [InPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库单价
		  [InTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库金额
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_Sale_D PRIMARY KEY ( [DlyOrder] )
        )
        
GO

--单据-财务数据的从表,在做相关单据的时候都会写入对应的科目数据
IF OBJECT_ID('dbo.tbx_Bill_A_D') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_A_D]
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
		  
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),--金额
		  
		  [Redword] CHAR(2) NOT NULL DEFAULT ('F'),--是否是红冲生成的单据 F不是,T是
		  [InputDate] VARCHAR(10)NOT NULL DEFAULT (''),--主表的录单日期
		  [Period] SMALLINT NOT NULL DEFAULT (1),--对应的月度期间1-12之间
		  [YearPeriod] INT NOT NULL DEFAULT (1),--对应的年度期间一直递增
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注

          CONSTRAINT PK_tbx_Bill_A_D PRIMARY KEY ( [VchCode], [VchType], [AtypeId])
        )
        
GO

--单据-付款或收款单结算的对应的单据
IF OBJECT_ID('dbo.tbx_Bill_A_Gathering') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_A_Gathering]
        (
          [BtypeId] VARCHAR(50) NOT NULL DEFAULT ( '' ) ,--结算单位
          [VchCode] INT NOT NULL DEFAULT ( 0 ) ,--对应的单据ID
          [VchType] INT NOT NULL DEFAULT ( 0 ) ,--对应的单据类型
          [GatheringVchCode] INT NOT NULL DEFAULT ( 0 ) ,--付款或收款单等的主表ID
          [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),--结算的金额
          [DlyOrder] INT NOT NULL IDENTITY(1, 1) ,
          CONSTRAINT PK_tbx_Bill_A_Gathering PRIMARY KEY ( [BTypeID], [VchCode] )
        )   
GO

--单据-调拨单等的从表
IF OBJECT_ID('dbo.tbx_Bill_Other_D') IS NULL 
    CREATE TABLE [dbo].[tbx_Bill_Other_D]
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
		  [UsedType] CHAR(1) NOT NULL DEFAULT ('1'),--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 空是系统生成的记录
		  [Comment] VARCHAR(256) NOT NULL DEFAULT (''),--备注
		  
		  [VipCardId] INT NOT NULL DEFAULT (0),--会员卡号
		  [PromoVchcode] NUMERIC(10, 0) NOT NULL DEFAULT (0),--促销单号
		  [InPrice] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库单价
		  [InTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--入库金额
		  --[SideQty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--副单位数量,五金建材版的时候使用
		  --[Pgholqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--件数,布匹版
		  --[PgholInqty] NUMERIC(22, 10) NOT NULL DEFAULT (0),--总件数,布匹版
		  --[InvoceTag] [int] NOT NULL DEFAULT (0),--对账标志
		  --[InvoceTotal] NUMERIC(22, 10) NOT NULL DEFAULT (0),--开票金额
          CONSTRAINT PK_tbx_Bill_Other_D PRIMARY KEY ( [DlyOrder] )
        )   
GO

--期初库存信息表
IF OBJECT_ID('dbo.tbx_Stock_Goods_Ini') IS NULL 
    CREATE TABLE [dbo].[tbx_Stock_Goods_Ini]
        (
          [GoodsOrderId] INT NOT NULL IDENTITY(1, 1) ,
          [PTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
          [KTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
		  [JobNumber] VARCHAR(20)  NOT NULL DEFAULT (''),
		  [OutFactoryDate] VARCHAR(13)  NOT NULL DEFAULT (''),
		  [Qty] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Price] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [GoodsOrder] INT NOT NULL DEFAULT (0)	--显示顺序
          CONSTRAINT PK_tbx_Stock_Goods_Ini PRIMARY KEY ( [PTypeId], [KTypeId] )
        )     
GO

--库存信息表
IF OBJECT_ID('dbo.tbx_Stock_Goods') IS NULL 
    CREATE TABLE [dbo].[tbx_Stock_Goods]
        (
          [GoodsOrderId] INT NOT NULL IDENTITY(1, 1) ,
          [PTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
          [KTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
		  [JobNumber] VARCHAR(20)  NOT NULL DEFAULT (''),
		  [OutFactoryDate] VARCHAR(13)  NOT NULL DEFAULT (''),
		  [Qty] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Price] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [GoodsOrder] INT NOT NULL DEFAULT (0)	--显示顺序
          CONSTRAINT PK_tbx_Stock_Goods PRIMARY KEY ( [PTypeId], [KTypeId] )
        )     
GO
          
--库存信息变动表
IF OBJECT_ID('dbo.tbx_Stock_Glide') IS NULL 
    CREATE TABLE [dbo].[tbx_Stock_Glide]
        (
          [GoodsID] INT NOT NULL IDENTITY(1, 1) ,
          [VchCode] INT NOT NULL DEFAULT (0),
          [VchType] INT NOT NULL DEFAULT (0),
          [DlyOrder] INT NOT NULL DEFAULT (0),
          [PTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
          [KTypeId] VARCHAR(50) NOT NULL DEFAULT '' ,
		  [JobNumber] VARCHAR(20)  NOT NULL DEFAULT (''),
		  [OutFactoryDate] VARCHAR(13)  NOT NULL DEFAULT (''),
		  [Qty] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Price] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [Total] NUMERIC(22, 10) NOT NULL DEFAULT (0),
		  [GoodsDate] VARCHAR(50) NOT NULL DEFAULT (''),--变动日期
		  [GoodsOrder] INT NOT NULL DEFAULT (0)	--显示顺序
          CONSTRAINT PK_tbx_Stock_Glide PRIMARY KEY ( [GoodsID])
        )      
GO

--库存盘点表
IF OBJECT_ID('dbo.tbx_Stock_Check') IS NULL 
BEGIN
	CREATE TABLE [dbo].[tbx_Stock_Check]
	(
	[KTypeId] VARCHAR(50) NOT NULL DEFAULT (''),
	[PTypeId] VARCHAR(50) NOT NULL DEFAULT (''),
	[GoodsOrder] INT NOT NULL DEFAULT (0), --对应库存表中的Goodsorder字段
	[CostMode] INT NOT NULL DEFAULT (0),--商品算法
	[CheckedQty] NUMERIC(22, 10)	NOT NULL DEFAULT (0),--盘点数量
	[UpdateTag] INT NOT NULL DEFAULT (0),--盘点号
	[StockQty] NUMERIC(22, 10)	NOT NULL DEFAULT (0),--库存量
	[CheckDate] VARCHAR (10) NOT NULL DEFAULT (''),--盘点日期
	[SCId] INT NOT NULL IDENTITY(1, 1),--
	[JobNumber] VARCHAR (20) NOT NULL DEFAULT (''),--批号
	[OutFactoryDate] VARCHAR(13) NOT NULL DEFAULT (''),--生产日期
	[Total] NUMERIC (22, 10) NOT NULL DEFAULT (0),--
	[ETypeId] VARCHAR (50) NOT NULL DEFAULT (''),--操作员
	[CheckedMode] INT NOT NULL DEFAULT (0), --盘点模式--总量盘点,分量盘点
	[History] INT NOT NULL DEFAULT (0)--0当前执行的盘点,1历史记录
	) 	
END
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

--权限-权限功能列表
IF OBJECT_ID('dbo.tbx_Limit_Action') IS NULL 
    CREATE TABLE [dbo].[tbx_Limit_Action]
        (
          [LAGUID] VARCHAR(50) NOT NULL DEFAULT '' ,
          [LAName] VARCHAR(50) NOT NULL DEFAULT '',
          [LAType] INT NOT NULL DEFAULT 0 ,--类型，0未配置，1基本信息，2单据，3报表，4数据，5其它
          [LARowIndex] INT NOT NULL DEFAULT 0 ,
          [LARemark] VARCHAR(200) NOT NULL DEFAULT ''
          CONSTRAINT PK_tbx_Limit_Action PRIMARY KEY ( [LAGUID] )
        )
GO

--权限-角色
IF OBJECT_ID('dbo.tbx_Limit_Role') IS NULL 
    CREATE TABLE [dbo].[tbx_Limit_Role]
        (
          [LRGUID] VARCHAR(50) NOT NULL DEFAULT '' ,
          [LRName] VARCHAR(50) NOT NULL DEFAULT '' ,
          [LRRowIndex] INT NOT NULL IDENTITY(1, 1) ,
          [LRRemark] VARCHAR(200) NOT NULL DEFAULT ''
          CONSTRAINT PK_tbx_Limit_Role PRIMARY KEY ( [LRGUID] )
        )
GO

--权限-角色用户映射表
IF OBJECT_ID('dbo.tbx_Limit_RU') IS NULL 
    CREATE TABLE [dbo].[tbx_Limit_RU]
        (
          [LRGUID] VARCHAR(50) NOT NULL DEFAULT '' ,--角色表点LRID
          [UserId] VARCHAR(50) NOT NULL DEFAULT '' --职员表点ETypeID
          CONSTRAINT PK_tbx_Limit_RU PRIMARY KEY ( [LRGUID], [UserId])
        )
GO

--权限-权限和角色映射表
IF OBJECT_ID('dbo.tbx_Limit_Action_Role') IS NULL 
    CREATE TABLE [dbo].[tbx_Limit_Action_Role]
        (
          [LAGUID] VARCHAR(50) NOT NULL DEFAULT '' ,--权限功能ID
          [RUID] VARCHAR(50) NOT NULL DEFAULT '' ,--角色或用户ID
          [RUType] INT NOT NULL DEFAULT 0 ,--0未定义，1角色ID，2用户ID
          --基本信息类型权限，2^x之和确定。查看，新增，分类，修改，删除，打印
          --单据权限
          [LimitValue] INT NOT NULL DEFAULT 0
          CONSTRAINT PK_tbx_Limit_Action_Role PRIMARY KEY ( [LAGUID], [RUID], [RUType] )
        )
GO

--流程设置，进货单审核，入职审核等
IF OBJECT_ID('dbo.tbx_Flow_TaskType') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_TaskType]
        (
          [TaskID] INT NOT NULL IDENTITY(1, 1) ,
          [TaskName] VARCHAR(50) NOT NULL DEFAULT '' ,--流程作业名称
          [TType] INT NOT NULL DEFAULT 0 ,--选择：单据业务0；人事1；
		  [Statu] INT NOT NULL DEFAULT 0 ,--是否启用,0未启用,1启用.启用用后如果设置了默认的作业表会自动进入流程
		  [WorkID] VARCHAR(50) NOT NULL DEFAULT '' ,--与具体业务功能模块关联的Id,如单据的MoudelNo等
          [TComment] VARCHAR(255) NOT NULL DEFAULT '',--备注
          CONSTRAINT PK_tbx_Flow_TaskType PRIMARY KEY (TaskID)
        )
GO

--流程作业流程表，同一个流程作业可能有不同的设置。如入职时普通员工和经理审核的流程不一样
IF OBJECT_ID('dbo.tbx_Flow_TaskProc') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_TaskProc]
        (
          [TaskProcID] INT NOT NULL IDENTITY(1, 1) ,
		  [TaskID] INT NOT NULL DEFAULT 0,
		  [DefaultProc] INT NOT NULL DEFAULT 0,--是否流程使用默认流程，1是，0否
          [TaskProcName] VARCHAR(50) NOT NULL DEFAULT '' ,--流程名称
          CONSTRAINT PK_tbx_Flow_TaskProc PRIMARY KEY (TaskProcID)
        )
GO

--流程作业具体项目表
IF OBJECT_ID('dbo.tbx_Flow_Process') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_Process]
        (
          [ProcessID] INT NOT NULL IDENTITY(1, 1) ,
		  [TaskProcID] INT NOT NULL DEFAULT 0,
          [ProcesseName] VARCHAR(50) NOT NULL DEFAULT '' ,--项目名称
		  [OperType] INT NOT NULL DEFAULT 0,--操作类型，0审核，1知会，2执行。（知会不需要输入审批意见,可能审批完成后通知发起人）
		  [ProceOrder] INT NOT NULL DEFAULT 0,--项目顺序,从小到大执行
          CONSTRAINT PK_tbx_Flow_Process PRIMARY KEY (ProcessID)
        )
GO

--流程作业具体项目表对应的审核人员
IF OBJECT_ID('dbo.tbx_Flow_ProcePermi') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_ProcePermi]
        (
          [PPID] INT NOT NULL IDENTITY(1, 1) ,
		  [ProcessID] INT NOT NULL DEFAULT 0,
		  [PermiType] INT NOT NULL DEFAULT 0,--0职员
          [OperId] VARCHAR(50) NOT NULL DEFAULT '' ,--职员ID（以后可能扩展为部门或者岗位）
          CONSTRAINT PK_tbx_Flow_ProcePermi PRIMARY KEY (PPID)
        )
GO

--流程作业审核路径，具体业务的每个项目对应的审核记录
IF OBJECT_ID('dbo.tbx_Flow_ProcePath') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_ProcePath]
        (
          [ProcePathID] INT NOT NULL IDENTITY(1, 1) ,
		  [ProcessID] INT NOT NULL DEFAULT 0,--tbx_Flow_Process的ID
		  [BillID] INT NOT NULL DEFAULT 0,--要审核的记录的ID
		  [BillType] INT NOT NULL DEFAULT 0,--要审核的记录的类型，可能同一个窗体，多个功能
		  [WorkID] VARCHAR(50) NOT NULL DEFAULT '' ,--与具体业务功能模块关联的Id,如单据的MoudelNo等
          [FlowETypeID] VARCHAR(50) NOT NULL DEFAULT '' ,--需要处理这条记录的职员ID
		  [ProceResult] INT NOT NULL DEFAULT 0,--未处理0，通过1，终止2，退回-1
		  [FlowInfo] VARCHAR(255) NOT NULL DEFAULT '' ,--审批意见
		  [Info] VARCHAR(255) NOT NULL DEFAULT '' ,--摘要信息,自动生成,方便汇总处理时查看
		  [CreaterETypeID] VARCHAR(50) NOT NULL DEFAULT '' ,--提交这条审核记录的人员
		  [CreateTime] VARCHAR(20) NOT NULL DEFAULT '' ,--提交这条审核记录的时间
          CONSTRAINT PK_tbx_Flow_ProcePath PRIMARY KEY (ProcePathID)
        )
GO

--流程作业审核历史记录
IF OBJECT_ID('dbo.tbx_Flow_His') IS NULL 
    CREATE TABLE [dbo].[tbx_Flow_His]
        (
          [HisID] INT NOT NULL IDENTITY(1, 1) ,
		  [ProcePathID] INT NOT NULL DEFAULT 0,--tbx_Flow_ProcePath的ID
		  [ProceResult] INT NOT NULL DEFAULT 0,--未处理0，通过1，终止2，退回-1
		  [FlowInfo] VARCHAR(255) NOT NULL DEFAULT '' ,--审批意见
		  [CreaterETypeID] VARCHAR(50) NOT NULL DEFAULT '' ,--提交这条审核记录的人员
		  [CreateTime] VARCHAR(20) NOT NULL DEFAULT '' ,--提交这条审核记录的时间
          CONSTRAINT PK_tbx_Flow_His PRIMARY KEY (HisID)
        )
GO


--测试数据
--初始化职员
DELETE dbo.tbx_Base_Etype WHERE ETypeId <> '00000'
UPDATE dbo.tbx_Base_Etype SET ESonnum = 3, Soncount = 3 WHERE ETypeId = '00000' 
INSERT dbo.tbx_Base_Etype ( ETypeId, Parid, ESonnum, Soncount, Leveal, EUsercode, EFullname, EComment, ENamepy, Parrec, RowIndex, Deleted, Updatetag, DTypeId,
                             Tel, [Address], Birthday, EMail, Job, TopTotal, LowLimitDiscount, IsStop )
VALUES  ( '00001', '00000', 0, 0, 1, 'zy1', '职员1', '', 'zy1', 2, 1, 0, 0, '', '10086', '重庆', '1980-01-01', '10086@qq.com', '', 1000, 0.1, 0 ),
        ( '00002', '00000', 0, 0, 1, 'zy2', '职员2', '', 'zy2', 3, 1, 0, 1, '', '10000', '成都', '1981-12-12', '10000@qq.com', '', 2000, 0.2, 0 ),
		( '00003', '00000', 0, 0, 1, 'zy3', '职员3', '', 'zy3', 4, 1, 0, 1, '', '10001', '北京', '1971-12-12', '10001@qq.com', '', 3000, 0.2, 0 )

--初始化商品
DELETE  dbo.tbx_Base_Ptype WHERE   PTypeId <> '00000'
UPDATE  dbo.tbx_Base_Ptype SET PSonnum = 3, Soncount = 3 WHERE PTypeId = '00000' 
INSERT  dbo.tbx_Base_Ptype ( PTypeId, Parid, PSonnum, Soncount, Leveal, PUsercode, PFullname, PComment, PNamepy, Parrec, RowIndex, Deleted, Updatetag,
                             [Standard], Model, Area, UsefulLifeday, Costmode )
VALUES  ( '00001', '00000', 0, 0, 1, 'sp1', '商品1', '', 'sp1', 2, 1, 0, 0, '型号1', '规格1', '产地1', 0, 0 ),
        ( '00002', '00000', 0, 0, 1, 'sp2', '商品2', '', 'sp2', 3, 1, 0, 1, '型号1', '规格2', '产地2', 0, 0 ),
        ( '00003', '00000', 0, 0, 1, 'sp3', '商品3', '', 'sp3', 4, 1, 0, 1, '型号1', '规格3', '产地1', 1, 0 )

--初始化仓库
DELETE  dbo.tbx_Base_Ktype WHERE   KTypeId <> '00000'
UPDATE  dbo.tbx_Base_Ktype SET KSonnum = 3, Soncount = 3 WHERE KTypeId = '00000' 
INSERT  dbo.tbx_Base_Ktype ( KTypeId, Parid, KSonnum, Soncount, Leveal, KUsercode, KFullname, KComment, KNamepy, Parrec, RowIndex, Deleted, Updatetag, Name,
                                  [Address], Person, Tel, IsStop )
VALUES  ( '00001', '00000', 0, 0, 1, 'ck1', '仓库1', '', 'ck1', 2, 1, 0, 0, '简称1', '地址1', '负责人1', '10086', 0 ),
        ( '00002', '00000', 0, 0, 1, 'ck2', '仓库2', '', 'ck2', 3, 1, 0, 1, '简称2', '地址2', '负责人2', '10000', 0 ),
        ( '00003', '00000', 0, 0, 1, 'ck3', '仓库3', '', 'ck3', 4, 1, 0, 1, '简称3', '地址3', '负责人3', '10001', 0 )

--初始化单位
DELETE  dbo.tbx_Base_Btype WHERE   BTypeId <> '00000'
UPDATE  dbo.tbx_Base_Btype SET BSonnum = 3, Soncount = 3 WHERE BTypeId = '00000' 
INSERT  dbo.tbx_Base_Btype ( BTypeId, Parid, BSonnum, Soncount, Leveal, BUsercode, BFullname, BComment, BNamepy, Parrec, RowIndex, Deleted, Updatetag, Name,
                                  [Address], Tel)
VALUES  ( '00001', '00000', 0, 0, 1, 'dw1', '单位1', '', 'dw1', 2, 1, 0, 0, '简称1', '地址1', '10086' ),
        ( '00002', '00000', 0, 0, 1, 'dw2', '单位2', '', 'dw2', 3, 1, 0, 1, '简称2', '地址2', '10000' ),
        ( '00003', '00000', 0, 0, 1, 'dw3', '单位3', '', 'dw3', 4, 1, 0, 1, '简称3', '地址3', '10001' )


TRUNCATE TABLE  dbo.tbx_Base_PackageInfo
GO 
---初始化加载项
INSERT dbo.tbx_Base_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00000' ,'' ,10 ,9 ,0 ,'全部加载项' ,'全部加载项' ,'全部加载项' ,'全部加载项' ,1, 0)
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

TRUNCATE TABLE dbo.tbx_Limit_Action
--权限-基本类型的权限
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{48B70E42-705F-48C3-928F-FD94280F14D7}', '商品信息', 1, 1)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{D56591FC-49A2-4C6E-8A43-1A04D553CED2}', '单位信息', 1, 2)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{11831D9E-664A-4DD7-8B6A-8D286A15F31B}', '职员信息', 1, 3)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{64E32F93-0BED-40E6-8EE5-3AA25FA8D3B2}', '部门信息', 1, 4)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{3E91FE79-1072-4B99-AFD3-E4759B6C11ED}', '仓库信息', 1, 5)

INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{C68FA10B-741B-462E-9646-6A37E8A79543}', '进货订单', 2, 1)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{CD40BCFC-099E-476D-8560-5F65A7F9441D}', '进货单', 2, 2)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{50202B7A-256F-4B40-A142-8F78F9AE82A4}', '付款单', 2, 3)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{6138233E-9524-423F-881C-DAF556611881}', '销售订单', 2, 4)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{5AF10361-EAF6-4C63-B0CD-71B15802C9FC}', '销售单', 2, 5)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{4D06B1CD-38AA-431D-84ED-534676C46645}', '收款单', 2, 6)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{30B95AAD-6ABA-4BBF-94B8-FF9C8B3E059A}', '调拨单', 2, 7)

INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{AE2801FC-192F-4965-9994-7E6E74366510}', '库存状况', 3, 1)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{38C6C242-121E-4F3F-B0B7-2E51B8C4F9DE}', '进货订单查询', 3, 2)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{20C50FBF-5B4C-44AF-900B-4087BFB98880}', '进货单查询', 3, 3)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{350BF069-4CD4-4CBF-8F62-AEF407148AD4}', '销售订单查询', 3, 4)
INSERT INTO dbo.tbx_Limit_Action ( LAGUID, LAName, LAType, LARowIndex)
VALUES  ( '{7CDCC33E-9355-46ED-8E4B-6AE919F8AC2E}', '销售单查询', 3, 5)

TRUNCATE TABLE dbo.tbx_Limit_Role
--权限-角色
INSERT INTO dbo.tbx_Limit_Role ( LRGUID, LRName, LRRemark )
VALUES  ( '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', '超级用户组', '具有全部权限')
INSERT INTO dbo.tbx_Limit_Role ( LRGUID, LRName, LRRemark )
VALUES  ( '{ED676827-6BCC-4AC5-BF0D-6FB8DF850E22}', '经理组', '具有部分权限')
INSERT INTO dbo.tbx_Limit_Role ( LRGUID, LRName, LRRemark )
VALUES  ( '{59FF1812-B309-41E4-8F24-6CD3043B308D}', '组长组', '具有部分权限')
INSERT INTO dbo.tbx_Limit_Role ( LRGUID, LRName, LRRemark )
VALUES  ( '{B56B5A19-99C8-45BA-9A92-54E7F9B798BE}', '普通员工组', '具有部分权限')

TRUNCATE TABLE dbo.tbx_Limit_RU
--权限-角色用户映射表
INSERT INTO dbo.tbx_Limit_RU ( LRGUID, UserId )
VALUES  ( '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', '00000')
INSERT INTO dbo.tbx_Limit_RU ( LRGUID, UserId )
VALUES  ( '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', '00001')
INSERT INTO dbo.tbx_Limit_RU ( LRGUID, UserId )
VALUES  ( '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', '00002')

TRUNCATE TABLE dbo.tbx_Limit_Action_Role
--权限-基本信息类型的权限
INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
VALUES  ( '{48B70E42-705F-48C3-928F-FD94280F14D7}', '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', 1, 31 )
INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
VALUES  ( '{D56591FC-49A2-4C6E-8A43-1A04D553CED2}', '00000', 2, 63 )
INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
VALUES  ( '{11831D9E-664A-4DD7-8B6A-8D286A15F31B}', '{6E2F55C8-8B47-45E8-8EFB-AEB9A85BB423}', 1, 61 )

--业务流程
TRUNCATE TABLE dbo.tbx_Flow_TaskType
TRUNCATE TABLE dbo.tbx_Flow_TaskProc
TRUNCATE TABLE dbo.tbx_Flow_Process
TRUNCATE TABLE dbo.tbx_Flow_ProcePermi
TRUNCATE TABLE dbo.tbx_Flow_His

INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '进货订单', 0, 1, '2001', '进货订单审核')
INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '销售订单', 0, 1, '2002', '销售订单审核')
INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '进货单', 0, 1, '2003', '进货单审核')
INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '销售单', 0, 1, '2004', '销售单审核')
INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '调拨单', 0, 1, '2005', '调拨单审核')
INSERT dbo.tbx_Flow_TaskType ( TaskName, TType, Statu, WorkID, TComment )
VALUES  ( '收款单', 0, 1, '2006', '收款单审核')

INSERT dbo.tbx_Flow_TaskProc ( TaskID, DefaultProc, TaskProcName )
VALUES  ( 1, 1, '默认进货订单审核')

INSERT dbo.tbx_Flow_TaskProc ( TaskID, DefaultProc, TaskProcName )
VALUES  ( 1, 0, '大金额（大于100000）进货订单单审核')

INSERT dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
VALUES  ( 1, '组长审核', 0, 1)
INSERT dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
VALUES  ( 1, '经理审核', 0, 2)
INSERT dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
VALUES  ( 1, '总监审核', 0, 3)
INSERT dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
VALUES  ( 2, '总监审核', 0, 1)
INSERT dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
VALUES  ( 2, '董事审核', 0, 1)

INSERT dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
VALUES  ( 1, 0, '00001')
INSERT dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
VALUES  ( 2, 0, '00002')
INSERT dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
VALUES  ( 3, 0, '00003')
INSERT dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
VALUES  ( 4, 0, '00001')
INSERT dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
VALUES  ( 5, 0, '00002')