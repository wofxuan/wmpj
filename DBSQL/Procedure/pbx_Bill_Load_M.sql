IF OBJECT_ID('dbo.pbx_Bill_Load_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Load_M
go

--װ��һ��������������

CREATE PROCEDURE pbx_Bill_Load_M
    (
      @VchCode INT ,
      @VchType INT
    )
AS 
    SET NOCOUNT ON

    IF @VchType IN ( 1, 2 ) --����
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
