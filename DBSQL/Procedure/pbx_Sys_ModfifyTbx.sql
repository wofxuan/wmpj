IF OBJECT_ID('dbo.pbx_Sys_ModfifyTbx') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ModfifyTbx
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Sys_ModfifyTbx                                                 
--  ||   过程功能：修改表格配置信息                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ModfifyTbx
    (
      @TbxId VARCHAR(50) ,
      @TbxDefName VARCHAR(50) ,
      @TbxType VARCHAR(66) ,
      @TbxComment VARCHAR(50) ,
      --下面面是必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    SET nocount ON

      
    UPDATE  dbo.tbx_Sys_TbxCfg
    SET TbxDefName = @TbxDefName, TbxType = @TbxType, TbxComment = @TbxComment
    WHERE TbxId = @TbxId
      
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
