IF OBJECT_ID('dbo.pbx_Fun_CovToQty') IS NOT NULL 
    DROP FUNCTION dbo.pbx_Fun_CovToQty
go

CREATE   FUNCTION pbx_Fun_CovToQty ( @nQty NUMERIC(22, 10) )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @ditQty INT
        SELECT  @ditQty = DitDefValue
        FROM    tbx_Sys_DitDef
        WHERE   DitDefName = 'DitQty'
        RETURN ROUND(@nQty,@ditQty)
    END
GO
