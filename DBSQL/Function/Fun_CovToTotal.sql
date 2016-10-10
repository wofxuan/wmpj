IF OBJECT_ID('dbo.Fun_CovToTotal') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovToTotal
go


CREATE   FUNCTION Fun_CovToTotal ( @nTotal NUMERIC(22, 10) )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @ditTotal INT
        SELECT  @ditTotal = DitDefValue
        FROM    tbx_Sys_DitDef
        WHERE   DitDefName = 'DitTotal'
        RETURN ROUND(@nTotal,@ditTotal)
        
    END
GO

