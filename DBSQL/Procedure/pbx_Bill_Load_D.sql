IF OBJECT_ID('dbo.pbx_Bill_Load_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Load_D
go

--单据查询明细

CREATE PROCEDURE pbx_Bill_Load_D
    (
      @DBName VARCHAR(50) ,
      @VchCode NUMERIC(10, 0) ,
      @UsedType VARCHAR(1)--是否自动生成的记录,在调拨的时候会多生成一条对应另外仓库的记录, 1是原记录, 2是系统生成的记录
    )
AS 
    SET NOCOUNT ON

    IF @DBName = 'tbx_Bill_Order_D' 
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Bill_Order_D d LEFT JOIN dbo.tbx_Base_Ptype p ON d.PtypeId = p.PTypeId
            WHERE   d.VchCode = @VchCode
            ORDER BY d.DlyOrder 
        END
    ELSE 
        IF @dbname = 'tbx_Bill_Buy_D' 
            BEGIN
                SELECT  *
                FROM    dbo.tbx_Bill_Buy_D d LEFT JOIN dbo.tbx_Base_Ptype p ON d.PtypeId = p.PTypeId
                WHERE   d.VchCode = @VchCode
                ORDER BY d.DlyOrder 
            END
    RETURN 0

GO 
