IF OBJECT_ID('dbo.pbx_Sys_CheckTbxCfg') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_CheckTbxCfg
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Sys_CheckTbxCfg                                                 
--  ||   过程功能：表加入或删除到配置中
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @CheckType 		VARCHAR		:操作类型					IN
--  ||            @errorValue 		VARCHAR	    :错误信息					IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Sys_CheckTbxCfg
    (
      @CheckType VARCHAR(10) ,
      @errorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @MaxIndex INT
    
    IF @CheckType = 'Insert' 
        BEGIN
            SELECT  @MaxIndex = ISNULL(MAX(TbxRowIndex), 0) FROM dbo.tbx_Sys_TbxCfg 
            
            INSERT dbo.tbx_Sys_TbxCfg ( TbxId, TbxName, TbxType, TbxRowIndex, TbxComment)
			SELECT  so.id, so.name, -1, @MaxIndex + row_number() over (order by tbxId) as rowid, '系统自动添加'
			FROM    SysObjects so LEFT JOIN tbx_Sys_TbxCfg tst ON tst.TbxId = so.id   
			WHERE   XType = 'U' AND (tst.TbxId IS NULL)
        END
        
    IF @CheckType = 'Del' 
        BEGIN
			DELETE  dbo.tbx_Sys_TbxCfg
			WHERE   TbxId NOT IN ( SELECT   id
								   FROM     SysObjects
								   WHERE    XType = 'U')
        END
        
    RETURN 0

go


