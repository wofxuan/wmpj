IF OBJECT_ID('dbo.Fun_CovToQty') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovToQty
go

CREATE   FUNCTION Fun_CovToQty ( @nQty NUMERIC(22, 10) )
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
