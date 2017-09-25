IF OBJECT_ID('dbo.pbx_Login') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Login
GO

CREATE PROCEDURE pbx_Login
    (
      @userName VARCHAR(20) ,
      @userPSW VARCHAR(60) ,
      @errorValue VARCHAR(100) OUTPUT ,
      @userId VARCHAR(50) OUTPUT
    )
AS
    SET NOCOUNT ON

    DECLARE @idtemp VARCHAR(50)
    SELECT  @idtemp = ''

    SELECT  @idtemp = ETypeId
    FROM    dbo.tbx_Base_Etype
    WHERE   ( EFullname = @userName
              OR EUsercode = @userName
            )

    IF ( ISNULL(@idtemp, '') = '' )
        BEGIN
            SET @errorValue = '’À∫≈≤ª¥Ê‘⁄ªÚ√‹¬Î¥ÌŒÛ'
            RETURN -1
        END

    SET @userId = @idtemp

    RETURN 0

GO
