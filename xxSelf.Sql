IF OBJECT_ID('dbo.Fun_CovToPrice') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovToPrice
go

CREATE   FUNCTION Fun_CovToPrice( @nprice NUMERIC(22, 10) )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @ditPrice INT
        SELECT  @ditPrice = DitDefValue
        FROM    tbx_Sys_DitDef
        WHERE   DitDefName = 'DitPrice'
        RETURN ROUND(@nprice,@ditPrice)
    END
GO



IF OBJECT_ID('dbo.Fun_CovToQty') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovToQty
go

CREATE   FUNCTION Fun_CovToQty ( @nQty NUMERIC(22, 10) )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @ditQty INT
        SELECT  @ditQty = DitDefValue
        FROM    tbx_Sys_DitDef
        WHERE   DitDefName = 'DitQty'
        RETURN ROUND(@nQty,@ditQty)
    END
GO



IF OBJECT_ID('dbo.Fun_CovTotalDivQty') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovTotalDivQty
go
				  
CREATE   FUNCTION Fun_CovTotalDivQty
    (
      @nTotal NUMERIC(22, 10) ,
      @nQty NUMERIC(22, 10)
    )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @nprice NUMERIC(22, 10)
        IF ISNULL(@nQty, 0) = 0
            OR ISNULL(@nTotal, 0) = 0 
            SET @nprice = 0
        ELSE 
            SET @nprice = dbo.pbx_Fun_CovToPrice(CAST(@nTotal AS NUMERIC(22, 10)) / CAST(@nQty AS NUMERIC(22, 10)))
        RETURN @nprice 
    END
GO



IF OBJECT_ID('dbo.Fun_CovToTotal') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovToTotal
go


CREATE   FUNCTION Fun_CovToTotal ( @nTotal NUMERIC(22, 10) )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @ditTotal INT
        SELECT  @ditTotal = DitDefValue
        FROM    tbx_Sys_DitDef
        WHERE   DitDefName = 'DitTotal'
        RETURN ROUND(@nTotal,@ditTotal)
        
    END
GO




IF OBJECT_ID('dbo.Fun_SplitStr') IS NOT NULL 
    DROP FUNCTION dbo.Fun_SplitStr
go


CREATE FUNCTION Fun_SplitStr
    (
      @Str VARCHAR(8000) ,   --待分拆的字符串
      @Split VARCHAR(10)     --数据分隔符
    )
RETURNS @Re TABLE
    (
      ID INT IDENTITY ,
      Col VARCHAR(8000)
    )
AS 
    BEGIN
        DECLARE @SplitLen INT
        SET @SplitLen = LEN(@Split + 'a') - 2
        WHILE CHARINDEX(@Split, @Str) > 0 
            BEGIN
                INSERT  @re
                VALUES  ( LEFT(@Str, CHARINDEX(@Split, @Str) - 1) )
                SET @Str = STUFF(@Str, 1, CHARINDEX(@Split, @Str) + @SplitLen, '')
            END
        INSERT  @re
        VALUES  ( @Str )
        RETURN
    END

go




IF OBJECT_ID('dbo.Fun_StrToNumeric') IS NOT NULL 
    DROP FUNCTION dbo.Fun_StrToNumeric
go

CREATE   FUNCTION Fun_StrToNumeric
    (
      @StrValues VARCHAR(8000) ,
      @DefValues NUMERIC(22, 10)
    )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        RETURN CAST(ISNULL(@StrValues, @DefValues) AS NUMERIC(22, 10))
    END
GO



IF OBJECT_ID('dbo.Fun_TypeIDIntToStr') IS NOT NULL 
    DROP PROCEDURE dbo.Fun_TypeIDIntToStr
go

CREATE PROCEDURE Fun_TypeIDIntToStr
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



IF OBJECT_ID('dbo.pbx_A_Qry_Balance') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_A_Qry_Balance
GO

--查询付款或收款单的结算的单据

CREATE PROCEDURE pbx_A_Qry_Balance
    (
      @BTypeID VARCHAR(50) ,
      @ETypeID VARCHAR(50) ,
      @StartDate VARCHAR(10) ,
      @EndDate VARCHAR(10) ,
      @VchType INT ,
      @OperatorID VARCHAR(50)
    )
AS 
    DECLARE @sql VARCHAR(8000)
    
    IF @VchType = 7 
        BEGIN
            SET @SQL = 'SELECT  m.VchType, m.VchCode, m.Number, m.Summary, m.InputDate, m.Total JETotal, (m.Total - g.gTotal) YETotal, 0 IsSelect
					FROM    dbo.tbx_Bill_M m
							LEFT JOIN ( SELECT  VchCode, VchType, SUM(Total) gTotal
								FROM    dbo.tbx_Bill_A_Gathering
								GROUP BY VchCode, VchType
							  ) g ON m.VchCode = g.VchCode
									 AND m.VchType = g.VchType
					WHERE   m.Draft = 2 AND m.RedOld = ''F'' AND m.VchType = 3 AND m.BtypeId = ' + @BTypeID
            PRINT ( @SQL )
        END
    ELSE IF @VchType = 6 
        BEGIN
            SET @SQL = 'SELECT  m.VchType, m.VchCode, m.Number, m.Summary, m.InputDate, m.Total JETotal, (m.Total - g.gTotal) YETotal, 0 IsSelect
				FROM    dbo.tbx_Bill_M m
						LEFT JOIN ( SELECT  VchCode, VchType, SUM(Total) gTotal
							FROM    dbo.tbx_Bill_A_Gathering
							GROUP BY VchCode, VchType
						  ) g ON m.VchCode = g.VchCode
								 AND m.VchType = g.VchType
				WHERE   m.Draft = 2 AND m.RedOld = ''F'' AND m.VchType = 4 AND m.BtypeId = ' + @BTypeID
            PRINT ( @SQL )
        END
    EXEC(@SQL)
GO



IF OBJECT_ID('dbo.pbx_A_Save_Gathering') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_A_Save_Gathering
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_A_Save_Gathering
--  ||   过程功能：一条付款单或收款单的结算对应的单据
--  ||=========================================================================================

CREATE    PROCEDURE pbx_A_Save_Gathering
    (
      @BTypeID VARCHAR(50) ,
      @VchCode INT ,
      @VchType INT ,
      @GatheringVchCode INT ,
      @Total NUMERIC(22, 10) ,
      @DoTypt INT , --操作类型，1插入，2修改，3根据@GatheringVchCode删除
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF ( @DoTypt = 1 ) 
        BEGIN
            INSERT  INTO dbo.tbx_Bill_A_Gathering ( BtypeId, VchCode, VchType, GatheringVchCode, Total )
            VALUES  ( @BTypeID, @VchCode, @VchType, @GatheringVchCode, @Total )
        END
        
    IF ( @DoTypt = 2 ) 
        BEGIN
            UPDATE  dbo.tbx_Bill_A_Gathering
            SET     Total = @Total
            WHERE   VchCode = @VchCode
                    AND GatheringVchCode = @GatheringVchCode
        END
        
    IF ( @DoTypt = 3 ) 
        BEGIN
            DELETE  dbo.tbx_Bill_A_Gathering
            WHERE   GatheringVchCode = @GatheringVchCode
        END
        
    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



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
            EXEC @nreturn= Fun_TypeIDIntToStr @soncount, @tempid OUT
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
    IF @cMode = 'V' 
        BEGIN
            SELECT  [VTypeId], [Parid], [Soncount], [VSonnum], [VUsercode], [VFullname]
            FROM    tbx_Base_Vtype
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
    IF @cMode = 'V'  --单据信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Vtype b
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
      @RltTypeID VARCHAR(50) OUTPUT , --返回创建的ID
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
      @RltTypeID VARCHAR(50) OUTPUT , --返回创建的ID
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
      @RltTypeID VARCHAR(50) OUTPUT , --返回创建的ID
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
      @RltTypeID VARCHAR(50) OUTPUT , --返回创建的ID
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
      @RltTypeID VARCHAR(50) OUTPUT , --返回创建的ID
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



IF OBJECT_ID('dbo.pbx_Base_SavePTypeUnit') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_SavePTypeUnit
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_SavePTypeUnit                                                
--  ||   过程功能：保存商品的多单位信息
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_SavePTypeUnit
    (
      @PTypeId VARCHAR(50) ,
      @UnitName VARCHAR(10) ,
      @URate NUMERIC(22, 10) ,
      @IsBase INT ,
      @BarCode VARCHAR(60) ,
      @Comment VARCHAR(200) ,
      @OrdId VARCHAR(21) ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET nocount ON
        
    --IF @IsStop = 1 
    --    IF EXISTS ( SELECT  1
    --                FROM    tbx_Base_Btype
    --                WHERE   [btypeId] = @typeid_1
    --                        AND bsonnum > 0 ) 
    --        BEGIN
    --            SET @errorValue = '商品已经存在并且停用!'
    --            GOTO ErrorGeneral
    --        END
   
    IF EXISTS ( SELECT  1
                FROM    tbx_Base_PtypeUnit
                WHERE   PTypeId = @PTypeId
                        AND OrdId = @OrdId ) 
        BEGIN
            UPDATE  dbo.tbx_Base_PtypeUnit
            SET     UnitName = @UnitName, URate = @URate, IsBase = @IsBase, BarCode = @BarCode, Comment = @Comment
            WHERE   PTypeId = @PTypeId
                    AND OrdId = @OrdId
        END
    ELSE 
        BEGIN
            INSERT  dbo.tbx_Base_PtypeUnit ( PTypeId, UnitName, URate, IsBase, BarCode, Comment, OrdId )
            VALUES  ( @PTypeId, @UnitName, @URate, @IsBase, @BarCode, @Comment, @OrdId )	
        END


    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
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



IF OBJECT_ID('dbo.pbx_Bill_ClearSaveCreate') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_ClearSaveCreate
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_ClearSaveCreate                                                
--  ||   过程功能：保存单据过程中失败的时候删除以前保存的数据
--  ********************************************************************************************

CREATE    PROCEDURE [pbx_Bill_ClearSaveCreate]
    (
      @PRODUCT_TRADE INT ,
      @Modi INT ,
      @VchType INT ,
      @NewVchCode INT ,
      @OldVchCode INT   
   
    )
AS 
    IF @NewVCHCODE = 0 
        RETURN 0

    BEGIN TRAN DelBak

    IF @VchType IN ( 1, 2 ) --进货订单，销售订单
        BEGIN
            DELETE  FROM tbx_Bill_Order_M
            WHERE   VchCode = @NewVchCode
	
            DELETE  FROM dbo.tbx_Bill_Order_D
            WHERE   VchCode = @NewVchCode	
        END
    ELSE 
        IF @VchType IN ( 3, 4 ) --进货单，销售单
            BEGIN
                DELETE  FROM tbx_Bill_M
                WHERE   VchCode = @NewVchCode
	
                DELETE  FROM dbo.tbx_Bill_D_Bak
                WHERE   VchCode = @NewVchCode	
            END


    COMMIT TRAN DelBak

Go



IF OBJECT_ID('dbo.pbx_Bill_Create') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Create
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Create                                                
--  ||   过程功能：进货单，者销售单等单据通用过账
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_Create
    (
      @OldVchCode INT ,
      @NewVchCode INT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT 
    DECLARE @GOODS_ID VARCHAR(50) 
    DECLARE @AP_ID VARCHAR(50) 
    DECLARE @AR_ID VARCHAR(50) 
    DECLARE @SALE_INCOME_ID VARCHAR(50) 
    DECLARE @SALE_COST_ID VARCHAR(50) 
    
    DECLARE @modiDly CHAR(1)
    DECLARE @YPratypeid VARCHAR(50)
    DECLARE @flag INT
    DECLARE @execsql VARCHAR(8000)
    DECLARE @InitOver INT
    
    DECLARE @aVchType INT,
		@aColRowNo INT ,
        @aCostmode INT ,
        @aUnit INT ,
        @aGoodsNo INT ,
        @aOrderVchType INT ,
        @aOrderCode INT ,
        @aOrderDlyCode INT ,
        @aPStutas INT ,
        @aYearPeriod INT
          
    DECLARE @aAtypeId VARCHAR(50) ,
        @aBtypeId VARCHAR(50) ,
        @aEtypeId VARCHAR(50) ,
        @aDtypeId VARCHAR(50) ,
        @aKtypeId VARCHAR(50) ,
        @aKtypeId2 VARCHAR(50) ,
        @aPtypeId VARCHAR(50) ,
        @aBlockNo VARCHAR(20) ,
        @aProDate VARCHAR(10) ,
        @aUsefulEndDate VARCHAR(10) ,
        @aJhDate VARCHAR(50)
          
    DECLARE @aUnitRate NUMERIC(22, 10) ,
        @aQty NUMERIC(22, 10) ,
        @aPrice NUMERIC(22, 10) ,
        @aTotal NUMERIC(22, 10) ,
        @aDisCount NUMERIC(22, 10) ,
        @aDisCountPrice NUMERIC(22, 10) ,
        @aDisCountTotal NUMERIC(22, 10) ,
        @aTaxRate NUMERIC(22, 10) ,
        @aTaxPrice NUMERIC(22, 10) ,
        @aTaxTotal NUMERIC(22, 10) ,
        @aAssQty NUMERIC(22, 10) ,
        @aAssPrice NUMERIC(22, 10) ,
        @aAssDiscountPrice NUMERIC(22, 10) ,
        @aAssTaxPrice NUMERIC(22, 10) ,
        @aCostPrice NUMERIC(22, 10) ,
        @aCostTotal NUMERIC(22, 10) ,
        @aToQty NUMERIC(22, 10) ,
        @aRedword CHAR(2) ,
        @aInputDate VARCHAR(10) ,
        @aPeriod SMALLINT ,
        @aUsedType CHAR(1) ,
        @aComment VARCHAR(256),
        @aMTotal NUMERIC(22, 10)

    SELECT  @GOODS_ID = '0000100001'
    SELECT  @AP_ID = '0000200001'
    SELECT  @AR_ID = '0000100005'
    SELECT  @SALE_INCOME_ID = '0000300001'
    SELECT  @SALE_COST_ID = '0000400001'
    
    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    SELECT  @aPeriod = 1
    SELECT @aYearPeriod = 1    
    
    SELECT  @aVchType = VchType, @aInputDate= InputDate 
    FROM    dbo.tbx_Bill_M
    WHERE   VchCode = @NewvchCode
    
    IF ISNULL(@aVchType, -1) = -1
    BEGIN
		SET @ErrorValue='单据不存在或者删除，不能过账！'
		GOTO ErrorGeneral 	
    END
    
    SELECT  @InitOver = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = 'InitOver'
    
    IF ISNULL(@InitOver, 0) <> 1
    BEGIN
		SET @ErrorValue='没有开账，不能过账！'
		GOTO ErrorGeneral 	
    END
    
    
    SET @nRet = 0
    SET @aMTotal = 0
    BEGIN TRAN Account
------------------------------进货单---------------------------
    IF @aVchType = 3 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, BtypeId, EtypeId, DtypeId, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate, Costmode, Comment
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aBTypeID, @aETypeID, @aDtypeId, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                        
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, @aBTypeID, @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Buy_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate ,Costmode, Comment)
                    VALUES  ( @NewVchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                    
                    SET @aMTotal = @aMTotal + @aTotal     
                END --cursor while end
               
            --库存商品增加
			IF  @aMTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @GOODS_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aMTotal, @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
			--应收应付
			IF  @aMTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @AP_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aMTotal, @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal, InvoceTag = 0
            WHERE   VchCode = @NewVchCode
                
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------进货单处理结束----------------------

------------------------------销售单------------------------------
    IF @aVchType = 4 
        BEGIN
			DECLARE @aSumCostTotal NUMERIC(22, 10)
			SET @aSumCostTotal = 0
			 
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, BtypeId, EtypeId, DtypeId, PTypeID, KTypeID, Qty, Price, Total, CostTotal, Blockno, Prodate, Unit, UnitRate, Costmode, Comment
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aBTypeID, @aETypeID, @aDtypeId, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aCostTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                    
                    SET @aMTotal = @aMTotal + @aTotal   
                     
                    SET @aCostTotal = -@aCostTotal
                    SET @aQty = -@aQty
                    SET @aTotal = -@aTotal 
                    
                    SET @aSumCostTotal = @aSumCostTotal + @aCostTotal 
                    
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, @aBTypeID, @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Sale_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment, UsedType)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment, '')
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                        
                END --cursor while end
                
			--库存商品减少
			IF  @aSumCostTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @GOODS_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aSumCostTotal, @aInputDate )
				IF @@rowcount <= 0
				BEGIN
					SET @ErrorValue = '插入库存商品科目明细失败！'
					GOTO ErrorRollback	
				END 
			END 
			
			--销售收入
			IF  @aMTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @SALE_INCOME_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aMTotal, @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
			--销售成本
			IF ABS(@aSumCostTotal) <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @SALE_COST_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, ABS(@aSumCostTotal), @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
			--应收应付
			IF  @aMTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @AR_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aMTotal, @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
            UPDATE  dbo.tbx_Bill_M
            SET     Total = ABS(@aMTotal)
            WHERE   VchCode = @NewVchCode
            
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------销售单处理结束--------------------------

