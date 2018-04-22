IF OBJECT_ID('dbo.pbx_Flow_AddWork') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_AddWork
GO

--增加一条单据或者其它的审核

CREATE PROCEDURE pbx_Flow_AddWork
    (
      @CETypeId VARCHAR(50) ,  --新增这个审核的职员ID
      @Info VARCHAR(255) , --摘要信息,自动生成,方便汇总处理时查看
      @WorkID VARCHAR(50) ,--与具体业务功能模块关联的Id,如单据的MoudelNo等
      @BillID INT ,--要审核的记录的ID
      @BillType INT ,--要审核的记录的类型，可能同一个窗体，多个功能
      @TaskProcID INT ,--使用的流程作业ID表,0就使用默认的流程作业
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

   
    DECLARE @SetWorkID VARCHAR(50)    
	
    IF EXISTS ( SELECT TOP 1
                        ProcePathID
                FROM    dbo.tbx_Flow_ProcePath
                WHERE   WorkID = @WorkID
                        AND BillID = @BillID
                        AND BillType = @BillType )
        BEGIN
            SET @ErrorValue = '此记录已经存在审批流程'
            RETURN -1
        END

    IF ( @TaskProcID <> 0 )
        BEGIN
            SELECT  @SetWorkID = b.WorkID
            FROM    dbo.tbx_Flow_TaskProc a
                    LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
            WHERE   a.TaskProcID = @TaskProcID   
        END
    ELSE
        BEGIN
            SELECT  @SetWorkID = b.WorkID, @TaskProcID = a.TaskProcID
            FROM    dbo.tbx_Flow_TaskProc a
                    LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
            WHERE   a.DefaultProc = 1   
        END


    IF ( @SetWorkID <> @WorkID )
        BEGIN
            SET @ErrorValue = '选择的流程作业与业务功能模块不匹配'
            RETURN -1
        END     

    IF NOT EXISTS ( SELECT TOP 1
                            ProcessID
                    FROM    dbo.tbx_Flow_Process
                    WHERE   TaskProcID = @TaskProcID )
        BEGIN
            SET @ErrorValue = '选择的流程作业没有具体审批项目'
            RETURN -1
        END

    INSERT  dbo.tbx_Flow_ProcePath ( ProcessID, BillID, BillType, WorkID, FlowETypeID, ProceResult, Info, CreaterETypeID, CreateTime )
    SELECT  fp.ProcessID, @BillID, @BillType, @WorkID, fpp.OperId, '', @Info, @CETypeId, CONVERT(VARCHAR, GETDATE(), 120)
    FROM    dbo.tbx_Flow_Process fp
            LEFT JOIN dbo.tbx_Flow_ProcePermi fpp ON fpp.ProcessID = fp.ProcessID
            LEFT JOIN dbo.tbx_Flow_TaskProc ft ON ft.TaskProcID = fp.TaskProcID
    WHERE   ft.TaskProcID = @TaskProcID
    ORDER BY fp.ProceOrder 

    --EXEC(@aSQL)        
    RETURN 0

GO 
