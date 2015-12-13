IF OBJECT_ID('dbo.Fun_SplitStr') IS NOT NULL 
    DROP FUNCTION dbo.Fun_SplitStr
go


CREATE FUNCTION Fun_SplitStr
    (
      @Str VARCHAR(8000) ,   --���ֲ���ַ���
      @Split VARCHAR(10)     --���ݷָ���
    )
RETURNS @Re TABLE
    (
      ID INT IDENTITY ,
      Col VARCHAR(8000)
    )
AS 
    BEGIN
        DECLARE @SplitLen INT
        SET @SplitLen = LEN(@Split + 'a') - 2
        WHILE CHARINDEX(@Split, @Str) > 0 
            BEGIN
                INSERT  @re
                VALUES  ( LEFT(@Str, CHARINDEX(@Split, @Str) - 1) )
                SET @Str = STUFF(@Str, 1, CHARINDEX(@Split, @Str) + @SplitLen, '')
            END
        INSERT  @re
        VALUES  ( @Str )
        RETURN
    END

go

