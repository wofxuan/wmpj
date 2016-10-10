IF OBJECT_ID('dbo.pbx_Limit_Save_RA') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RA
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Limit_Save_RA
--  ||   过程功能：增加或者修改一个角色的一条权限记录
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RA
    (
      @LAGUID VARCHAR(50) , --权限功能ID
      @RUID VARCHAR(50) , --角色或用户ID
      @RUType INT, --0未定义，1角色ID，2用户ID
      @LimitValue INT ,  --权限值
      
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
	IF EXISTS(SELECT * FROM dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType)
	BEGIN
		IF (@LimitValue <> 0) 
		BEGIN
			UPDATE dbo.tbx_Limit_Action_Role
			SET LimitValue = @LimitValue
			WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType 
		END	
		ELSE
		BEGIN
			DELETE dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType  
		END
	END
	ELSE 
	BEGIN
		INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
		VALUES  ( @LAGUID, @RUID, @RUType, @LimitValue)	
	END
	

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
