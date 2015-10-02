IF OBJECT_ID('dbo.pbx_Base_CreateID') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_CreateID
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   pbx_BasicCreateID                                                 
--  ||   过程功能：添加基本信息--创建id；
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||  	@parid		varchar(25),			--父id
--  ||  	@dbname 	varchar(30),			--表名
--  ||  	@createdid	varchar(25) output,		--typeid
--  ||  	@nson		int output,			--sonnum
--  ||  	@ncount 	int output,			--soncount
--  ||  	@nparrec	int output			--parrec
--  ||=========================================================================================                                         
--  ********************************************************************************************

CREATE         PROCEDURE pbx_Base_CreateID
    (
      @parid VARCHAR(50) ,			--父id
      @dbname VARCHAR(30) ,			--表名
      @createdid VARCHAR(50) OUTPUT ,		--typeid
      @nson INT OUTPUT ,			--sonnum
      @ncount INT OUTPUT ,			--soncount
      @nparrec INT OUTPUT ,			--parrec
      @errorValue VARCHAR(50) OUTPUT--返回错误信息
    )
AS 
    DECLARE @execsql VARCHAR(500)
    DECLARE @sztypeid VARCHAR(50)
    DECLARE @root_id VARCHAR(25)
    DECLARE @bank_id VARCHAR(25)
    DECLARE @fixed_id VARCHAR(25)
    DECLARE @expense_id VARCHAR(25)
    DECLARE @goods_income_id VARCHAR(25)
    DECLARE @par VARCHAR(25)
    DECLARE @sonnum INT
    DECLARE @soncount INT
    DECLARE @temprec INT
    DECLARE @iniover VARCHAR(10)
    DECLARE @tempsql VARCHAR(400) 
    DECLARE @flag INT
    SELECT  @root_id = '00000'

--检查 @parid是不是父类

    SET @flag = 0
    
    IF @dbname = 'tbx_Base_Ptype' SELECT  @flag = CASE WHEN PSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Ptype WHERE   Ptypeid = @parid
    IF @dbname = 'tbx_Base_Btype' SELECT  @flag = CASE WHEN BSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Btype WHERE   Btypeid = @parid
    IF @dbname = 'tbx_Base_Etype' SELECT  @flag = CASE WHEN ESonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Etype WHERE   Etypeid = @parid
    IF @dbname = 'tbx_Base_Dtype' SELECT  @flag = CASE WHEN DSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Dtype WHERE   Dtypeid = @parid
    IF @dbname = 'tbx_Base_Ktype' SELECT  @flag = CASE WHEN KSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Ktype WHERE   Ktypeid = @parid
    
    IF @flag = 1 GOTO nocheckpard

--exec getsysvalue 'iniover', @iniover output 是否开账

    IF @dbname = 'tbx_Base_Ptype' 
    BEGIN
		PRINT '数据检查'
--判断商品是否满足获取ID的条件
--if exists(select 1 from itemSaleDetail where [ptypeid]=@parid)  goto error102
    END

    nocheckpard:
