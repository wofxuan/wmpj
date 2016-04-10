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