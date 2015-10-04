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
