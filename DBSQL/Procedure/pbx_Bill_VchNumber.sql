IF OBJECT_ID('dbo.pbx_Bill_VchNumber') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_VchNumber
GO

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_VchNumber                                                
--  ||   ���̹��ܣ���ȡ���߼�鵥�ݱ��
--@DoWork=1 �����뵥�ݱ��@VchNumberIn, �������Ƿ�����ͬ�ĵ��ݱ�ţ�
--@DoWork=2 �����뵥�����ͺ����ڣ����ݱ��
--  ********************************************************************************************

CREATE PROCEDURE pbx_Bill_VchNumber
    (
      @DoWork INT ,
      @VchType INT ,
      @OldVchCode INT ,
      @NewVchCode INT ,
      @BillDate VARCHAR(10) ,--��ʽ2008-11-02
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
    SET @LoopType = 1 --1ÿ��ѭ�����
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
                            SET @ErrorValue = '���ѱ���ĵ������Ѿ��д˵��ݱ�ţ����ܱ���!'
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
                                SET @ErrorValue = '���ѱ���ĵ������Ѿ��д˵��ݱ�ţ����ܱ���!'
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
	
    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    --ROLLBACK TRAN insertproc 
    RETURN -2 


go