------------------------------调拨单------------------------------
    IF @aVchType = 5 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, BtypeId, EtypeId, DtypeId, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate, Costmode, Comment, KtypeId2
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aBTypeID, @aETypeID, @aDtypeId, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment, @aKtypeId2
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                    
                    SET @aQty = -@aQty
                    
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Other_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, KtypeId2, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aKtypeId2, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                    
                    IF @aCostmode IN ( 1, 2 ) --如果是先进先出或后进先出,用此方法
                        BEGIN
                            PRINT '先进先出或后进先出过账未实现'
                        END
                    ELSE 
                        BEGIN
                            SET @aQty = -@aQty
                            
							EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKtypeId2, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
							IF @nRet < 0 
								GOTO ErrorRollback
						END
						
                    INSERT dbo.tbx_Bill_Other_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, KtypeId2, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment, UsedType)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aKtypeId2, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment, '')
					
					SET @aMTotal = @aMTotal + @aTotal    
                END --cursor while end
			
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal
            WHERE   VchCode = @NewVchCode
            
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------调拨单处理结束--------------------------
------------------------------付款单---------------------------
    IF @aVchType = 7 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, BTypeID, ETypeID, DTypeID, KtypeId, Total, Comment
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aTotal, @aComment
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                        
                    INSERT dbo.tbx_Bill_A_D ( VchCode, VchType, ColRowNo, AtypeId, BtypeId, EtypeId, DtypeId, Total, Comment )
                    VALUES  ( @NewVchCode, @aVchType, @aColRowNo, @aATypeID, @aBTypeID, @aETypeID, @aDTypeID, @aTotal, @aComment)
                        
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                    
                    SET @aMTotal = @aMTotal + @aTotal     
                END --cursor while end
                
			--应付款减少
			IF  @aMTotal <> 0 
			BEGIN
				INSERT  INTO  dbo.tbx_Bill_A_D( VchCode, VchType, AtypeId, BtypeId, EtypeId, DtypeId, KtypeId, Total, InputDate )
				VALUES  ( @NewVchCode, @aVchType, @AP_ID, @aBTypeID, @aETypeID, @aDTypeID, @aKTypeID, @aMTotal, @aInputDate )
				IF @@rowcount <= 0 
					GOTO ErrorRollback
			END 
			
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal
            WHERE   VchCode = @NewVchCode
                
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------付款单处理结束----------------------

	SET @ErrorValue = '没有找到单据类型！'
	GOTO ErrorRollback 
		    
    Success:		 --成功完成函数
    RETURN 0
    
-----对科目类型进行过帐
    Finish:
		--SET @nRet = 0
		--SELECT  @execsql = 'declare AccountDly_cursor cursor for ' + ' select ATypeID, BTypeID,Total from dlya  where  Vchcode= ' + CAST(@nVchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) 
		--EXEC (@execsql)
		--OPEN AccountDly_cursor
		--FETCH NEXT FROM AccountDly_cursor INTO @szATypeID, @szBTypeID, @dTotal
		--WHILE @@FETCH_STATUS = 0 
		--	BEGIN

		--		IF @szATypeID <> '' 
		--			BEGIN
		--				EXEC @nRet = ModifyDbf @nVchType, @nVchcode, 0, @tDate, 0, @szATypeID, '', @szBTypeID, @szETypeID, '', @nPeriod, @dTotal, @dTotal, '', '', 0, @dTemp OUTPUT, @Unit, @dUnitRate, 0
		--				IF @nRet < 0 
		--					GOTO errorA
		--			END
		--		FETCH NEXT FROM AccountDly_cursor INTO @szATypeID, @szBTypeID, @dTotal
		--	END
		--CLOSE AccountDly_cursor
		--DEALLOCATE AccountDly_cursor

		UPDATE  dbo.tbx_Bill_M
		SET     Draft = 2, Period = @aPeriod, YearPeriod = @aYearPeriod
		WHERE   vchcode = @NewVchCode
		IF @@rowcount <= 0 
		BEGIN
			SET @ErrorValue = '更新过账标志出错'
			GOTO ErrorRollback	
		END

	   DELETE   FROM tbx_Bill_D_Bak
	   WHERE    VchCode = @NewVchCode
	   
    COMMIT TRAN Account
        	   	
    RETURN @nRet
    
    ErrorGeneral:    --检查数据是错误，不需要回滚

    EXEC dbo.pbx_Bill_ClearSaveCreate 0, 0, @aVchType, @NewVchCode, @OldVchCode

    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN Account 

    EXEC dbo.pbx_Bill_ClearSaveCreate 0, 0, @aVchType, @NewVchCode, @OldVchCode

    RETURN -2 

GO 



IF OBJECT_ID('dbo.pbx_Bill_CreateDraft') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_CreateDraft
go

