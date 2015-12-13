IF OBJECT_ID('dbo.Fun_TypeIDIntToStr') IS NOT NULL 
    DROP PROCEDURE dbo.Fun_TypeIDIntToStr
go

CREATE PROCEDURE Fun_TypeIDIntToStr
    (
      @nInput INT ,
      @szId VARCHAR(5) OUTPUT
    )
AS 
    SET nocount ON

    IF @nInput > 99999 
        BEGIN
            RETURN -1
        END

    DECLARE @sztemp VARCHAR(6)

    SELECT  @sztemp = STR(@nInput) + 100000
    SELECT  @szId = RIGHT(@sztemp, 5)


go