--	计算id号
    SET nocount ON
    IF @dbname = 'tbx_Base_Ptype' DECLARE checkid_cursor CURSOR FOR SELECT  ptypeid ,psonnum ,parid ,soncount ,prec FROM tbx_Base_Ptype WHERE Ptypeid = @parid 
    IF @dbname = 'tbx_Base_Btype' DECLARE checkid_cursor CURSOR FOR SELECT  btypeid ,bsonnum ,parid ,soncount ,brec FROM tbx_Base_Btype WHERE Btypeid = @parid 
    IF @dbname = 'tbx_Base_Etype' DECLARE checkid_cursor CURSOR FOR SELECT  etypeid ,esonnum ,parid ,soncount ,erec FROM tbx_Base_Etype WHERE Etypeid = @parid 
    IF @dbname = 'tbx_Base_Dtype' DECLARE checkid_cursor CURSOR FOR SELECT  dtypeid ,dsonnum ,parid ,soncount ,drec FROM tbx_Base_Dtype WHERE Dtypeid = @parid 
    IF @dbname = 'tbx_Base_Ktype' DECLARE checkid_cursor CURSOR FOR SELECT  ktypeid ,ksonnum ,parid ,soncount ,krec FROM tbx_Base_Ktype WHERE Ktypeid = @parid 
	OPEN checkid_cursor
    FETCH NEXT FROM checkid_cursor INTO @sztypeid, @sonnum, @par, @soncount, @temprec

    SELECT  @nson = @sonnum
    SELECT  @ncount = @soncount
    SELECT  @nparrec = @temprec
	
    IF ( @@fetch_status = -2 )
        OR ( @@fetch_status = -1 ) 
        BEGIN
            CLOSE checkid_cursor
            DEALLOCATE checkid_cursor
            SET @errorValue = '父亲ID号不存在！'
            GOTO ErrorGeneral
        END
    ELSE 
        BEGIN 
            DECLARE @tempid VARCHAR(5) , @nreturn INT
            SELECT  @soncount = @soncount + 1
            EXEC @nreturn= pbx_Fun_TypeIDIntToStr @soncount, @tempid OUT
            IF @nreturn = -1 
                BEGIN
                    CLOSE checkid_cursor
                    DEALLOCATE checkid_cursor
					SET @errorValue = '获取子ID失败，请稍后重试！'
					GOTO ErrorGeneral

                END 
            ELSE 
                BEGIN
                    IF @sztypeid = '00000' 
                        SELECT  @createdid = @tempid
                    ELSE 
                        BEGIN
                            SELECT  @createdid = RTRIM(@sztypeid) + @tempid
                        END
                END
        END

    CLOSE checkid_cursor
    DEALLOCATE checkid_cursor
    GOTO Success
    
    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_Delete') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_Delete
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Base_Delete                                                 
--  ||   过程功能：删除基本信息
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||  	@TypeId	 	varchar(25),                    --ID
--  ||  	@DbName		varchar(50)						--表名                                        
--  ********************************************************************************************

CREATE  PROCEDURE pbx_Base_Delete
    (
      @cTypeid VARCHAR(50) ,
      @cMode VARCHAR(50) ,
      @errorValue VARCHAR(50) OUTPUT --返回错误信息
    )
AS 
    DECLARE @SQL VARCHAR(500)
    DECLARE @GOODS_ID VARCHAR(25)
    DECLARE @dTempQty NUMERIC(22, 10)
    DECLARE @dTempTotal NUMERIC(22, 10)
    DECLARE @sonnum NUMERIC(10)
    DECLARE @parid VARCHAR(50)
    DECLARE @szName VARCHAR(50)
    DECLARE @Iniover VARCHAR(50) 
    DECLARE @szTypeIDTemp VARCHAR(25)
    DECLARE @errorNo INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEmp VARCHAR(50) ,
        @tmpsontypeid VARCHAR(50) ,
        @tmpRstate INT

 -- Select @szName = 'iniover',@UpdateTag=0
 --	EXEC P_HH_GETSYSVALUE @szName, @Iniover output
 
    IF @cMode = 'P'  GOTO DelPtype
    IF @cMode = 'B'  GOTO DelBtype
    IF @cMode = 'E'  GOTO DelEtype
    IF @cMode = 'D'  GOTO DelDtype
    IF @cMode = 'K'  GOTO DelKtype
	
