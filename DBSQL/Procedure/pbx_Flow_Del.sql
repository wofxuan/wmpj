IF OBJECT_ID('dbo.pbx_Flow_Del') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_Del
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Flow_Del
--  ||   ���̹��ܣ�ɾ������
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Flow_Del
    (
      @TaskID INT , --������ҵID
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

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1  


GO
