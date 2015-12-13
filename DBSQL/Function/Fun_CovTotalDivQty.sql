IF OBJECT_ID('dbo.Fun_CovTotalDivQty') IS NOT NULL 
    DROP FUNCTION dbo.Fun_CovTotalDivQty
go
				  
CREATE   FUNCTION Fun_CovTotalDivQty
    (
      @nTotal NUMERIC(22, 10) ,
      @nQty NUMERIC(22, 10)
    )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        DECLARE @nprice NUMERIC(22, 10)
        IF ISNULL(@nQty, 0) = 0
            OR ISNULL(@nTotal, 0) = 0 
            SET @nprice = 0
        ELSE 
            SET @nprice = dbo.pbx_Fun_CovToPrice(CAST(@nTotal AS NUMERIC(22, 10)) / CAST(@nQty AS NUMERIC(22, 10)))
        RETURN @nprice 
    END
GO