--	检查PTYPE是否能够删除
DelPtype:
	-- 删除库存数量和金额都为0的商品在期初库存及库存表中的记录
    --DELETE FROM IniGoodsStocks WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0
	--DELETE FROM GoodsStocks    WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0

    IF EXISTS ( SELECT  1 FROM tbx_Base_Ptype WHERE   [PTYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Base_Ptype WHERE   [PTYPEID] = @cTypeid AND [PSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Base_Ptype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [PTYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Base_Ptype WHERE   [PTYPEID] = @cTypeid
            SELECT  @SONNUM = [PSONNUM] FROM tbx_Base_Ptype WHERE   [PTYPEID] = @PARID
            
            UPDATE  tbx_Base_Ptype
            SET     [PSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [PTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
            RETURN 0
        END
        
DelBtype:
	IF EXISTS ( SELECT  1 FROM tbx_Base_Btype WHERE   [BTYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Base_Btype WHERE   [BTYPEID] = @cTypeid AND [BSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Base_Btype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [BTYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Base_Btype WHERE   [BTYPEID] = @cTypeid
            SELECT  @SONNUM = [BSONNUM] FROM tbx_Base_Btype WHERE   [BTYPEID] = @PARID
            
            UPDATE  tbx_Base_Btype
            SET     [BSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [BTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
		
            RETURN 0
        END
        
DelEtype:
	IF EXISTS ( SELECT  1 FROM tbx_Base_Etype WHERE   [ETYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Base_Etype WHERE   [ETYPEID] = @cTypeid AND [ESONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Base_Etype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [ETYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Base_Etype WHERE   [ETYPEID] = @cTypeid
            SELECT  @SONNUM = [ESONNUM] FROM tbx_Base_Etype WHERE   [ETYPEID] = @PARID
            
            UPDATE  tbx_Base_Etype
            SET     [ESONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [ETYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
		
            RETURN 0
        END
 
DelDtype:
	IF EXISTS ( SELECT  1 FROM tbx_Base_Dtype WHERE   [DTYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Base_Dtype WHERE   [DTYPEID] = @cTypeid AND [DSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Dase_Etype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [DTYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Base_Dtype WHERE   [DTYPEID] = @cTypeid
            SELECT  @SONNUM = [DSONNUM] FROM tbx_Base_Dtype WHERE   [DTYPEID] = @PARID
            
            UPDATE  tbx_Base_Dtype
            SET     [DSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [DTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
		
            RETURN 0
        END
 
DelKtype:
	IF EXISTS ( SELECT  1 FROM tbx_Base_Ktype WHERE   [KTYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Base_Ktype WHERE   [KTYPEID] = @cTypeid AND [KSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Dase_Ktype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [KTYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Base_Ktype WHERE   [KTYPEID] = @cTypeid
            SELECT  @SONNUM = [KSONNUM] FROM tbx_Base_Ktype WHERE   [KTYPEID] = @PARID
            
            UPDATE  tbx_Base_Ktype
            SET     [KSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [KTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
		
            RETURN 0
        END
                     
	BASEDEL:
		SET @errorValue = '此记录已经被删除！'
		RETURN -1 
	SONERROR:
		SET @errorValue = '此记录已经被分类，不能删除！'
		RETURN -1 
go



IF OBJECT_ID('dbo.pbx_Base_GetBasicData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetBasicData
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Base_GetBasicData                                                 
--  ||   过程功能：得到本地化信息
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cMode 	char(5)		:基本信息类型参数			IN
--  ||            @nUpdateTag 	INTEGER	:根节点更新tag			IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Base_GetBasicData
    (
      @cMode VARCHAR(10) ,
      @nUpdateTag INTEGER
    )
AS 
    IF @cMode = 'I' 
        BEGIN
            SELECT  [ITypeId], [Parid], [Leveal], [ISonnum], [Soncount]
            FROM    tbx_Base_PackageInfo
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
        
    IF @cMode = 'P' 
        BEGIN
            SELECT  [PTypeId], [Parid], [Soncount], [PSonnum], [PUsercode], [PFullname]
            FROM    tbx_Base_Ptype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
        
    IF @cMode = 'B' 
        BEGIN
            SELECT  [BTypeId], [Parid], [Soncount], [BSonnum], [BUsercode], [BFullname]
            FROM    tbx_Base_Btype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'E' 
        BEGIN
            SELECT  [ETypeId], [Parid], [Soncount], [ESonnum], [EUsercode], [EFullname]
            FROM    tbx_Base_Etype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'D' 
        BEGIN
            SELECT  [DTypeId], [Parid], [Soncount], [DSonnum], [DUsercode], [DFullname]
            FROM    tbx_Base_Dtype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'K' 
        BEGIN
            SELECT  [KTypeId], [Parid], [Soncount], [KSonnum], [KUsercode], [KFullname]
            FROM    tbx_Base_Ktype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    RETURN 0

go





IF OBJECT_ID('dbo.pbx_Base_GetGroup') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetGroup
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：p_hh_GetBaseGroup                                                 
--  ||   过程功能：得到基本信息的类别树
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cMode 	char(5)		:基本信息类型参数			IN
--  ||            @szTypeid 	varchar(50)	:根节点Typeid			IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Base_GetGroup
    (
      @cMode VARCHAR(5) ,
      @szTypeid VARCHAR(50) ,
      @OperatorID VARCHAR(25)
    )
AS 
    DECLARE @sql VARCHAR(8000)
    DECLARE @TableStr VARCHAR(200) , @TableWhereStr VARCHAR(200)
    DECLARE @DTableStr VARCHAR(200) , @DTableWhereStr VARCHAR(200)

    IF @cMode = 'I'  --加载包
        BEGIN
            SELECT  *
            FROM    tbx_Base_PackageInfo
            WHERE   Parid = @szTypeid
            ORDER BY RowIndex , ITypeId
        END 
	
    IF @cMode = 'P'  --商品信息
        BEGIN
		    --exec p_hh_GetRightStr 'P','p',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ptype p
			         WHERE  p.PARID = ''' + @szTypeid + ''' and p.deleted = 0 ORDER BY RowIndex, p.ptypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'B'  --单位信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Btype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.btypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'E'  --职员信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Etype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Etypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'D'  --部门信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Dtype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Dtypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'K'  --仓库信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ktype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Ktypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
go





IF OBJECT_ID('dbo.pbx_Base_GetOneInfo') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetOneInfo
go
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：p_hh_getonebaseinfo                                                
--  ||   过程功能：取得基本信息单条记录
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                              输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cmode 	char(5)		:基本信息类型参数			in
--  ||            @sztypeid 	varchar(25)	:节点typeid			in
--  ||=========================================================================================   
--  ||   过程历史：  操作         作者         日期          描述
--  ||            -----------------------------------------------------------------------------
--  ||              alter         mx         2015.03.26   first alter                                     
--  ********************************************************************************************

CREATE     PROCEDURE pbx_Base_GetOneInfo
    (
      @cmode VARCHAR(5) ,
      @sztypeid VARCHAR(50) ,
      @errorValue VARCHAR(50) OUTPUT --返回错误信息
    )
AS 
    DECLARE @rowcount_var INT
--加载包
    IF @cmode = 'I' 
        BEGIN
            SELECT  a.*
            FROM    tbx_Base_PackageInfo a
            WHERE   a.ITypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
        
    IF @cmode = 'P' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Ptype a
            WHERE   a.PTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
        
    IF @cmode = 'B' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Btype a
            WHERE   a.BTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
    IF @cmode = 'E' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Etype a
            WHERE   a.ETypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END 
    IF @cmode = 'D' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Dtype a
            WHERE   a.DTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END   
    IF @cmode = 'K' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Ktype a
            WHERE   a.KTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END   
        
    IF @rowcount_var = 1 
        RETURN 0
    ELSE 
        BEGIN
            SET @errorValue = '该记录已被删除或数据不完整，请检查！'
            RETURN -1           
        END	
go



IF OBJECT_ID('dbo.pbx_Base_InsertB') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertB
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_InsertB                                                
--  ||   过程功能：添加基本信息--单位
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertB
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
	  --上面是基本信息必须的参数
	  @Name VARCHAR(30) ,
      @Address VARCHAR(1000) ,
      @Tel VARCHAR(66) ,
      @EMail VARCHAR(100) ,
      @Contact1 VARCHAR(120) ,--联系人一
      @Contact2 VARCHAR(120) ,--联系人二
      @LinkerTel1 VARCHAR(60) ,--联系电话一
      @LinkerTel2 VARCHAR(60) ,--联系电话二
      @DefEtype VARCHAR(50) ,--默认经手人
      @BankOfDeposit VARCHAR(50) ,--开户银行
      @BankAccounts VARCHAR(50) ,--银行账号
      @PostCode VARCHAR(50) ,--邮政编码
      @Fax VARCHAR(50) ,--传真
      @TaxNumber VARCHAR(50) ,--税号
      @Rtypeid VARCHAR(50) ,--地区
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @RltTypeID VARCHAR(25) OUTPUT , --返回创建的ID
      @errorValue VARCHAR(500) OUTPUT ,--返回错误信息
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(25)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(25)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(25)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Btype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [btypeid]
                        FROM    tbx_Base_Btype
                        WHERE   btypeId <> '00000'
                                AND ( [btypeId] = @typeid_1
                                      OR ( [busercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，不能插入数据！'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Btype
                    WHERE   [btypeId] = @typeid_1
                            AND bsonnum > 0 ) 
            BEGIN
                SET @errorValue = '商品已经存在并且停用!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Btype
    WHERE   [btypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Btype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Btype ( BTypeId, Parid, Leveal, BUsercode, BFullname, BComment, BNamepy, Parrec, RowIndex, Deleted, Updatetag, [Address], Tel, EMail, Contact1, Contact2, LinkerTel1, LinkerTel2, DefEtype, BankOfDeposit, BankAccounts, PostCode, Fax, TaxNumber, Rtypeid, IsStop )
    VALUES  ( @typeid_1, @ParId, @leveal, @UserCode, @FullName, @Comment, @Namepy, @Parrec, @RowIndex, 0, @UpdateTag, @Address, @Tel, @EMail, @Contact1, @Contact2, @LinkerTel1, @LinkerTel2, @DefEtype, @BankOfDeposit, @BankAccounts, @PostCode, @Fax, @TaxNumber, @Rtypeid, 0 )
          
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Btype]
    SET     [bsonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [btypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录的父类数据操作失败，请稍后重试！'
            GOTO ErrorRollback
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_InsertD') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertD
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_InsertE                                                
--  ||   过程功能：添加基本信息--部门
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertD
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
      --上面是基本信息必须的参数
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @RltTypeID VARCHAR(25) OUTPUT , --返回创建的ID
      @errorValue VARCHAR(500) OUTPUT ,--返回错误信息
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(50)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(50)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(50)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Dtype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [Dtypeid]
                        FROM    tbx_Base_Dtype
                        WHERE   DtypeId <> '00000'
                                AND ( [DtypeId] = @typeid_1
                                      OR ( [Dusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，不能插入数据！'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Dtype
                    WHERE   [DtypeId] = @typeid_1
                            AND Dsonnum > 0 ) 
            BEGIN
                SET @errorValue = '部门已经存在并且停用!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Dtype
    WHERE   [Dtypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Dtype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Dtype ( DTypeId, Parid, DSonnum, Soncount, Leveal, DUsercode, DFullname, DComment, Dnamepy, IsStop, Parrec, RowIndex, Deleted, Updatetag )
    VALUES  ( @typeid_1, @ParId, 0, 0, @leveal, @UserCode, @FullName, @Comment, @Namepy, @Isstop, @Parrec, @RowIndex, 0, @UpdateTag )
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Dtype]
    SET     [Dsonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [Dtypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录的父类数据操作失败，请稍后重试！'
            GOTO ErrorRollback
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_InsertE') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertE
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_InsertE                                                
--  ||   过程功能：添加基本信息--职员
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertE
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
      --上面是基本信息必须的参数
      @DTypeId VARCHAR(50) ,--所属部门
      @Tel VARCHAR(20) ,--电话
      @Address VARCHAR(80) ,--地址
      @Birthday VARCHAR(10) ,--生日
      @EMail VARCHAR(100) ,--EMail
      @Job VARCHAR(100) ,--职位
      @TopTotal NUMERIC(22, 10) ,--每单优惠限额
      @LowLimitDiscount NUMERIC(22, 10) ,--最低折扣下限
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @RltTypeID VARCHAR(25) OUTPUT , --返回创建的ID
      @errorValue VARCHAR(500) OUTPUT ,--返回错误信息
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(50)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(50)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(50)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Etype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [Etypeid]
                        FROM    tbx_Base_Etype
                        WHERE   EtypeId <> '00000'
                                AND ( [EtypeId] = @typeid_1
                                      OR ( [Eusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，不能插入数据！'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Etype
                    WHERE   [EtypeId] = @typeid_1
                            AND Esonnum > 0 ) 
            BEGIN
                SET @errorValue = '职员已经存在并且停用!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Etype
    WHERE   [Etypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Etype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Etype ( ETypeId, Parid, ESonnum, Soncount, Leveal, EUsercode, EFullname, EComment, Enamepy, DTypeId, Tel, [Address], Birthday, EMail, Job, TopTotal, LowLimitDiscount, IsStop, Parrec, RowIndex, Deleted, Updatetag )
    VALUES  ( @typeid_1, @ParId, 0, 0, @leveal, @UserCode, @FullName, @Comment, @Namepy, @DTypeId, @Tel, @Address, @Birthday, @EMail, @Job, @TopTotal, @LowLimitDiscount, @Isstop, @Parrec, @RowIndex, 0, @UpdateTag )
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Etype]
    SET     [Esonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [Etypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录的父类数据操作失败，请稍后重试！'
            GOTO ErrorRollback
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_InsertK') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertK
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_InsertK                                                
--  ||   过程功能：添加基本信息--仓库
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertK
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
      --上面是基本信息必须的参数
      @Name VARCHAR(66) ,--简称
      @Address VARCHAR(256) ,--地址
      @Person VARCHAR(100) ,--负责人
      @Tel VARCHAR(50) ,--负责人电话
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @RltTypeID VARCHAR(25) OUTPUT , --返回创建的ID
      @errorValue VARCHAR(50) OUTPUT ,--返回错误信息
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(50)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(50)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(50)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Ktype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [Ktypeid]
                        FROM    tbx_Base_Ktype
                        WHERE   KtypeId <> '00000'
                                AND ( [KtypeId] = @typeid_1
                                      OR ( [Kusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，不能插入数据！'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Ktype
                    WHERE   [KtypeId] = @typeid_1
                            AND Ksonnum > 0 ) 
            BEGIN
                SET @errorValue = '仓库已经存在并且停用!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Ktype
    WHERE   [Ktypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Ktype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Ktype ( KTypeId, Parid, KSonnum, Soncount, Leveal, KUsercode, KFullname, KComment, Knamepy, Name, [Address], Person, Tel, IsStop, Parrec, RowIndex, Deleted, Updatetag )
    VALUES  ( @typeid_1, @ParId, 0, 0, @leveal, @UserCode, @FullName, @Comment, @Namepy, @Name, @Address, @Person, @Tel, @Isstop, @Parrec, @RowIndex, 0, @UpdateTag )
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Ktype]
    SET     [Ksonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [Ktypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录的父类数据操作失败，请稍后重试！'
            GOTO ErrorRollback
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_InsertP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertP
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_InsertP                                                 
--  ||   过程功能：添加基本信息--商品
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertP
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
      --上面是基本信息必须的参数
      @Name VARCHAR(30) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @RltTypeID VARCHAR(25) OUTPUT , --返回创建的ID
      @errorValue VARCHAR(50) OUTPUT ,--返回错误信息
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(50)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(50)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(50)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Ptype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [ptypeid]
                        FROM    tbx_Base_Ptype
                        WHERE   ptypeId <> '00000'
                                AND ( [ptypeId] = @typeid_1
                                      OR ( [pusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，不能插入数据！'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Ptype
                    WHERE   [ptypeId] = @typeid_1
                            AND psonnum > 0 ) 
            BEGIN
                SET @errorValue = '商品已经存在并且停用!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Ptype
    WHERE   [ptypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Ptype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Ptype ( PTypeId, Parid, PSonnum, Soncount, Leveal, PUsercode, PFullname, PComment, pnamepy, [Name], UsefulLifeday, [Standard], [Model], Area, Costmode, IsStop, Parrec, RowIndex, Deleted, Updatetag )
    VALUES  ( @typeid_1, @ParId, 0, 0, @leveal, @UserCode, @FullName, @Comment, @Namepy, @Name, @UsefulLifeday, @Standard, @Model, @Area, @CostMode, @Isstop, @Parrec, @RowIndex, 0, @UpdateTag )
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Ptype]
    SET     [psonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [ptypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录的父类数据操作失败，请稍后重试！'
            GOTO ErrorRollback
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_UpdateB') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateB
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateP                                                 
--  ||   过程功能：修改基本信息--单位                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateB
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数
      @Name VARCHAR(30) ,
      @Address VARCHAR(1000) ,
      @Tel VARCHAR(66) ,
      @EMail VARCHAR(100) ,
      @Contact1 VARCHAR(120) ,--联系人一
      @Contact2 VARCHAR(120) ,--联系人二
      @LinkerTel1 VARCHAR(60) ,--联系电话一
      @LinkerTel2 VARCHAR(60) ,--联系电话二
      @DefEtype VARCHAR(50) ,--默认经手人
      @BankOfDeposit VARCHAR(50) ,--开户银行
      @BankAccounts VARCHAR(50) ,--银行账号
      @PostCode VARCHAR(50) ,--邮政编码
      @Fax VARCHAR(50) ,--传真
      @TaxNumber VARCHAR(50) ,--税号
      @Rtypeid VARCHAR(50) ,--地区
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Btype'

    IF EXISTS ( SELECT  [Busercode]
                FROM    tbx_Base_Btype
                WHERE   BtypeId <> '00000'
                        AND [BtypeId] <> @typeid
                        AND [Busercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @errorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END

    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Btype
    SET     [Parid] = @Parid, [BUsercode] = @UserCode, [BFullname] = @FullName, [BComment] = @Comment, [BNamepy] = @Namepy, 
			[Address] = @Address, [Tel] = @Tel, [EMail] = @EMail, [Contact1] = @Contact1, [Contact2] = @Contact2, 
			[LinkerTel1] = @LinkerTel1, [LinkerTel2] = @LinkerTel2, [DefEtype] = @DefEtype, [BankOfDeposit] = @BankOfDeposit, 
			[BankAccounts] = @BankAccounts, [PostCode] = @PostCode, [Fax] = @Fax, [TaxNumber] = @TaxNumber, 
			[Rtypeid] = Rtypeid, [IsStop] = @IsStop
    WHERE   BTypeId = @typeId 


    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '插入记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_UpdateD') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateD
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateD                                                 
--  ||   过程功能：修改基本信息--部门                                            
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateD
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数 ,
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Dtype'

    IF EXISTS ( SELECT  [Dusercode]
                FROM    tbx_Base_Dtype
                WHERE   DtypeId <> '00000'
                        AND [DtypeId] <> @typeid
                        AND [Dusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存

    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Dtype
    SET     [Parid] = @Parid, [DUsercode] = @UserCode, [DFullname] = @FullName, [DComment] = @Comment, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   DTypeId = @typeId

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_UpdateE') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateE
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateE                                                 
--  ||   过程功能：修改基本信息--职员                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateE
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数 ,
      @DTypeId VARCHAR(50) ,--所属部门
      @Tel VARCHAR(20) ,--电话
      @Address VARCHAR(80) ,--地址
      @Birthday VARCHAR(10) ,--生日
      @EMail VARCHAR(100) ,--EMail
      @Job VARCHAR(100) ,--职位
      @TopTotal NUMERIC(22, 10) ,--每单优惠限额
      @LowLimitDiscount NUMERIC(22, 10) ,--最低折扣下限
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Etype'

    IF EXISTS ( SELECT  [Eusercode]
                FROM    tbx_Base_Etype
                WHERE   EtypeId <> '00000'
                        AND [EtypeId] <> @typeid
                        AND [Eusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存

    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Etype
    SET     [Parid] = @Parid, [EUsercode] = @UserCode, [EFullname] = @FullName, [EComment] = @Comment, 
			[DTypeId] = @DTypeId, [Tel] = @Tel, [Address] = @Address, [Birthday] = @Birthday, 
			[EMail] = @EMail, [Job] = @Job, [TopTotal] = @TopTotal,
			[LowLimitDiscount] = @LowLimitDiscount, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   ETypeId = @typeId
      
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_UpdateK') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateK
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateE                                                 
--  ||   过程功能：修改基本信息--职员                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateK
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数 ,
      @Name VARCHAR(66) ,--简称
      @Address VARCHAR(256) ,--地址
      @Person VARCHAR(100) ,--负责人
      @Tel VARCHAR(50) ,--负责人电话
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Ktype'

    IF EXISTS ( SELECT  [Kusercode]
                FROM    tbx_Base_Ktype
                WHERE   KtypeId <> '00000'
                        AND [KtypeId] <> @typeid
                        AND [Kusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存

    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Ktype
    SET     [Parid] = @Parid, [KUsercode] = @UserCode, [KFullname] = @FullName, [KComment] = @Comment, 
			[Name] = @Name, [Address] = @Address, [Person] = @Person, [Tel] = @Tel, 
			[IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   KTypeId = @typeId
      
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Base_UpdateP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateP
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateP                                                 
--  ||   过程功能：修改基本信息--商品                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateP
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数
      @Name VARCHAR(30) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Ptype'

    IF EXISTS ( SELECT  [Pusercode]
                FROM    tbx_Base_Ptype
                WHERE   PtypeId <> '00000'
                        AND [PtypeId] <> @typeid
                        AND [Pusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存
	
    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Ptype
    SET     [Parid] = @Parid, [PUsercode] = @UserCode, [PFullname] = @FullName, [PComment] = @Comment, [Name] = @Name, [pnamepy] = @Namepy, [Standard] = @Standard, [Model] = @Model, [Area] = @Area, [UsefulLifeday] = @UsefulLifeday, [Costmode] = @CostMode, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   PTypeId = @typeId

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success
	

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Fun_TypeIDIntToStr') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Fun_TypeIDIntToStr
go

CREATE PROCEDURE pbx_Fun_TypeIDIntToStr
    (
      @nInput INT ,
      @szId VARCHAR(5) OUTPUT
    )
AS 
    SET nocount ON

    IF @nInput > 99999 
        BEGIN
            RETURN -1
        END

    DECLARE @sztemp VARCHAR(6)

    SELECT  @sztemp = STR(@nInput) + 100000
    SELECT  @szId = RIGHT(@sztemp, 5)


go