CREATE PROCEDURE dbo.pbx_Bill_CreateDraft
    (
      @ModiDly INT , --是否是修改单据 0 否，1 是
      @ADraft INT , --3 存草稿，2过账
      @OldVchCode INT ,
      @NewVchCode INT OUT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @net INT ,
        @smode CHAR ,
        @szSql NVARCHAR(4000) ,
        @Stab VARCHAR(50) ,
        @Stabndx VARCHAR(50) ,
        @inputNo VARCHAR(50)
    DECLARE @vchtype INT

    DECLARE @SYS_SALEAR_LIMIT INT
    DECLARE @dLimit NUMERIC(22, 10) ,
        @dAr NUMERIC(22, 10) ,
        @dArdly NUMERIC(22, 10) ,
        @dTemp NUMERIC(22, 10)

    DECLARE @ModiVchcode VARCHAR(50)
    DECLARE @szDtypeid VARCHAR(50) ,
        @szKTypeID2 VARCHAR(50) ,
        @szgatherbtypeid VARCHAR(50) ,
        @feebtypeid VARCHAR(50) ,
        @szzctypeid VARCHAR(50)

    BEGIN TRAN updata
    
	UPDATE  dbo.tbx_Bill_M
	SET     Draft = 1
	WHERE   VchCode = @NewVchCode
		
    COMMIT TRAN updata

    SET @net = 0


    RETURN @net

    ErrorGeneral:    --检查数据是错误，不需要回滚
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN Account 
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode
    RETURN -2 

go
GO
GO



IF OBJECT_ID('dbo.pbx_Bill_Is_Allot_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Allot_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Allot_D                                               
--  ||   过程功能：添加调拨单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Allot_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'


    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_D_Bak

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_D_Bak
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_D_Bak
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go



IF OBJECT_ID('dbo.pbx_Bill_Is_Allot_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Allot_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Allot_M                                                
--  ||   过程功能：添加调拨单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Allot_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go



IF OBJECT_ID('dbo.pbx_Bill_Is_Buy_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Buy_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Buy_D                                               
--  ||   过程功能：添加进货单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Buy_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'

	SELECT @Ret = -1
	
    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_D_Bak

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_D_Bak
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_D_Bak
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go



IF OBJECT_ID('dbo.pbx_Bill_Is_Buy_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Buy_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Buy_M                                                
--  ||   过程功能：添加进货单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Buy_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go



IF OBJECT_ID('dbo.pbx_Bill_Is_Order_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Order_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Order_D                                               
--  ||   过程功能：添加订单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Order_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'


    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_Order_D

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_Order_D
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
				WHERE   szRowId.col <> ''
				ORDER BY szRowId.Id

    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_Order_D
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go



IF OBJECT_ID('dbo.pbx_Bill_Is_Order_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Order_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Order_M                                                
--  ||   过程功能：添加订单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Order_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_Order_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go



IF OBJECT_ID('dbo.pbx_Bill_Is_PRMoney_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_PRMoney_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_PRMoney_D                                               
--  ||   过程功能：添加收付款单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_PRMoney_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'

	SELECT @Ret = -1
	
    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_D_Bak

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_D_Bak
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

	IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_D_Bak
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go



IF OBJECT_ID('dbo.pbx_Bill_Is_PRMoney_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_PRMoney_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_PRMoney_M                                                
--  ||   过程功能：添加收付款单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_PRMoney_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go



IF OBJECT_ID('dbo.pbx_Bill_Is_Sale_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Sale_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Sale_D                                               
--  ||   过程功能：添加销售单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Sale_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'


    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_D_Bak

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_D_Bak
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

	IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_D_Bak
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go



IF OBJECT_ID('dbo.pbx_Bill_Is_Sale_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Sale_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Sale_M                                                
--  ||   过程功能：添加销售单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Sale_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go



IF OBJECT_ID('dbo.pbx_Bill_Load_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Load_D
go

--单据查询明细

CREATE PROCEDURE pbx_Bill_Load_D
    (
      @VchType INT ,
      @VchCode INT ,
      @BillState INT --单据是否过账等状态
    )
AS 
    SET NOCOUNT ON
	
    DECLARE @DBTable VARCHAR(50) ,
        @SQL VARCHAR(8000)
      
    IF @VchType IN ( 1, 2 ) --订单
        BEGIN
            SET @DBTable = 'tbx_Bill_Order_D'	
        END
    ELSE 
        BEGIN
            IF @BillState <> 3 
                BEGIN
                    SET @DBTable = 'tbx_Bill_D_Bak'	
                END
            ELSE 
                BEGIN
                    IF @VchType = 3 
                        BEGIN
                            SET @DBTable = 'tbx_Bill_Buy_D'	
                        END
                    ELSE 
                        IF @VchType = 4 
                            BEGIN
                                SET @DBTable = 'tbx_Bill_Sale_D'	
                            END
                END
        END
    SET @SQL = 'SELECT  *
                FROM    ' + @DBTable + ' d
                        LEFT JOIN dbo.tbx_Base_Ptype p ON d.PtypeId = p.PTypeId
                WHERE   d.VchCode = ' + CAST(@VchCode AS VARCHAR(20)) + '
                ORDER BY d.DlyOrder '
    EXEC (@SQL)
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Bill_Load_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Load_M
go

--装入一条单据主表内容

CREATE PROCEDURE pbx_Bill_Load_M
    (
      @VchCode INT ,
      @VchType INT
    )
AS 
    SET NOCOUNT ON

    IF @VchType IN ( 1, 2 ) --订单
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Bill_Order_M
            WHERE   VchCode = @VchCode
                    AND VchType = @VchType 
        END
    ELSE 
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Bill_M
            WHERE   VchCode = @VchCode
                    AND VchType = @VchType 
        END
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Bill_ModifyDbf') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_ModifyDbf
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_ModifyDbf                                                
--  ||   过程功能：通用修改库存数据
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_ModifyDbf
    (
      @nVchType INT ,
      @nVchCode INT ,
      @szatypeid VARCHAR(25) ,
      @szptypeid VARCHAR(25) ,
      @szbtypeid VARCHAR(25) ,
      @szetypeid VARCHAR(25) ,
      @szktypeid VARCHAR(25) ,
      @szperiod VARCHAR(2) ,--00为期初，其它为当前
      @dQty NUMERIC(22, 10) ,
      @dTotal NUMERIC(22, 10) ,
      @szBlockno VARCHAR(20) ,
      @szProdate VARCHAR(20) ,
      @nGoodsNo INT ,
      @nUcode INT ,
      @dURate NUMERIC(22, 10) ,		
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT ,
        @inputNo VARCHAR(50) ,
        @GoodsDate VARCHAR(50)
        
    DECLARE @Costmode INT 
-------Costing  method------------
    DECLARE @AVERAGE SMALLINT
    DECLARE @FIFO SMALLINT
    DECLARE @LIFO SMALLINT
    DECLARE @HAND SMALLINT

    SELECT  @AVERAGE = 0
    SELECT  @FIFO = 1
    SELECT  @LIFO = 2
    SELECT  @HAND = 3
---------------------
    DECLARE @szJobNumber VARCHAR(20) ,
        @OutFactoryDate VARCHAR(10) 

    DECLARE @dTotaltemp NUMERIC(22, 10) ,
        @dQtytemp NUMERIC(22, 10) ,
        @dCostTotaltemp NUMERIC(22, 10) ,
        @dCostQtytemp NUMERIC(22, 10) ,
        @dPricetemp NUMERIC(22, 10) ,
        @dCostPricetemp NUMERIC(22, 10) ,
        @nPeriod INT ,
        @nGoodsNoTemp INT ,
        @TotalTemp NUMERIC(22, 10) ,
        @dCostTotalOut NUMERIC(22, 10) --成本金额结果输出
        
    DECLARE @goodsorderId INTEGER ,
        @UpdategoodsorderId INTEGER
     
    SELECT @GoodsDate = CONVERT(varchar(100), GETDATE(), 21)
    
    DECLARE @nInputZero INT    
    SET @nInputZero = 0 --如果是出库单据,表示是否0成本强制出库 0 不是, 1 是;如果是入库，则此标志表示是否采用0单价入库 0 不是, 1 是(此时用于获赠单)
    
    SET @goodsorderId = 0
    SET @dCostTotalOut = 0 
    
    SELECT  @Costmode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @szptypeid
	
    SELECT  @dTotaltemp = 0, @dQtytemp = 0, @dCostTotaltemp = 0, @dCostQtytemp = 0, @dPricetemp = 0, @dCostPricetemp = 0
	
    IF @szperiod <> '00' --开账后
        BEGIN
            IF @Costmode = @AVERAGE 
                BEGIN
                    IF @dQty = 0 
                        BEGIN
                            SET @ErrorValue = '数量为0'
                            GOTO ErrorGeneral
                        END
                        
                    DECLARE ModIFyDbf_CURSOR CURSOR
                    FOR
                        SELECT  goodsorderID, qty, price, total, jobnumber, OutFactoryDate, GoodsOrder, goodsorderId
                        FROM    dbo.tbx_Stock_Goods
                        WHERE   ptypeid = @szptypeid
                                AND ktypeid = @szktypeid  

                    OPEN  ModIFyDbf_CURSOR
                    FETCH NEXT  FROM ModIFyDbf_CURSOR  INTO @goodsorderID, @dCostQtytemp, @dCostPricetemp, @dCostTotaltemp, @szJobNumber, @OutFactoryDate, @nGoodsNoTemp, @UpdategoodsorderId
                    IF @@FETCH_STATUS = 0 
                        BEGIN
                            IF @dQty < 0  --出库
                                BEGIN
                                    IF @dTotal <> 0  --出库，有出库金额
                                        BEGIN
                                            IF @dCostQtytemp < ABS(@dQty) 
                                                BEGIN
                                                    SET @ErrorValue = '当前库存数量不足'
                                                    GOTO ErrorCloseCursor
                                                END	
                                            SELECT  @dTotaltemp = @dCostTotaltemp + @dTotal
                                            SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                            
                                            IF @dQtytemp = 0
                                                AND @dTotalTemp = 0 
                                                BEGIN
                                                    DELETE  FROM tbx_Stock_Goods
                                                    WHERE   goodsorderId = @UpdategoodsorderId                
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec	
                                                END
                                            ELSE 
                                                BEGIN
                                                    SELECT  @dCostPricetemp = 0
                                                    IF @dQtytemp <> 0 
                                                        SELECT  @dCostPricetemp = dbo.pbx_Fun_CovToPrice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))
	    
                                                    UPDATE  tbx_Stock_Goods
                                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = dbo.pbx_Fun_CovToPrice(@dCostPriceTemp)
                                                    WHERE   goodsorderId = @UpdategoodsorderId
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec	
         
                                                END
                                                
                                            --库存变动 dlyorder暂填0，等有了后再填
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec	
                                            SELECT  @dCostTotalOut = @dTotal
                                            GOTO Success
                                        END
                                    ELSE --出库无出库金额
                                        BEGIN
                                            IF @dCostQtytemp = ABS(@dQty) --库存数量等于出库数量时
                                                BEGIN
                                                    IF ( ( @dCosttotaltemp > 0 )
                                                         AND ( @nInputZero = 0 )
                                                       )
                                                        OR --库存成本大于0,并且不0成本强制出库
                                                        ( @dCosttotaltemp = 0 ) --库存成本等于0且允许0成本出库时  
                                                        BEGIN
                                                            DELETE  FROM tbx_Stock_Goods
                                                            WHERE   goodsorderId = @UpdategoodsorderId                
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                        
															--库存变动 dlyorder暂填0，等有了后再填
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, -1 * Dbo.Fun_CovTotalDivQty(@dCosttotaltemp, @dQty), -1 * @dCosttotaltemp, @GoodsDate )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                            SELECT  @dCostTotalOut = -@dCostTotaltemp
                                                            GOTO Success     
                                                        END	
                                                    ELSE --@dCosttotaltemp< = 数量和金额反号 或0成本强制出库
                                                        BEGIN 
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dTotaltemp = 0--0成本强制出库
                                                            ELSE --成本异常,取最近进价
                                                                        --BEGIN							
                                                                        --    SELECT  @dTotaltemp = recprice
                                                                        --    FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)				
                                                                        --    SET @dTotaltemp = @dTotaltemp / @dURate
                                                                        --    SET @dTotaltemp = dbo.f_CovToTotal(CAST(@dQty AS NUMERIC(22, 10)) * CAST(@dTotaltemp AS NUMERIC(22, 10)))
                                                                        --    IF ( @dTotaltemp > = 0 ) 
                                                                        --        GOTO ErrorInputCostPric --最近进价为0
                                                                        --END
                                                                SELECT  @dTotaltemp = @dCostTotaltemp + @dTotaltemp
                                                            SELECT  @dQtytemp = @dCostQtytemp + @dQty--0	
                                                                    
                                                                                                                                        
                                                            UPDATE  tbx_Stock_Goods
                                                            SET     total = @dTotaltemp, qty = @dQtytemp, price = 0
                                                            WHERE   goodsorderId = @UpdategoodsorderId
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                                
															--库存变动 dlyorder暂填0，等有了后再填
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(( @dTotaltemp - @dCosttotaltemp ), @dQty), ( @dTotaltemp - @dCosttotaltemp ), @GoodsDate )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                            SELECT  @dCostTotalOut = @dTotaltemp - @dCosttotaltemp
                                                            GOTO Success
                                                        END
                                                END
                                            ELSE 
                                                BEGIN
                                                    IF @dCostQtytemp < ABS(@dQty) --库存数量小于出库数量 
                                                        BEGIN
                                                            SET @ErrorValue = '当前库存数量不足'
                                                            GOTO ErrorCloseCursor
                                                        END	
                                                    IF ( ( @dCostQtytemp > 0 )
                                                         AND ( @dCosttotaltemp = 0 )
                                                       ) 
                                                        SELECT  @dCostPricetemp = 0
                                                    ELSE 
                                                        BEGIN
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dCostPricetemp = 0 --强制出库
                                                            --ELSE 
                                                            --    BEGIN
                                                            --        IF @dCostQtytemp = 0
                                                            --            OR @dCosttotaltemp = 0 
                                                            --            BEGIN
                                                            --                IF ( @nVchtype = @CHANGE_PRICE_VCHTYPE ) 
                                                            --                    SELECT  @dCostPricetemp = 0
                                                            --                ELSE 
                                                            --                    BEGIN							
                                                            --                        SELECT  @dCostPricetemp = recprice
                                                            --                        FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)
                                                            --                        SET @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostPricetemp AS NUMERIC(22, 10)) / CAST(@dURate AS NUMERIC(22, 10)))
                                                            --                    END
                                                            --            END
                                                            --        ELSE 
                                                            --            SELECT  @dCostPricetemp = dbo.f_CovToPrice(CAST(@dCostTotaltemp AS NUMERIC(22, 10)) / CAST(@dCostQtyTemp AS NUMERIC(22, 10)))
                                                            --        IF ( @dCostPricetemp <= 0 )
                                                            --            AND ( @nVchtype <> @CHANGE_PRICE_VCHTYPE ) 
                                                            --            GOTO errorInputCostPrice --成本价为负或0
                                                            --    END   	
                                                        END
                                                        
                                                    SELECT  @dCostTotalOut = dbo.Fun_CovToTotal(CAST(@dQty AS NUMERIC(22, 10)) * CAST(@dCostPricetemp AS NUMERIC(22, 10)))
                                                    SELECT  @dTotaltemp = @dCostTotaltemp + @dCostTotalOut  --@dQty*@dCostPricetemp
                                                    SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                                    SELECT  @dCostPricetemp = 0
                                                    IF @dQtytemp <> 0 
                                                        SELECT  @dCostPricetemp = dbo.Fun_CovToprice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))

                                                    UPDATE  tbx_Stock_Goods
                                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = @dCostPricetemp
                                                    WHERE   goodsorderId = @UpdategoodsorderId
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec
                                                        
                                                    --库存变动 dlyorder暂填0，等有了后再填    
                                                    INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                    VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dCostTotalOut, @GoodsDate )
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec
                                                    GOTO Success
                                                END
                                        END
                                END
                            ELSE --有记录入库
                                BEGIN
                                    --IF ( ( @dTotal = 0 )
                                    --     AND ( @nInputZero = 0 )
                                    --   ) --入库金额为0，并且不采用0单价入库
                                    --    BEGIN
                                    --        IF @dCostQtytemp = 0
                                    --            OR @dCosttotaltemp = 0 
                                    --            BEGIN			
                                    --                SELECT  @dCostPricetemp = recprice
                                    --                FROM    dbo.Fun_GetUnitRecPrice(@szPtypeid, @nUcode)
                                    --                SET @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostPricetemp AS NUMERIC(22, 10)) / CAST(@dURate AS NUMERIC(22, 10)))			
                                    --            END
                                    --        ELSE 
                                    --            SELECT  @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostTotaltemp AS NUMERIC(22, 10)) / CAST(@dCostQtyTemp AS NUMERIC(22, 10)))
                                    --        IF @dCostPricetemp < = 0 
                                    --            GOTO errorInputCostPrice
                                    --        SELECT  @dTotal = dbo.f_CovToTotal(CAST(@dCostPriceTemp AS NUMERIC(22, 10)) * CAST(@dQty AS NUMERIC(22, 10)))  --已经有库存了
                                    --        IF @dTotal < = 0 
                                    --            GOTO errorInputCostPrice
                                    --    END
                                    
                                    SELECT  @dTotaltemp = @dCostTotaltemp + @dTotal
                                    SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                    SELECT  @dCostPricetemp = 0
                                    IF @dQtytemp <> 0 
                                        SELECT  @dCostPricetemp = dbo.Fun_CovToPrice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))
                                    
                                    UPDATE  tbx_Stock_Goods
                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = @dCostPricetemp--,outfactorydate = @szProdate, JobNumber =@szBlockNO
                                    WHERE   goodsorderId = @UpdategoodsorderId
                                    IF @@RowCount = 0 
                                        GOTO ErrorNoRec
                                
									--库存变动 dlyorder暂填0，等有了后再填   
                                    IF @dQty = 0 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, 0, @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END	
                                    ELSE 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END
                                                
                                    SELECT  @dCostTotalOut = @dTotal
                                    GOTO Success
                                END
                        END
                    ELSE --库存无记录
                        BEGIN
                            IF @dQty < 0 
                                BEGIN
                                    SET @ErrorValue = '当前库存数量不足'
                                    GOTO ErrorCloseCursor
                                END
                                
                            --IF ( ( @dTotal = 0 )
                            --     AND ( @nInputZero = 0 )
                            --   ) --入库金额为0，并且不采用0单价入库,或出库不强制出库
                            --    BEGIN         
                            --        SELECT  @dTotal = recprice
                            --        FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)
                            --        SET @dTotal = ( @dTotal / @dURate )
                            --        SET @dTotal = dbo.f_CovToTotal(CAST(@dTotal AS NUMERIC(22, 10)) * CAST(@dQty AS NUMERIC(22, 10)))
		 	    
                            --        IF @dTotal = 0 
                            --            GOTO errorInputCostPrice
                            --    END
                            SELECT  @dCostPricetemp = dbo.Fun_CovToprice(CAST(@dTotal AS NUMERIC(22, 10)) / CAST(@dQty AS NUMERIC(22, 10)))
                            INSERT  tbx_Stock_Goods ( ptypeid, ktypeid, qty, total, price )--,OutFactoryDate, JobNumber)
                            VALUES  ( @szPtypeid, @szKtypeid, @dQty, @dTotal, @dCostPricetemp )--,@szProdate,@szBlockNO)
                            IF @@RowCount = 0 
                                GOTO ErrorNoRec
                            SET @goodsorderID = @@IDENTITY
                            
                            --库存变动 dlyorder暂填0，等有了后再填   
                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dTotal, @GoodsDate )
                            IF @@RowCount = 0 
                                GOTO ErrorNoRec
                            SELECT  @dCostTotalOut = @dTotal
                            GOTO Success
                        END
                END
            ELSE 
                IF @Costmode = @FIFO 
                    BEGIN
                        PRINT '@FIFO'
                    END
                ELSE 
                    IF @Costmode = @LIFO 
                        BEGIN
                            PRINT '@LIFO'
                        END
                    ELSE 
                        IF @Costmode = @HAND 
                            BEGIN
                                PRINT '@HAND'
                            END 
        END
    ELSE 
        BEGIN		 /*---------------------修改期初--------------------*/
            PRINT '修改期初'
        END 
	
    Success:		 --成功完成函数
    DEALLOCATE    ModIFyDbf_CURSOR
    RETURN 0


    ErrorGeneral:    --检查数据时错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作时错误，需要回滚
    RETURN -2 

    ErrorCloseCursor:   --数据操作时错误，需要关闭游标
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -3 
    
    ErrorNoRec:    --检查数据时错误，没有记录
    SET @ErrorValue = '更新记录错误'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -4

    ErrorInputCostPric:    --检查数据时错误，最近进价为0
    SET @ErrorValue = '-最近进价为0'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -5

