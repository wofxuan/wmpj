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
