IF OBJECT_ID('dbo.pbx_Fun_CovToPrice') IS NOT NULL 
    DROP FUNCTION dbo.pbx_Fun_CovToPrice
go

CREATE   FUNCTION pbx_Fun_CovToPrice( @nprice NUMERIC(22, 10) )
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
