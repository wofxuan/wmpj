IF OBJECT_ID('dbo.pbx_Fun_SplitStr') IS NOT NULL 
    DROP FUNCTION dbo.pbx_Fun_SplitStr
go


CREATE FUNCTION pbx_Fun_SplitStr
    (
      @Str VARCHAR(8000) ,   --待分拆的字符串
      @Split VARCHAR(10)     --数据分隔符
    )
RETURNS @Re TABLE
    (
      ID INT IDENTITY ,
      Col VARCHAR(8000)
    )
AS 
    BEGIN
        DECLARE @Splitlen INT
        SET @Splitlen = LEN(@Split + 'a') - 2
        WHILE CHARINDEX(@Split, @Str) > 0 
            BEGIN
                INSERT  @re
                VALUES  ( LEFT(@Str, CHARINDEX(@Splitlen, @Str) - 1) )
                SET @Str = STUFF(@Str, 1, CHARINDEX(@Splitlen, @Str) + @Splitlen, '')
            END
        INSERT  @Re
        VALUES  ( @Str )
        RETURN
    END

go
