IF OBJECT_ID('dbo.pbx_Flow_Del') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_Del
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Flow_Del
--  ||   过程功能：删除流程
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Flow_Del
    (
      @TaskID INT , --流程作业ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    DELETE  dbo.tbx_Flow_ProcePermi
    WHERE   ProcessID IN ( SELECT   ProcessID
                           FROM     dbo.tbx_Flow_Process a
                                    LEFT JOIN dbo.tbx_Flow_TaskProc b ON a.TaskProcID = b.TaskProcID
                           WHERE    b.TaskID = @TaskID )

    DELETE  dbo.tbx_Flow_Process
    WHERE   TaskProcID IN ( SELECT  TaskProcID
                            FROM    dbo.tbx_Flow_TaskProc
                            WHERE   TaskID = @TaskID )


    DELETE  dbo.tbx_Flow_TaskProc
    WHERE   TaskID = @TaskID 
	
    GOTO Success

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
