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
