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
