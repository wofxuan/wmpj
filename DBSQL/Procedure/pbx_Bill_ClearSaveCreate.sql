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