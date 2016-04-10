IF OBJECT_ID('dbo.Fun_StrToNumeric') IS NOT NULL 
    DROP FUNCTION dbo.Fun_StrToNumeric
go

CREATE   FUNCTION Fun_StrToNumeric
    (
      @StrValues VARCHAR(8000) ,
      @DefValues NUMERIC(22, 10)
    )
RETURNS NUMERIC(22, 10)
AS 
    BEGIN
        RETURN CAST(ISNULL(@StrValues, @DefValues) AS NUMERIC(22, 10))
    END
GO