GO 



IF OBJECT_ID('dbo.pbx_Bill_Order_Create') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Order_Create
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Order_Create                                                
--  ||   过程功能：进货或者销售订单过账
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_Order_Create
    (
      @OldVchCode INT ,
      @NewvchCode INT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @net INT ,
        @inputNo VARCHAR(50)
    DECLARE @sdate VARCHAR(10)
    DECLARE @nVchtype INT ,
        @nPeriod INT ,
        @nYearPeriod INT ,
        @DeptID VARCHAR(50)
    DECLARE @modiDly CHAR(1)
    DECLARE @ntotal NUMERIC(22, 10)
    DECLARE @YPratypeid VARCHAR(50)
    DECLARE @flag INT
    DECLARE @szBTypeID VARCHAR(50) 
    DECLARE @szKTypeID VARCHAR(50) 
    DECLARE @szETypeID VARCHAR(50) 
    DECLARE @SzPtypeid VARCHAR(50) 
    DECLARE @szATypeID VARCHAR(500)

    SET @net = 0

    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    --IF @nPeriod <= 0
    --    OR @nPeriod > 12 
    --    BEGIN
    --        SET @net = -11
    --        GOTO ErrorGeneral
    --    END
    --SELECT  @nYearPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'YearPeriod'
 
    --IF EXISTS ( SELECT  1
    --            FROM    dbo.sysdata
    --            WHERE   SubName = 'iniover'
    --                    AND SubValue <> '1' )
    --    AND EXISTS ( SELECT 1
    --                 FROM   BakDlyOrder
    --                 WHERE  vchcode = @newvchcode
    --                        AND ptypeid = ''
    --                        AND atypeid <> '0000100001' ) 
    --    BEGIN
    --        SET @net = -824
    --        GOTO ErrorGeneral
    --    END
 

    SELECT  @szBTypeID = '', @szKTypeID = '', @szETypeID = '', @SzPtypeid = '', @flag = 1

    SELECT  @nVchtype = VchType, @sdate = InputDate, @szETypeID = ETypeID, @szbtypeid = btypeid, @inputNo = inputNo, @modiDly = RedWord, @DeptID = DtypeId
    FROM    dbo.tbx_Bill_Order_M
    WHERE   vchcode = @newvchcode	
    IF @nVchtype = 8 
        BEGIN
            SET @flag = 1
            SET @YPratypeid = '0000200005'	--预收账款
        END
    ELSE 
        BEGIN
            SET @flag = -1 
            SET @YPratypeid = '0000100009' --预付账款
        END

    IF ISNULL(@szBTypeID, '') <> '' 
        IF NOT EXISTS ( SELECT  btypeid
                        FROM    dbo.tbx_Base_Btype
                        WHERE   btypeid = @szBTypeID
                                AND Deleted = 0
                                AND bSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '单位不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF ISNULL(@szETypeID, '') <> '' 
        IF NOT EXISTS ( SELECT  etypeid
                        FROM    dbo.tbx_Base_Etype
                        WHERE   etypeid = @szETypeID
                                AND Deleted = 0
                                AND eSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '经手人不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF ISNULL(@DeptID, '') <> '' 
        IF NOT EXISTS ( SELECT  Dtypeid
                        FROM    dbo.tbx_Base_Dtype
                        WHERE   Dtypeid = @DeptID
                                AND Deleted = 0
                                AND dSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '部门不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF ISNULL(@inputNo, '') <> ''
        AND @inputNo <> '00000' 
        IF NOT EXISTS ( SELECT  etypeid
                        FROM    tbx_Base_Etype
                        WHERE   etypeid = @inputNo
                                AND Deleted = 0
                                AND eSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '制单人不存在或者已经删除'
                GOTO ErrorGeneral
            END
	
    IF EXISTS ( SELECT  1
                FROM    dbo.tbx_Bill_Order_D dly ,
                        dbo.tbx_Base_Ptype p
                WHERE   p.ptypeid = dly.ptypeid
                        AND vchcode = @newvchcode
                        AND ( deleted = 1
                              OR pSonNum <> 0
                            ) ) 
        BEGIN
            SELECT TOP 1
                    @SzPtypeid = dly.ptypeid
            FROM    tbx_Bill_Order_D dly ,
                    tbx_Base_Ptype p
            WHERE   p.ptypeid = dly.ptypeid
                    AND vchcode = @newvchcode
                    AND ( deleted = 1
                          OR pSonNum <> 0
                        )
			
            SET @ErrorValue = '商品不存在或者已经删除'
            GOTO ErrorGeneral		
		
        END
    --IF EXISTS ( SELECT  1
    --            FROM    tbx_Bill_Order_D dly ,
    --                    dbo.atype a
    --            WHERE   a.atypeid = dly.atypeid
    --                    AND vchcode = @newvchcode
    --                    AND ( deleted = 1
    --                          OR aSonNum <> 0
    --                        ) ) 
    --    BEGIN
    --        SELECT TOP 1
    --                @szATypeID = dly.atypeid
    --        FROM    tbx_Bill_Order_D dly ,
    --                dbo.atype a
    --        WHERE   a.atypeid = dly.atypeid
    --                AND vchcode = @newvchcode
    --                AND ( deleted = 1
    --                      OR aSonNum <> 0
    --                    )
			
    --        SET @net = -137
    --        GOTO ErrorGeneral		
		
    --    END

--是否被调用
    --IF @oldVchcode <> 0 
    --    BEGIN
    --        EXEC @net = dbo.P_HH_CanChangeOrder @nVchtype, @oldVchcode
    --        IF @net < 0 
    --            BEGIN
    --                SET @net = -157
    --                GOTO ErrorGeneral	
    --            END
    --    END

    IF EXISTS ( SELECT  1
                FROM    tbx_Bill_Order_D dly ,
                        dbo.tbx_Base_Ktype k
                WHERE   k.ktypeid = dly.ktypeid
                        AND dly.ktypeid <> ''
                        AND vchcode = @newvchcode
                        AND ( deleted = 1
                              OR kSonNum <> 0
                            ) ) 
        BEGIN
            SELECT TOP 1
                    @SzKtypeid = dly.ktypeid
            FROM    tbx_Bill_Order_D dly ,
                    tbx_Base_Ktype k
            WHERE   k.ktypeid = dly.ktypeid
                    AND dly.ktypeid <> ''
                    AND vchcode = @newvchcode
                    AND ( deleted = 1
                          OR kSonNum <> 0
                        )			
		
            SET @ErrorValue = '仓库不存在或者已经删除'
            GOTO ErrorGeneral				
        END
	
   -- IF EXISTS ( SELECT  1
   --             FROM    tbx_Bill_Order_D dly ,
   --                     dbo.tbx_Base_Ptype p
   --             WHERE   p.ptypeid = dly.ptypeid
   --                     AND vchcode = @newvchcode
   --                     AND ( Ptypetype = 1
   --                           OR SNManCode = 1
   --                           OR pgmancode IN ( 1, 2 )
   --                         )
   --                     AND unit > 0 ) 
   --     BEGIN
   --         SELECT TOP 1
   --                 @SzPtypeid = dly.ptypeid
   --         FROM    bakdlyorder dly ,
   --                 ptype p
   --         WHERE   p.ptypeid = dly.ptypeid
   --                 AND vchcode = @newvchcode
   --                 AND ( Ptypetype = 1
   --                       OR SNManCode = 1
   --                       OR pgmancode IN ( 1, 2 )
   --                     )
   --                 AND unit > 0
   --         ORDER BY dlyorder				
		
   --         SET @net = -149
   --         GOTO ErrorGeneral		
		 ----服务类，序列号，明细码 不支持多单位
   --     END
	
  --  IF EXISTS ( SELECT  1
  --              FROM    bakdlyorder dly ,
  --                      ptype p
  --              WHERE   p.ptypeid = dly.ptypeid
  --                      AND vchcode = @newvchcode
  --                      AND SNManCode = 1
  --                      AND p.costmode NOT IN ( 0, 3 ) ) 
  --      BEGIN
  --          SELECT TOP 1
  --                  @SzPtypeid = dly.ptypeid
  --          FROM    bakdlyorder dly ,
  --                  ptype p
  --          WHERE   p.ptypeid = dly.ptypeid
  --                  AND vchcode = @newvchcode
  --                  AND SNManCode = 1
  --                  AND p.costmode NOT IN ( 0, 3 )
  --          ORDER BY dlyorder				
  --          SET @net = -150
  --          GOTO ErrorGeneral
		----序列号的成本算法不支持先进，后进
  --      END
	
  --  IF EXISTS ( SELECT  1
  --              FROM    dbo.tbx_Bill_Order_D dly ,
  --                      dbo.tbx_Base_Ptype p
  --              WHERE   p.ptypeid = dly.ptypeid
  --                      AND vchcode = @newvchcode
  --                      AND ( ( pgManCode IN ( 1, 2 )
  --                              AND p.costmode NOT IN ( 0, 3 )
  --                            )
  --                            OR ( Ptypetype = 1
  --                                 AND p.costmode <> 0
  --                               )
  --                          ) ) 
  --      BEGIN
  --          SELECT TOP 1
  --                  @SzPtypeid = dly.ptypeid
  --          FROM    tbx_Bill_Order_D dly ,
  --                  tbx_Base_Ptype p
  --          WHERE   p.ptypeid = dly.ptypeid
  --                  AND vchcode = @newvchcode
  --                  AND ( ( pgManCode IN ( 1, 2 )
  --                          AND p.costmode NOT IN ( 0, 3 )
  --                        )
  --                        OR ( Ptypetype = 1
  --                             AND p.costmode <> 0
  --                           )
  --                      )
  --          ORDER BY dlyorder						
  --          SET @net = -147
  --          GOTO ErrorGeneral   
		----服务类商品，或明细码商品不支持非加权
  --      END

--本单据已经在其它地方修改，不能修改/删除
    IF @modiDly = 'F'
        AND @oldVchcode <> 0 
        BEGIN
            IF NOT EXISTS ( SELECT  1
                            FROM    dbo.tbx_Bill_Order_M
                            WHERE   vchcode = @oldVchcode
                                    AND btypeid = @szBTypeID
                                    AND InputDate = @sdate ) 
                BEGIN
                    SET @ErrorValue = '本单据已经在其它地方修改，不能修改/删除'
                    GOTO ErrorGeneral	
                END
        END 

    BEGIN TRAN ndxORDER

    IF @oldVchcode <> 0 
        BEGIN
	
            UPDATE  tbx_Bill_Order_M
            SET     InputDate = N.InputDate, Number = N.Number, VchType = N.VchType, Summary = N.Summary, Comment = N.Comment, BtypeId = N.BtypeId, EtypeId = N.EtypeId, DtypeId = N.DtypeId, KtypeId = N.KtypeId, KtypeId2 = N.KtypeId2, Period = N.Period, YearPeriod = N.YearPeriod, RedWord = N.RedWord, Redold = N.Redold, InputNo = N.InputNo, InputNO1 = N.InputNO1, InputNO2 = N.InputNO2, InputNO3 = N.InputNO3, InputNO4 = N.InputNO4, InputNO5 = N.InputNO5, Total = N.Total, Defdiscount = N.Defdiscount, Savedate = N.Savedate, AuditState = N.AuditState, OrderOver = N.OrderOver, UserOver = N.UserOver, GatheringDate = N.GatheringDate
            FROM    ( SELECT    InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Redold, InputNo, InputNO1, InputNO2, InputNO3, InputNO4, InputNO5, Total, Defdiscount, Savedate, AuditState, OrderOver, UserOver, GatheringDate
                      FROM      tbx_Bill_Order_M
                      WHERE     Vchcode = @Newvchcode
                    ) N
            WHERE   Vchcode = @OldVchcode
            IF @@ERROR <> 0 
                BEGIN
                    SET @net = -101
                    GOTO ErrorRollback
                END			  	 			
        END


 --   IF @modiDly = 'T'
 --       AND EXISTS ( SELECT 1
 --                    FROM   dbo.tbx_Bill_Order_D
 --                    WHERE  vchcode = @newvchcode
 --                           AND ptypeid = ''
 --                           AND atypeid <> '0000100001' ) 
 --       BEGIN
 --           INSERT  INTO DlyA ( vchcode, atypeid, btypeid, etypeid, ktypeid, total, date, period, vchtype, redword, DeptID, usedtype, YearPeriod )
 --                   SELECT  vchcode, atypeid, @szBTypeID, @szETypeID, @szKTypeID, total, @sdate, @nPeriod, @nvchtype, 'F', @DeptID, usedtype, @nYearPeriod
 --                   FROM    BakDlyOrder
 --                   WHERE   vchcode = @newvchcode
 --                           AND ptypeid = ''
 --                           AND atypeid <> '0000100001'
           		    
	----预收账款
 --           SET @ntotal = 0
 --           SELECT  @ntotal = SUM(total)
 --           FROM    BakDlyOrder
 --           WHERE   vchcode = @newvchcode
 --                   AND ptypeid = ''
 --                   AND atypeid <> '0000100001'  
        			  	 	 			 
 --           INSERT  INTO DlyA ( vchcode, atypeid, btypeid, etypeid, ktypeid, total, date, period, vchtype, redword, DeptID, usedtype, YearPeriod )
 --           VALUES  ( @newvchcode, @YPratypeid, @szBTypeID, @szETypeID, @szKTypeID, @flag * @ntotal, @sdate, @nPeriod, @nVchtype, 'F', @DeptID, 2, @nYearPeriod )      
 --       END 

 --   IF @modiDly = 'T' 
 --       BEGIN 				
	----处理订单数据定金数据
 --           DECLARE @szAATypeID VARCHAR(50) ,
 --               @szABTypeID VARCHAR(50) ,
 --               @dTotal NUMERIC(22, 10)
 --           DECLARE @execsql VARCHAR(500)
 --           DECLARE @dTemp NUMERIC(22, 10) ,
 --               @AUnit NUMERIC(22, 10) ,
 --               @dUnitRate NUMERIC(22, 10) ,
 --               @tDate VARCHAR(10)
 --           SET @net = 0
	 		 				
 --           SELECT  @execsql = 'declare AccountDly_cursor cursor for ' + ' SELECT ATypeID,BTypeID, SUM(total) total FROM ( ' + 'select ATypeID, BTypeID,Total from dlya  where  Vchcode= ' + CAST(@newvchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) + ' ' + ' UNION ALL ' + ' select ATypeID, BTypeID, -Total total from dlya  where  Vchcode= ' + CAST(@oldVchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) + ' ) a ' + 'GROUP BY ATypeID,BTypeID  HAVING SUM(total) <> 0'             
 --           EXEC (@execsql)
 --           OPEN AccountDly_cursor
 --           FETCH NEXT FROM AccountDly_cursor INTO @szAATypeID, @szABTypeID, @dTotal
 --           WHILE @@FETCH_STATUS = 0 
 --               BEGIN
 --                   IF @szAATypeID <> '' 
 --                       BEGIN
 --                           EXEC @net = ModifyDbf @nVchType, @newvchcode, 0, @tDate, 0, @szAATypeID, '', @szABTypeID, @szETypeID, '', @nPeriod, @dTotal, @dTotal, '', '', 0, @dTemp OUTPUT, @AUnit, @dUnitRate, 0
 --                           IF @net < 0 
 --                               GOTO ErrorGeneral
	              
 --                       END
 --                   FETCH NEXT FROM AccountDly_cursor INTO @szAATypeID, @szABTypeID, @dTotal
 --               END
 --           CLOSE AccountDly_cursor
 --           DEALLOCATE AccountDly_cursor
 --       END

    --IF @modiDly = 'T' 
    --    BEGIN
    --        EXEC @net = p_hh_CanModiOrderBill 'M', @oldVchcode, @newvchcode, @nVchtype
    --        IF @net < 0 
    --            GOTO ErrorRollback
    --    END

	
    IF @OldVchCode = 0 
        BEGIN
            PRINT '审核功能'
            --UPDATE  dbo.tbx_Bill_Order_M
            --SET     AuditState = dbo.fn_getAuditState(VchType, Vchcode)
            --WHERE   Vchcode = @NewVchCode
        END
    ELSE 
        BEGIN
            DELETE  FROM tbx_Bill_Order_M
            WHERE   VchCode = @NewVchCode	
     
            --UPDATE  dbo.tbx_Bill_Order_M
            --SET     AuditState = dbo.fn_getAuditState(VchType, Vchcode)
            --WHERE   Vchcode = @OldVchcode
    
            IF @modiDly = 'T' 
                BEGIN
                    DELETE  FROM tbx_Bill_Order_D
                    WHERE   vchcode = @OldVchCode				
                    --DELETE  FROM dlya
                    --WHERE   VchCode = @OldVchCode
                    --        AND VchType = @nVchtype
                END 
            ELSE 
                BEGIN
                    DELETE  FROM tbx_Bill_Order_D
                    WHERE   VchCode = @OldVchCode
                            AND AtypeId = '0000100001'
                END
		 
            UPDATE  tbx_Bill_Order_D
            SET     VchCode = @OldVchCode
            WHERE   VchCode = @NewVchCode
			 		
            DELETE  FROM tbx_Bill_Order_D
            WHERE   VchCode = @NewVchCode
			
        END

    IF @modiDly = 'T' 
        UPDATE  tbx_Bill_Order_M
        SET     RedWord = 'F'
        WHERE   VchCode = CASE WHEN @OldVchCode = 0 THEN @NewVchCode
                               ELSE @OldVchCode
                          END

    COMMIT TRAN ndxORDER

--跟踪商品单位
    --DECLARE @unit INT ,
    --    @tmpvchcode INT

    --IF @oldVchcode <> 0 
    --    SET @tmpvchcode = @oldVchcode
    --ELSE 
    --    SET @tmpvchcode = @newvchcode
    --DECLARE my_cursor CURSOR
    --FOR
    --    SELECT  ptypeid, unit
    --    FROM    bakdlyorder
    --    WHERE   vchcode = @tmpvchcode
	
    --OPEN my_cursor
		
    --FETCH NEXT FROM my_cursor INTO @szptypeid, @unit
	
	
    --WHILE @@FETCH_STATUS = 0 
    --    BEGIN
    --        EXEC p_hh_GetLastUnit 'W', @nVchType, @szPtypeId, @unit
    --        FETCH NEXT FROM my_cursor INTO @szptypeid, @unit
    --    END
	
    --CLOSE my_cursor
    --DEALLOCATE my_cursor
	
    RETURN @net
    
    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    DELETE  FROM tbx_Bill_Order_D
    WHERE   Vchcode = @NewVchCode
    DELETE  FROM tbx_Bill_Order_M
    WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN ndxORDER 
    DELETE  FROM tbx_Bill_Order_D
    WHERE   Vchcode = @NewVchCode
    DELETE  FROM tbx_Bill_Order_M
    WHERE   Vchcode = @NewVchCode
    RETURN -2 

GO 



IF OBJECT_ID('dbo.pbx_Bill_VchNumber') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_VchNumber
GO

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_VchNumber                                                
--  ||   过程功能：获取或者检查单据编号
--@DoWork=1 ：传入单据编号@VchNumberIn, 单据中是否有相同的单据编号，
--@DoWork=2 ：传入单据类型和日期，单据编号
--  ********************************************************************************************

CREATE PROCEDURE pbx_Bill_VchNumber
    (
      @DoWork INT ,
      @VchType INT ,
      @OldVchCode INT ,
      @NewVchCode INT ,
      @BillDate VARCHAR(10) ,--格式2008-11-02
      @VchNumberIn VARCHAR(50) ,
      @VchNumber VARCHAR(50) OUT ,
      @ErrorValue VARCHAR(500) OUT
    )
AS 
    SET NOCOUNT ON

    DECLARE @SNFormat VARCHAR(50) ,
        @NumberPrefix VARCHAR(50) ,
        @FormatMax VARCHAR(50) ,
        @ComputerID VARCHAR(50) ,
        @Period INT ,
        @LoopType INT
        

    DECLARE @nMax INT

    SET @nMax = 0
    SET @VchNumber = '0'
    SET @LoopType = 1 --1每月循环编号
    SET @ComputerID = ''
	
    SELECT  @SNFormat = SNFormat, @NumberPrefix = NumberPrefix
    FROM    dbo.tbx_Base_Vtype
    WHERE   VchType = @VchType
	
    SELECT  @nMax = MaxNo
    FROM    tbx_Bill_NumberRecords
    WHERE   VchType = @VchType
	
    SET @nMax = ISNULL(@nMax, 0) + 1
	
    SELECT  @FormatMax = RIGHT(CAST(POWER(10, 3) AS VARCHAR) + @nMax, 3)
    
    SET @VchNumber = @NumberPrefix + '-' + @BillDate + '-' + @FormatMax  
    
    IF @LoopType = 0 
        BEGIN
            SET @Period = DAY(@BillDate)	
        END
    ELSE 
        IF @LoopType = 1 
            BEGIN
                SET @Period = MONTH(@BillDate)	
            END 
        ELSE 
            IF @LoopType = 2 
                BEGIN
                    SET @Period = YEAR(@BillDate)	
                END 
    IF @DoWork = 1 
        BEGIN
            IF RTRIM(@VchNumberIn) = '' 
                BEGIN
                    GOTO Success
                END
            IF @VchType IN ( 1, 2 ) 
                BEGIN
                    IF EXISTS ( SELECT  VchCode
                                FROM    dbo.tbx_Bill_Order_M
                                WHERE   Number = @VchNumberIn
                                        AND VchCode <> @OldVchCode
                                        AND VchCode <> @NewVchCode ) 
                        BEGIN
                            SET @ErrorValue = '在已保存的单据中已经有此单据编号，不能保存!'
                            GOTO ErrorGeneral 	
                        END

                END
            ELSE 
                IF @VchType IN ( 3, 4 ) 
                    BEGIN
                        IF EXISTS ( SELECT  VchCode
                                    FROM    dbo.tbx_Bill_M
                                    WHERE   Number = @VchNumberIn
                                            AND VchCode <> @OldVchCode
                                            AND VchCode <> @NewVchCode ) 
                            BEGIN
                                SET @ErrorValue = '在已保存的单据中已经有此单据编号，不能保存!'
                                GOTO ErrorGeneral 	
                            END
                    END
        END
    ELSE 
        IF @DoWork = 2 
            BEGIN
                IF ( EXISTS ( SELECT    1
                              FROM      dbo.tbx_Bill_NumberRecords
                              WHERE     VchType = @VchType
                                        AND Period = @Period
                                        AND ComputerID = @ComputerID
                                        AND LoopType = @LoopType ) ) 
                    BEGIN
                        UPDATE  dbo.tbx_Bill_NumberRecords
                        SET     MaxNo = MaxNo + 1
                        WHERE   VchType = @VchType
                                AND Period = @Period
                                AND ComputerID = @ComputerID
                                AND LoopType = @LoopType 
                    END
                ELSE 
                    BEGIN
                        INSERT  dbo.tbx_Bill_NumberRecords ( ComputerID, VchType, LoopType, Period, MaxNo )
                        VALUES  ( @ComputerID, @VchType, @LoopType, @Period, @nMax )
                    END
            END
	    	          
    GOTO Success
	
    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 


go



IF OBJECT_ID('dbo.pbx_Flow_AddWork') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_AddWork
GO

--增加一条单据或者其它的审核

CREATE PROCEDURE pbx_Flow_AddWork
    (
      @CETypeId VARCHAR(50) ,  --新增这个审核的职员ID
      @Info VARCHAR(255) , --摘要信息,自动生成,方便汇总处理时查看
      @WorkID VARCHAR(50) ,--与具体业务功能模块关联的Id,如单据的MoudelNo等
      @BillID INT ,--要审核的记录的ID
      @BillType INT ,--要审核的记录的类型，可能同一个窗体，多个功能
      @TaskProcID INT ,--使用的流程作业ID表,0就使用默认的流程作业
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

   
    DECLARE @SetWorkID VARCHAR(50)    
	
    IF EXISTS ( SELECT TOP 1
                        ProcePathID
                FROM    dbo.tbx_Flow_ProcePath
                WHERE   WorkID = @WorkID
                        AND BillID = @BillID
                        AND BillType = @BillType )
        BEGIN
            SET @ErrorValue = '此记录已经存在审批流程'
            RETURN -1
        END

    IF ( @TaskProcID <> 0 )
        BEGIN
            SELECT  @SetWorkID = b.WorkID
            FROM    dbo.tbx_Flow_TaskProc a
                    LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
            WHERE   a.TaskProcID = @TaskProcID   
        END
    ELSE
        BEGIN
            SELECT  @SetWorkID = b.WorkID, @TaskProcID = a.TaskProcID
            FROM    dbo.tbx_Flow_TaskProc a
                    LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
            WHERE   a.DefaultProc = 1   
        END


    IF ( @SetWorkID <> @WorkID )
        BEGIN
            SET @ErrorValue = '选择的流程作业与业务功能模块不匹配'
            RETURN -1
        END     

    IF NOT EXISTS ( SELECT TOP 1
                            ProcessID
                    FROM    dbo.tbx_Flow_Process
                    WHERE   TaskProcID = @TaskProcID )
        BEGIN
            SET @ErrorValue = '选择的流程作业没有具体审批项目'
            RETURN -1
        END

    INSERT  dbo.tbx_Flow_ProcePath ( ProcessID, BillID, BillType, WorkID, FlowETypeID, ProceResult, Info, CreaterETypeID, CreateTime )
    SELECT  fp.ProcessID, @BillID, @BillType, @WorkID, fpp.OperId, '', @Info, @CETypeId, CONVERT(VARCHAR, GETDATE(), 120)
    FROM    dbo.tbx_Flow_Process fp
            LEFT JOIN dbo.tbx_Flow_ProcePermi fpp ON fpp.ProcessID = fp.ProcessID
            LEFT JOIN dbo.tbx_Flow_TaskProc ft ON ft.TaskProcID = fp.TaskProcID
    WHERE   ft.TaskProcID = @TaskProcID
    ORDER BY fp.ProceOrder 

    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Flow_Del') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_Del
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Flow_Del
--  ||   过程功能：删除流程
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Flow_Del
    (
      @TaskID INT , --流程作业ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    DELETE  dbo.tbx_Flow_ProcePermi
    WHERE   ProcessID IN ( SELECT   ProcessID
                           FROM     dbo.tbx_Flow_Process a
                                    LEFT JOIN dbo.tbx_Flow_TaskProc b ON a.TaskProcID = b.TaskProcID
                           WHERE    b.TaskID = @TaskID )

    DELETE  dbo.tbx_Flow_Process
    WHERE   TaskProcID IN ( SELECT  TaskProcID
                            FROM    dbo.tbx_Flow_TaskProc
                            WHERE   TaskID = @TaskID )


    DELETE  dbo.tbx_Flow_TaskProc
    WHERE   TaskID = @TaskID 
	
    GOTO Success

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



IF OBJECT_ID('dbo.pbx_Flow_DoOne') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_DoOne
GO

--处理一条审核记录

CREATE PROCEDURE pbx_Flow_DoOne
    (
      @ETypeId VARCHAR(50) ,  --职员的ID
      @ProcePathID INT ,--tbx_Flow_ProcePath的ID
      @ProceResult INT ,--未处理0，通过1，终止2，退回-1
      @FlowInfo VARCHAR(255) ,--审批意见
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    DECLARE @BillID INT
    DECLARE @BillType INT
    DECLARE @WorkID VARCHAR(50)

    IF NOT ( EXISTS ( SELECT    *
                      FROM      dbo.tbx_Flow_ProcePath
                      WHERE     ProcePathID = @ProcePathID ) )
        BEGIN
            SET @ErrorValue = '没有找到审批路径'
            RETURN -1
        END
       
    IF ( EXISTS ( SELECT    *
                  FROM      dbo.tbx_Flow_ProcePath
                  WHERE     ProceResult <> 0
                            AND ProcePathID = @ProcePathID ) )
        BEGIN
            SET @ErrorValue = '已经审批过，不能重复审批'
            RETURN -1
        END

    SELECT  @BillID = BillID, @BillType = BillType, @WorkID = WorkID
    FROM    dbo.tbx_Flow_ProcePath
    WHERE   ProcePathID = @ProcePathID 

    IF ( EXISTS ( SELECT TOP 1
                            ProcePathID
                  FROM      dbo.tbx_Flow_ProcePath
                  WHERE     BillType = @BillType
                            AND BillID = @BillID
                            AND WorkID = @WorkID
                            AND ProcePathID < @ProcePathID
                            AND ProceResult = 0 ) )
        BEGIN
            SET @ErrorValue = '前面还有流程没有审批完成，等完成后在审批'
            RETURN -1  
        END

    INSERT  dbo.tbx_Flow_His ( ProcePathID, ProceResult, FlowInfo, CreaterETypeID, CreateTime )
    VALUES  ( @ProcePathID, @ProceResult, @FlowInfo, @ETypeId, CONVERT(VARCHAR, GETDATE(), 120) )

    IF ( @ProceResult = 1 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 1, FlowInfo = @FlowInfo
            WHERE   ProcePathID = @ProcePathID
        END 

    IF ( @ProceResult = 2 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 2, FlowInfo = @FlowInfo
            WHERE   ProcePathID = @ProcePathID
        END 

    IF ( @ProceResult = -1 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 0, FlowInfo = ''
            WHERE   ProcePathID = ( SELECT TOP 1
                                            ProcePathID
                                    FROM    dbo.tbx_Flow_ProcePath
                                    WHERE   BillType = @BillType
                                            AND BillID = @BillID
                                            AND WorkID = @WorkID
                                            AND ProcePathID < @ProcePathID
                                    ORDER BY ProcePathID DESC
                                  )

			--如果是第一个审批就退回就删除所有的审批流程
            IF ( @ProcePathID = ( SELECT TOP 1
                                            ProcePathID
                                  FROM      dbo.tbx_Flow_ProcePath
                                  WHERE     BillType = @BillType
                                            AND BillID = @BillID
                                            AND WorkID = @WorkID
                                  ORDER BY  ProcePathID
                                ) )
                BEGIN
                    DELETE  dbo.tbx_Flow_ProcePath
                    WHERE   BillType = @BillType
                            AND BillID = @BillID
                            AND WorkID = @WorkID
                END
        END  
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Flow_QryData') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_QryData
GO

--查询审核

CREATE PROCEDURE pbx_Flow_QryData
    (
      @QryType INT ,  --1流程作业,2流程作业具体项目
      @Custom VARCHAR(500) = '' ,--默认参数 
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @QryType = 1 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_TaskType
            ORDER BY TaskID
        END

    IF ( @QryType = 2 )
        BEGIN
            IF @Custom <> ''
                BEGIN
                    SELECT  *
                    FROM    dbo.tbx_Flow_TaskProc a
                            LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
                    WHERE   a.TaskID = CAST(@Custom AS INT)
                    ORDER BY DefaultProc DESC, a.TaskID
                END  
            ELSE
                BEGIN
                    SELECT  *
                    FROM    dbo.tbx_Flow_TaskProc a
                            LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
                    ORDER BY DefaultProc DESC, a.TaskID
                END
        END

    IF ( @QryType = 3 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_Process fp
                    LEFT JOIN dbo.tbx_Flow_TaskProc ft ON fp.TaskProcID = ft.TaskProcID
                    LEFT JOIN dbo.tbx_Flow_TaskType ftt ON ft.TaskID = ftt.TaskID
            WHERE   ftt.TaskID = CAST(@Custom AS INT)
            ORDER BY ft.DefaultProc DESC, fp.TaskProcID, fp.ProceOrder
        END
     
    IF ( @QryType = 4 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_Process fp
                    LEFT JOIN dbo.tbx_Flow_TaskProc ft ON fp.TaskProcID = ft.TaskProcID
                    LEFT JOIN dbo.tbx_Flow_TaskType ftt ON ft.TaskID = ftt.TaskID
                    LEFT JOIN dbo.tbx_Flow_ProcePermi ffp ON ffp.ProcessID = fp.ProcessID
                    LEFT JOIN dbo.tbx_Base_Etype e ON ffp.OperId = e.ETypeId
            WHERE   ft.TaskID = CAST(@Custom AS INT)
            ORDER BY ft.DefaultProc DESC, fp.TaskProcID, fp.ProceOrder
        END
      
    IF ( @QryType = 5 )
        BEGIN
            SELECT  fpp.*, e.EFullname AS CEFullname
            FROM    dbo.tbx_Flow_ProcePath fpp
                    LEFT JOIN dbo.tbx_Base_Etype e ON fpp.CreaterETypeID = e.ETypeId
                    LEFT JOIN dbo.tbx_Flow_ProcePath fs ON fs.BillID = fpp.BillID --没得终止的
                                                           AND fs.BillType = fpp.BillType
                                                           AND fs.WorkID = fpp.WorkID
                                                           AND fs.ProceResult = 2
            WHERE   fpp.ProceResult = 0
                    AND fpp.FlowETypeID = @Custom
                    AND fs.ProcePathID IS NULL
            ORDER BY fpp.CreateTime
        END      

    IF ( @QryType = 6 )
        BEGIN
            SET @aSQL = 'SELECT  fh.*, fp.ProcesseName, e.EFullname
						FROM    dbo.tbx_Flow_His fh
								LEFT JOIN dbo.tbx_Flow_ProcePath fpp ON fpp.ProcePathID = fh.ProcePathID
								LEFT JOIN dbo.tbx_Flow_Process fp ON fp.ProcessID = fpp.ProcessID
								LEFT JOIN dbo.tbx_Base_Etype e ON fh.CreaterETypeID = e.ETypeId
						WHERE   ' + @Custom + ' 
						ORDER BY fh.CreateTime'

            EXEC(@aSQL) 
        END  
    IF ( @QryType = 7 )
        BEGIN
            SET @aSQL = 'SELECT  fpp.*, e.EFullname
						FROM    dbo.tbx_Flow_ProcePath fpp LEFT JOIN dbo.tbx_Base_Etype e ON fpp.FlowETypeID = e.ETypeId 
						WHERE   ' + @Custom + ' 
						ORDER BY fpp.ProcePathID'
            EXEC(@aSQL) 
        END            
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Flow_Save_Set') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_Save_Set
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Flow_Save_Set
--  ||   过程功能：配置一个审批流程
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Flow_Save_Set
    (
      @TaskID INT , --流程作业ID
      @TType INT , --单据业务0；人事1；
      @TComment VARCHAR(255) ,--备注
      @TaskProcName VARCHAR(8000) ,--流程名称
      @ProcesseName VARCHAR(8000) ,--项目名称
      @OperType VARCHAR(8000) ,--操作类型，0审核，1知会，2执行。（知会不需要输入审批意见）
      @ProceOrder VARCHAR(8000) ,--项目顺序,从小到大执行
      --@PermiType VARCHAR(8000) ,--0职员
      @OperId VARCHAR(8000) ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'

    UPDATE  tbx_Flow_TaskType
    SET     TType = @TType, TComment = @TComment
    WHERE   TaskID = @TaskID

	--删除原来的记录
    DELETE  dbo.tbx_Flow_ProcePermi
    WHERE   ProcessID IN ( SELECT   ProcessID
                           FROM     dbo.tbx_Flow_Process a
                                    LEFT JOIN dbo.tbx_Flow_TaskProc b ON a.TaskProcID = b.TaskProcID
                           WHERE    b.TaskID = @TaskID )

    DELETE  dbo.tbx_Flow_Process
    WHERE   TaskProcID IN ( SELECT  TaskProcID
                            FROM    dbo.tbx_Flow_TaskProc
                            WHERE   TaskID = @TaskID )


    DELETE  dbo.tbx_Flow_TaskProc
    WHERE   TaskID = @TaskID 

	--插入新记录
    INSERT  INTO dbo.tbx_Flow_TaskProc ( TaskID, TaskProcName )
    SELECT DISTINCT
            @TaskID, a.Col
    FROM    dbo.Fun_SplitStr(@TaskProcName, @Splitstr) a
    WHERE   ISNULL(a.Col, '') <> ''

    INSERT  INTO dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
    SELECT  DISTINCT
            e.TaskProcID, a.Col, b.Col, c.Col
    FROM    dbo.Fun_SplitStr(@ProcesseName, @Splitstr) a
            LEFT JOIN dbo.Fun_SplitStr(@OperType, @Splitstr) b ON b.ID = a.ID
            LEFT JOIN dbo.Fun_SplitStr(@ProceOrder, @Splitstr) c ON c.ID = a.ID
            LEFT JOIN dbo.Fun_SplitStr(@TaskProcName, @Splitstr) d ON d.ID = a.ID
            LEFT JOIN dbo.tbx_Flow_TaskProc e ON d.Col = e.TaskProcName
    WHERE   ISNULL(c.Col, '') <> '' 

    INSERT  INTO dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
    SELECT  DISTINCT
            b.ProcessID, 0, a.Col1
    FROM    ( SELECT    a1.Col Col1, a2.Col Col2, a3.Col Col3
              FROM      dbo.Fun_SplitStr(@OperId, @Splitstr) a1
                        LEFT JOIN dbo.Fun_SplitStr(@ProcesseName, @Splitstr) a2 ON a2.ID = a1.ID
                        LEFT JOIN dbo.Fun_SplitStr(@TaskProcName, @Splitstr) a3 ON a3.ID = a1.ID
              WHERE     ISNULL(a3.Col, '') <> ''
            ) a
            LEFT JOIN ( SELECT  b1.ProcessID, b1.ProcesseName, b2.TaskProcName
                        FROM    dbo.tbx_Flow_Process b1
                                LEFT JOIN dbo.tbx_Flow_TaskProc b2 ON b2.TaskProcID = b1.TaskProcID
                      ) b ON a.Col2 = b.ProcesseName
                             AND a.Col3 = b.TaskProcName
    WHERE   b.ProcessID IS NOT NULL
			 
    GOTO Success

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



IF OBJECT_ID('dbo.pbx_IntToStr') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_IntToStr
go

CREATE PROCEDURE pbx_IntToStr
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



IF OBJECT_ID('dbo.pbx_Limit_Check') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Limit_Check
GO

--判断某个用户是否具有某种权限点某种操作

CREATE PROCEDURE pbx_Limit_Check
    (
      @LimitId VARCHAR(50) ,  -- 权限ID
      @LimitDo INT ,  --基本信息的相关操作，单据的相关操作，等等
      @UserId VARCHAR(50) ,--tbx_Limit_RU表的用户ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    DECLARE @aRUType INT
    DECLARE @aLAType INT
    DECLARE @aLimitValue INT
    DECLARE @aRet INT
    DECLARE @aLAName VARCHAR(50)
    
    DECLARE @Limit_Base_View INT = 1--基本信息权限-查看
    DECLARE @Limit_Base_Add INT = 2--基本信息权限-新增
    DECLARE @Limit_Base_Class INT = 4--基本信息权限-分类
    DECLARE @Limit_Base_Modify INT = 8--基本信息权限-修改
    DECLARE @Limit_Base_Del INT = 16--基本信息权限-删除
    DECLARE @Limit_Base_Print INT = 32--基本信息权限-打印
  
    DECLARE @Limit_Bill_View INT = 1--单据权限-查看
    DECLARE @Limit_Bill_Input INT = 2--单据权限-输入
    DECLARE @Limit_Bill_Settle INT = 4--单据权限-过账
    DECLARE @Limit_Bill_Print INT = 8--单据权限-打印
    
    DECLARE @Limit_Report_View INT = 1--报表权限-查看
    DECLARE @Limit_Report_Print INT = 2--报表权限-打印
    
    SET @aRUType = 2 --通过用户查询
    SET @aLimitValue = 0
    
    IF @LimitDo = 0
        RETURN -1
     
    IF ( @UserId = '00000' )--超级管理员
        BEGIN
            RETURN 0
        END   
    --IF ( @LimitType = 0 ) 
    BEGIN     
        SELECT  @aLimitValue = ISNULL(MAX(ru.LimitValue), 0), @aLAType = la.LAType, @aLAName = la.LAName
        FROM    dbo.tbx_Limit_Action la
                LEFT JOIN ( SELECT  lar.LAGUID, lar.LimitValue
                            FROM    dbo.tbx_Limit_Action_Role lar
                                    INNER JOIN dbo.tbx_Limit_RU lr ON lr.LRGUID = lar.RUID
                                                                      AND lar.RUType = 1
                                                                      AND lr.UserId = @UserId
                                                                      AND ( ( lar.LimitValue & @LimitDo ) = @LimitDo )
                          ) ru ON la.LAGUID = ru.LAGUID
        WHERE   la.LAGUID = @LimitId
        GROUP BY la.LAGUID, la.LAType, la.LAName 
    END

    SET @aRet = CASE @aLimitValue & @LimitDo
                  WHEN @LimitDo THEN 0
                  ELSE -1
                END      
                   
    IF ( @aRet <> 0 )
        BEGIN
            IF ( @aLAType = 1 ) --0未配置，1基本信息，2单据，3报表，4数据，5其它 
                BEGIN
                    SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                    SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                      WHEN @Limit_Base_View THEN '查看'
                                                      WHEN @Limit_Base_Add THEN '新增'
                                                      WHEN @Limit_Base_Class THEN '分类'
                                                      WHEN @Limit_Base_Modify THEN '修改'
                                                      WHEN @Limit_Base_Del THEN '删除'
                                                      WHEN @Limit_Base_Print THEN '打印'
                                                      ELSE '未定义'
                                                    END    
				
                    SET @ErrorValue = @ErrorValue + ')]权限'
                END	
            ELSE
                IF ( @aLAType = 2 )
                    BEGIN
                        SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                        SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                          WHEN @Limit_Bill_View THEN '查看'
                                                          WHEN @Limit_Bill_Input THEN '输入'
                                                          WHEN @Limit_Bill_Settle THEN '过账'
                                                          WHEN @Limit_Bill_Print THEN '打印'
                                                          ELSE '未定义'
                                                        END    
				
                        SET @ErrorValue = @ErrorValue + ')]权限'
                    END	
                ELSE
                    IF ( @aLAType = 3 )
                        BEGIN
                            SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                            SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                              WHEN @Limit_Report_View THEN '查看'
                                                              WHEN @Limit_Report_Print THEN '打印'
                                                              ELSE '未定义'
                                                            END    
				
                            SET @ErrorValue = @ErrorValue + ')]权限'
                        END	
            RETURN -1 
        END    
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Limit_QryData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_QryData
go

--查询用户或角色列表

CREATE PROCEDURE pbx_Limit_QryData
    (
      @QryType INT ,  --1角色，2角色用户映射表,
      @Custom VARCHAR(500) = '' ,--默认参数 
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @QryType = 1 ) 
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Limit_Role
            ORDER BY LRRowIndex
        END
    ELSE 
        IF ( @QryType = 2 ) 
            BEGIN
                SELECT  lr.*, be.EFullname
                FROM    dbo.tbx_Limit_RU lr
                        LEFT JOIN dbo.tbx_Base_Etype be ON lr.UserId = be.ETypeId
                WHERE   lr.LRGUID = @Custom
                ORDER BY lr.UserId  	
            END
        ELSE 
            IF ( @QryType = 3 ) 
                BEGIN
                    SELECT  lr.*, be.EFullname
                    FROM    dbo.tbx_Limit_RU lr
                            LEFT JOIN dbo.tbx_Base_Etype be ON lr.UserId = be.ETypeId
                    WHERE   lr.LRGUID = @Custom
                    ORDER BY lr.UserId  	
                END
            
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Limit_Save_RA') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RA
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Limit_Save_RA
--  ||   过程功能：增加或者修改一个角色的一条权限记录
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RA
    (
      @LAGUID VARCHAR(50) , --权限功能ID
      @RUID VARCHAR(50) , --角色或用户ID
      @RUType INT, --0未定义，1角色ID，2用户ID
      @LimitValue INT ,  --权限值
      
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
	IF EXISTS(SELECT * FROM dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType)
	BEGIN
		IF (@LimitValue <> 0) 
		BEGIN
			UPDATE dbo.tbx_Limit_Action_Role
			SET LimitValue = @LimitValue
			WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType 
		END	
		ELSE
		BEGIN
			DELETE dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType  
		END
	END
	ELSE 
	BEGIN
		INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
		VALUES  ( @LAGUID, @RUID, @RUType, @LimitValue)	
	END
	

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



IF OBJECT_ID('dbo.pbx_Limit_Save_RU') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RU
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Limit_Save_RU
--  ||   过程功能：增加一个用户和角色点映射关系
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RU
    (
      @LRGUID VARCHAR(50) , --角色ID
      @UserId VARCHAR(50) , --用户ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.tbx_Limit_RU
                    WHERE   LRGUID = @LRGUID
                            AND UserId = @UserId ) 
        BEGIN
            INSERT  INTO dbo.tbx_Limit_RU ( LRGUID, UserId )
            VALUES  ( @LRGUID, @UserId )	
        END
	

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



IF OBJECT_ID('dbo.pbx_Limit_User') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_User
go

--查询用户或角色权限

CREATE PROCEDURE pbx_Limit_User
    (
      @RUID VARCHAR(50) , --角色或用户ID
      @RUType INT ,  --0未定义，1角色ID，2用户ID
      @LimitType INT ,  --0未配置，1基本信息，2单据，3报表，4数据，5其它
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @LimitType = 1 ) 
        BEGIN
            SELECT  la.LAGUID, la.LAName, ISNULL(LimitValue, 0) LimitValue, 
				CASE ISNULL(LimitValue & 1, 0) WHEN 1 THEN 1 ELSE 0 END LView, 
				CASE ISNULL(LimitValue & 2, 0) WHEN 2 THEN 1 ELSE 0 END LAdd, 
				CASE ISNULL(LimitValue & 4, 0) WHEN 4 THEN 1 ELSE 0 END LClass, 
				CASE ISNULL(LimitValue & 8, 0) WHEN 8 THEN 1 ELSE 0 END LModify, 
				CASE ISNULL(LimitValue & 16, 0) WHEN 16 THEN 1 ELSE 0 END LDel, 
				CASE ISNULL(LimitValue & 32, 0) WHEN 32 THEN 1 ELSE 0 END LPrint
            FROM    tbx_Limit_Action la
                    LEFT JOIN tbx_Limit_Action_Role lar ON la.LAGUID = lar.LAGUID
                                                           AND lar.RUType = @RUType
                                                           AND lar.RUID = @RUID
            WHERE   la.LAType = @LimitType
            ORDER BY la.LARowIndex
        END
	 ELSE IF ( @LimitType = 2 )
		 BEGIN
			SELECT  la.LAGUID, la.LAName, ISNULL(LimitValue, 0) LimitValue, 
				CASE ISNULL(LimitValue & 1, 0) WHEN 1 THEN 1 ELSE 0 END LView, 
				CASE ISNULL(LimitValue & 2, 0) WHEN 2 THEN 1 ELSE 0 END LInput, 
				CASE ISNULL(LimitValue & 4, 0) WHEN 4 THEN 1 ELSE 0 END LSettle, 
				CASE ISNULL(LimitValue & 8, 0) WHEN 8 THEN 1 ELSE 0 END LPrint
			FROM    tbx_Limit_Action la
					LEFT JOIN tbx_Limit_Action_Role lar ON la.LAGUID = lar.LAGUID
														   AND lar.RUType = @RUType
														   AND lar.RUID = @RUID
			WHERE   la.LAType = @LimitType
			ORDER BY la.LARowIndex
		 END      
	  ELSE IF ( @LimitType = 3 )
		 BEGIN
			SELECT  la.LAGUID, la.LAName, ISNULL(LimitValue, 0) LimitValue, 
				CASE ISNULL(LimitValue & 1, 0) WHEN 1 THEN 1 ELSE 0 END LView, 
				CASE ISNULL(LimitValue & 2, 0) WHEN 2 THEN 1 ELSE 0 END LPrint
			FROM    tbx_Limit_Action la
					LEFT JOIN tbx_Limit_Action_Role lar ON la.LAGUID = lar.LAGUID
														   AND lar.RUType = @RUType
														   AND lar.RUID = @RUID
			WHERE   la.LAType = @LimitType
			ORDER BY la.LARowIndex
		 END     
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Login') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Login
GO

CREATE PROCEDURE pbx_Login
    (
      @userName VARCHAR(20) ,
      @userPSW VARCHAR(60) ,
      @errorValue VARCHAR(100) OUTPUT ,
      @userId VARCHAR(50) OUTPUT
    )
AS
    SET NOCOUNT ON

    DECLARE @idtemp VARCHAR(50)
    SELECT  @idtemp = ''

    SELECT  @idtemp = ETypeId
    FROM    dbo.tbx_Base_Etype
    WHERE   ( EFullname = @userName
              OR EUsercode = @userName
            )

    IF ( ISNULL(@idtemp, '') = '' )
        BEGIN
            SET @errorValue = '账号不存在或密码错误'
            RETURN -1
        END

    SET @userId = @idtemp

    RETURN 0

GO



IF OBJECT_ID('dbo.pbx_Report_BillOrder') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Report_BillOrder
GO

--进货订单和销售订单统计和查询报表

CREATE PROCEDURE pbx_Report_BillOrder
    @VchType INT ,	--单据类型--1时为进货订单,2为销售订单
    @CMode CHAR(2) ,	--L--单据列表, 统计方式：P-商品，B-单位，E-经手人,后面加'D'为对应明细列表
    @BeginDate VARCHAR(50) ,
    @EndDate VARCHAR(50) ,
    @TypeID VARCHAR(50) ,--单位、商品或职员的ID号
    @PTypeId VARCHAR(50) ,
    @BTypeId VARCHAR(50) ,
    @ETypeId VARCHAR(50) ,
    @KTypeId VARCHAR(50) ,
    @OperatorID VARCHAR(50)
AS 
    DECLARE @sql VARCHAR(8000)
    
    --L.单据列表
    IF @CMode = 'L' 
        BEGIN
            SET @SQL = 'SELECT  m.*, v.VFullname
						FROM    dbo.tbx_Bill_Order_M m
								LEFT JOIN dbo.tbx_Base_Vtype v ON m.VchType = v.VchType
						WHERE m.VchType = ' + CAST(@VchType AS VARCHAR(20))
        END
    PRINT ( @SQL )
    EXEC(@SQL)
GO



IF OBJECT_ID('dbo.pbx_Report_BillVch') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Report_BillVch
GO

--进货单和销售单统计和查询报表

CREATE PROCEDURE pbx_Report_BillVch
    @VchType INT ,	--单据类型--1时为进货订单,2为销售订单
    @CMode CHAR(2) ,	--L--单据列表, 统计方式：P-商品，B-单位，E-经手人,后面加'D'为对应明细列表
    @BeginDate VARCHAR(50) ,
    @EndDate VARCHAR(50) ,
    @TypeID VARCHAR(50) ,--单位、商品或职员的ID号
    @PTypeId VARCHAR(50) ,
    @BTypeId VARCHAR(50) ,
    @ETypeId VARCHAR(50) ,
    @KTypeId VARCHAR(50) ,
    @OperatorID VARCHAR(50)
AS 
    DECLARE @sql VARCHAR(8000)
    
    --L.单据列表
    IF @CMode = 'L' 
        BEGIN
            SET @SQL = 'SELECT  m.*, v.VFullname
						FROM    dbo.tbx_Bill_M m
								LEFT JOIN dbo.tbx_Base_Vtype v ON m.VchType = v.VchType
						WHERE m.VchType = ' + CAST(@VchType AS VARCHAR(20))
        END
    PRINT ( @SQL )
    EXEC(@SQL)
GO



IF OBJECT_ID('dbo.pbx_Stock_LoadIni') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_LoadIni
go

--查询期初库存商品信息

CREATE PROCEDURE pbx_Stock_LoadIni
    (
      @ParPTypeId VARCHAR(50) ,
      @KTypeId VARCHAR(50) ,
      @Operator VARCHAR(50)    --操作员ID
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    
    DECLARE @id_len INT ,
        @NewParPTypeId VARCHAR(50)

    IF @ParPTypeId = '' 
        SET @ParPTypeId = '00000'
        
    IF @ParPTypeId = '00000'
        OR @ParPTypeId = '%' 
        SELECT  @id_len = 5, @NewParPTypeId = '%'
    ELSE 
        BEGIN
            SELECT  @id_len = LEN(@ParPTypeId) + 5, @NewParPTypeId = @ParPTypeId + '%'	
        END 
       
        
    IF @KTypeId = '00000'
        OR @KTypeId = '' 
        SELECT  @KTypeId = '%'
    ELSE 
        SELECT  @KTypeId = @KTypeId + '%'
        
    SELECT  bp.*, ISNULL(Qty, 0) Qty, ISNULL(Total, 0) Total, ISNULL(GoodsOrderId, 0) GoodsOrderId, CASE WHEN QTY <> 0 THEN dbo.Fun_CovTotalDivQty(Total, Qty)
                                                                                                         ELSE 0
                                                                                                    END Price
    FROM    ( SELECT    p.PTypeId, p.PUsercode, p.PFullname, p.Parid, p.RowIndex
              FROM      dbo.tbx_Base_Ptype p
              WHERE     p.ptypeid LIKE CASE WHEN @ParPTypeId = '00000' THEN ''
                                            ELSE @ParPTypeId
                                       END + '%'
                        AND deleted = 0
            ) bp
            LEFT JOIN ( SELECT  LEFT(sg.PTypeId, @id_len) PTypeId, SUM(Qty) Qty, SUM(Total) Total, MIN(CASE WHEN LEN(LEFT(sg.PTypeId, @id_len)) < LEN(sg.PTypeId) THEN 0
                                                                                                            ELSE GoodsOrderId
                                                                                                       END) GoodsOrderId
                        FROM    dbo.tbx_Stock_Goods_Ini sg
                        WHERE   sg.KTypeId LIKE '%'
                                AND sg.PTypeId LIKE '%'
                        GROUP BY LEFT(sg.PTypeId, @id_len)
                      ) sgi ON bp.PTypeId = sgi.PTypeId
    WHERE   bp.Parid = @ParPTypeId
    ORDER BY bp.RowIndex 
            
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Stock_ModifyIni') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_ModifyIni
go

-- 期初商品库存修改

CREATE PROCEDURE pbx_Stock_ModifyIni
    (
      @PTypeId VARCHAR(25) ,
      @KTypeId VARCHAR(25) ,
      @Qty NUMERIC(22, 10) ,
      @Total NUMERIC(22, 10) ,
      @Memo VARCHAR(255) ,    --序列号说明
      @JobNumber VARCHAR(20) ,     --批号（查询序列号时用）
      @OrderID INT OUTPUT ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @InitOver INT
    
    SELECT  @InitOver = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = 'InitOver'
    
    IF ISNULL(@InitOver, 0) = 1
    BEGIN
		SET @ErrorValue='已经开账，不能修改期初数据！'
		GOTO ErrorGeneral 	
    END
    
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND PSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '该商品已经被删除或者分类！'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ktype
                    WHERE   KTypeId = @KTypeId
                            AND KSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '该仓库已经被删除或者分类！'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND Costmode = 0 ) 
        BEGIN
            SET @ErrorValue = '该商品成本算法已经被更改！'	
            GOTO ErrorGeneral
        END

    DELETE  FROM dbo.tbx_Stock_Goods_Ini
    WHERE   PTypeId = @PTypeId
            AND KTypeId = @KTypeId
            
    IF ( @Qty = 0 ) 
        GOTO Success
        
    INSERT  dbo.tbx_Stock_Goods_Ini ( PTypeId, KTypeId, Qty, Price, Total )
    VALUES  ( @PTypeId, @KTypeId, @Qty, dbo.Fun_CovTotalDivQty(@Total, @Qty), @Total )

    SET @Return = @@ERROR
    IF @@ROWCOUNT = 0 
        GOTO OtherError
	
    SET @OrderID = @@IDENTITY
    
    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
    
    OtherError:
    RETURN @Return
GO



IF OBJECT_ID('dbo.pbx_Stock_OneCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_OneCheck
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Stock_OneCheck
--  ||   过程功能：获取或者增加一个盘点数据标记
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Stock_OneCheck
    (
      @KTypeId VARCHAR(50) , --仓库ID
      @ETypeid VARCHAR(50) , --操作员ID
      @CheckDate VARCHAR(10) OUTPUT , --盘点日期
      @Updatetag INT OUT ,  --盘点号
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF @CheckDate = '' 
        BEGIN
            SELECT  @Updatetag = MIN(UpdateTag)
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0
                    AND KTypeId = @KTypeId
                    
            SELECT  @Updatetag = UpdateTag, @CheckDate = CheckDate
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag = @Updatetag 
        END
    ELSE 
        BEGIN   -- first
            SELECT  @UpdateTag = ISNULL(MIN(UpdateTag), 0)
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0
                    AND KTypeId = @KTypeId
                    
            IF @UpdateTag <> 0 
                BEGIN
                    SELECT  @Updatetag = UpdateTag, @CheckDate = CheckDate
                    FROM    dbo.tbx_Stock_Check
                    WHERE   UpdateTag = @UpdateTag  
                    GOTO Success
                END
                
            SELECT  @Updatetag = ( ISNULL(MIN(UpdateTag), -1000000) - 1 )
            FROM    dbo.tbx_Stock_Check
            WHERE   updatetag < 0 
            --IF @CheckDate < dbo.f_getCurYearPerStart(0) 
            --    GOTO error102
                
            SELECT  @Updatetag = ( ISNULL(MIN(UpdateTag), -1000000) - 1 )
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0 
            
            INSERT  INTO dbo.tbx_Stock_Check ( KTypeId, PTypeId, CheckDate, UpdateTag, ETypeId )
            VALUES  ( @KTypeId, '', @CheckDate, @Updatetag, @ETypeid )
            
            IF @@RowCount = 0 
                GOTO ErrorGeneral
            ELSE 
                GOTO Success

        END

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO



IF OBJECT_ID('dbo.pbx_Stock_QryCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_QryCheck
go

--查询盘点

CREATE PROCEDURE pbx_Stock_QryCheck
    (
      @KTypeId VARCHAR(50) , --仓库ID
      @ETypeid VARCHAR(50) , --操作员ID
      @CheckDate VARCHAR(10) , --盘点日期
      @Updatetag INT ,  --盘点号
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    SELECT  *
    FROM    dbo.tbx_Stock_Check sc LEFT JOIN dbo.tbx_Base_Ptype bp ON sc.PTypeId = bp.PTypeId
    WHERE   ISNULL(sc.PTypeId, '') <> ''
            AND sc.UpdateTag = @Updatetag
            
    --EXEC(@aSQL)        
    RETURN 0

GO 



IF OBJECT_ID('dbo.pbx_Stock_SaveCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_SaveCheck
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Stock_SaveCheck                                                
--  ||   过程功能：保存一条盘点记录
--  ********************************************************************************************

CREATE PROCEDURE pbx_Stock_SaveCheck
    (
      @KTypeId VARCHAR(50) ,
      @PTypeId VARCHAR(50) ,
      @GoodsOrder INT , --对应库存表中的Goodsorder字段
      @CheckedQty NUMERIC(22, 10) ,--盘点数量
      @UpdateTag INT ,--盘点号
      @CheckDate VARCHAR(10) ,--盘点日期
      @SCId INT ,
      @JobNumber VARCHAR(20) ,--批号
      @OutFactoryDate VARCHAR(13) ,--生产日期
      @Total NUMERIC(22, 10) ,--
      @ETypeId VARCHAR(50) ,--操作员
      --下面面是基本信息必须的参数
      @errorValue VARCHAR(500) OUTPUT --返回错误信息
    )
AS 
    SET NOCOUNT ON
	
    DECLARE @CostMode INT
    DECLARE @StockQty NUMERIC(22, 10) --库存量
    
    SELECT  @CostMode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @PTypeId
	
	SET @StockQty = 0
	
    BEGIN TRAN insertproc
    
    IF @SCId = 0 
        BEGIN
            INSERT  INTO dbo.tbx_Stock_Check ( KTypeId, PTypeId, GoodsOrder, CostMode, CheckedQty, UpdateTag, StockQty, CheckDate, JobNumber, OutFactoryDate, Total, ETypeId )
            VALUES  ( @KTypeId, @PTypeId, @GoodsOrder, @CostMode, @CheckedQty, @UpdateTag, @StockQty, @CheckDate, @JobNumber, @OutFactoryDate, @Total, @ETypeId )	
        END
    ELSE 
        BEGIN
            UPDATE  dbo.tbx_Stock_Check
            SET     KTypeId = @KTypeId, PTypeId = @PTypeId, GoodsOrder = @GoodsOrder,
					CostMode = @CostMode, CheckedQty = @CheckedQty, UpdateTag = @UpdateTag,
					StockQty = @StockQty, CheckDate = @CheckDate, JobNumber = @JobNumber,
					OutFactoryDate = @OutFactoryDate, Total = @Total, ETypeId = @ETypeId
            WHERE   SCId = @SCId 
        END 
        
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



IF OBJECT_ID('dbo.pbx_Sys_CheckTbxCfg') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_CheckTbxCfg
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Sys_CheckTbxCfg                                                 
--  ||   过程功能：表加入或删除到配置中
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @CheckType 		VARCHAR		:操作类型					IN
--  ||            @errorValue 		VARCHAR	    :错误信息					IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Sys_CheckTbxCfg
    (
      @CheckType VARCHAR(10) ,
      @errorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @MaxIndex INT
    
    IF @CheckType = 'Insert' 
        BEGIN
            SELECT  @MaxIndex = ISNULL(MAX(TbxRowIndex), 0) FROM dbo.tbx_Sys_TbxCfg 
            
            INSERT dbo.tbx_Sys_TbxCfg ( TbxId, TbxName, TbxType, TbxRowIndex, TbxComment)
			SELECT  so.id, so.name, -1, @MaxIndex + row_number() over (order by tbxId) as rowid, '系统自动添加'
			FROM    SysObjects so LEFT JOIN tbx_Sys_TbxCfg tst ON tst.TbxId = so.id   
			WHERE   XType = 'U' AND (tst.TbxId IS NULL)
        END
        
    IF @CheckType = 'Del' 
        BEGIN
			DELETE  dbo.tbx_Sys_TbxCfg
			WHERE   TbxId NOT IN ( SELECT   id
								   FROM     SysObjects
								   WHERE    XType = 'U')
        END
        
    RETURN 0

go





IF OBJECT_ID('dbo.pbx_Sys_GetParam') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_GetParam
GO

--获取系统参数

CREATE PROCEDURE pbx_Sys_GetParam
    (
      @PName VARCHAR(30) ,
      @ValueReturn VARCHAR(1000) OUTPUT
    )
AS 
    SET NOCOUNT OFF

    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.tbx_Sys_Param
                    WHERE   PName = @PName ) 
        BEGIN
            INSERT  INTO dbo.tbx_Sys_Param ( PName )
            VALUES  ( @PName ) 
        END

        
    SELECT  @ValueReturn = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = @PName
    
    RETURN 0

GO



IF OBJECT_ID('dbo.pbx_Sys_InitOver') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_InitOver
go

-- 开帐、反开帐

CREATE PROCEDURE pbx_Sys_InitOver
    (
      @DoType INT ,--0:反开账,1:开账
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @IsInitOver INT
    
    IF @DoType = 1 
        BEGIN
            SELECT  @IsInitOver = PValue
            FROM    dbo.tbx_Sys_Param
            WHERE   PName = 'InitOver'
            IF @IsInitOver = 1 
                BEGIN
                    SET @ErrorValue = '系统已经开账，可以作账了，不能再开账'
                    GOTO ErrorGeneral
                END
                
            DELETE  dbo.tbx_Stock_Goods_Ini
            WHERE   Qty = 0 AND Total = 0
            IF @@ERROR <> 0 
                BEGIN
                    SET @ErrorValue = '删除期初库存失败'
                    GOTO ErrorGeneral
                END
                
            BEGIN TRAN InitOver
            --设置开帐标志
            UPDATE  dbo.tbx_Sys_Param SET PValue = '1' WHERE PName = 'InitOver'
            IF @@ERROR <> 0 goto ErrorRollback		
            
            --将期初库存复制到库存库
            TRUNCATE TABLE dbo.tbx_Stock_Goods
            SET IDENTITY_INSERT tbx_Stock_Goods ON
            INSERT  INTO dbo.tbx_Stock_Goods ( GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder )
                    SELECT  GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder
                    FROM    dbo.tbx_Stock_Goods_Ini 
            SET IDENTITY_INSERT tbx_Stock_Goods OFF
            
            --  修改aType库存商品应收应付
            --	计算储值余额
            --	写入期初资本
            COMMIT TRAN InitOver
        END
    ELSE 
        BEGIN
			BEGIN TRAN InitOver
            --设置开帐标志
            UPDATE  dbo.tbx_Sys_Param SET PValue = '0' WHERE PName = 'InitOver'
            
			TRUNCATE TABLE dbo.tbx_Stock_Goods
			
            COMMIT TRAN InitOver
        END
    
    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN InitOver 
    RETURN -2 
GO



IF OBJECT_ID('dbo.pbx_Sys_ModfifyTbx') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ModfifyTbx
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Sys_ModfifyTbx                                                 
--  ||   过程功能：修改表格配置信息                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ModfifyTbx
    (
      @TbxId VARCHAR(50) ,
      @TbxDefName VARCHAR(50) ,
      @TbxType VARCHAR(66) ,
      @TbxComment VARCHAR(50) ,
      --下面面是必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    SET nocount ON

      
    UPDATE  dbo.tbx_Sys_TbxCfg
    SET TbxDefName = @TbxDefName, TbxType = @TbxType, TbxComment = @TbxComment
    WHERE TbxId = @TbxId
      
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO Success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
GO



IF OBJECT_ID('dbo.pbx_Sys_ReBuild') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ReBuild
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Sys_ReBuild                                                 
--  ||   过程功能：系统重建                                          
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ReBuild
    (
      @ClearStock INT ,--清除库存商品和会计科目的期初值
      @ClearBak INT ,--清除草稿库
      --下面面是必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    SET NOCOUNT ON
    
    BEGIN TRAN DelBill
	
    TRUNCATE TABLE dbo.tbx_Bill_Order_M
    TRUNCATE TABLE dbo.tbx_Bill_Order_D
    TRUNCATE TABLE dbo.tbx_Bill_M
    TRUNCATE TABLE dbo.tbx_Bill_D_Bak
    TRUNCATE TABLE dbo.tbx_Bill_Buy_D
    TRUNCATE TABLE dbo.tbx_Bill_Sale_D
    TRUNCATE TABLE dbo.tbx_Bill_Other_D
    TRUNCATE TABLE dbo.tbx_Bill_NumberRecords
    
    TRUNCATE TABLE dbo.tbx_Bill_A_D
    TRUNCATE TABLE dbo.tbx_Bill_A_Gathering
        
    IF @ClearStock = 1
    BEGIN
		TRUNCATE TABLE dbo.tbx_Stock_Goods
		TRUNCATE TABLE dbo.tbx_Stock_Goods_Ini
		TRUNCATE TABLE dbo.tbx_Stock_Glide	
		TRUNCATE TABLE dbo.tbx_Stock_Check
    END
    
    UPDATE dbo.tbx_Sys_Param SET PValue = '0' WHERE PName = 'InitOver'
      
    COMMIT TRAN DelBill
    
    GOTO Success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN DelBill
    RETURN -2 
go



IF OBJECT_ID('dbo.pbx_Sys_SetParam') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_SetParam
GO

--设置系统参数

CREATE PROCEDURE pbx_Sys_SetParam
    (
      @PName VARCHAR(30) ,
      @PValue VARCHAR(1000)
    )
AS 
    SET NOCOUNT OFF

    IF EXISTS ( SELECT  1
                FROM    dbo.tbx_Sys_Param
                WHERE   PName = @PName ) 
        UPDATE  dbo.tbx_Sys_Param
        SET     PValue = @PValue
        WHERE   PName = @PName 
    ELSE 
        INSERT  INTO dbo.tbx_Sys_Param ( PName, PValue )
        VALUES  ( @PName, @PValue )
    
    RETURN 0

GO



