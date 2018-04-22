IF OBJECT_ID('dbo.pbx_Flow_QryData') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_QryData
GO

--查询审核

CREATE PROCEDURE pbx_Flow_QryData
    (
      @QryType INT ,  --1流程作业,2流程作业具体项目
      @Custom VARCHAR(500) = '' ,--默认参数 
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @QryType = 1 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_TaskType
            ORDER BY TaskID
        END

    IF ( @QryType = 2 )
        BEGIN
            IF @Custom <> ''
                BEGIN
                    SELECT  *
                    FROM    dbo.tbx_Flow_TaskProc a
                            LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
                    WHERE   a.TaskID = CAST(@Custom AS INT)
                    ORDER BY DefaultProc DESC, a.TaskID
                END  
            ELSE
                BEGIN
                    SELECT  *
                    FROM    dbo.tbx_Flow_TaskProc a
                            LEFT JOIN dbo.tbx_Flow_TaskType b ON b.TaskID = a.TaskID
                    ORDER BY DefaultProc DESC, a.TaskID
                END
        END

    IF ( @QryType = 3 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_Process fp
                    LEFT JOIN dbo.tbx_Flow_TaskProc ft ON fp.TaskProcID = ft.TaskProcID
                    LEFT JOIN dbo.tbx_Flow_TaskType ftt ON ft.TaskID = ftt.TaskID
            WHERE   ftt.TaskID = CAST(@Custom AS INT)
            ORDER BY ft.DefaultProc DESC, fp.TaskProcID, fp.ProceOrder
        END
     
    IF ( @QryType = 4 )
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Flow_Process fp
                    LEFT JOIN dbo.tbx_Flow_TaskProc ft ON fp.TaskProcID = ft.TaskProcID
                    LEFT JOIN dbo.tbx_Flow_TaskType ftt ON ft.TaskID = ftt.TaskID
                    LEFT JOIN dbo.tbx_Flow_ProcePermi ffp ON ffp.ProcessID = fp.ProcessID
                    LEFT JOIN dbo.tbx_Base_Etype e ON ffp.OperId = e.ETypeId
            WHERE   ft.TaskID = CAST(@Custom AS INT)
            ORDER BY ft.DefaultProc DESC, fp.TaskProcID, fp.ProceOrder
        END
      
    IF ( @QryType = 5 )
        BEGIN
            SELECT  fpp.*, e.EFullname AS CEFullname
            FROM    dbo.tbx_Flow_ProcePath fpp
                    LEFT JOIN dbo.tbx_Base_Etype e ON fpp.CreaterETypeID = e.ETypeId
                    LEFT JOIN dbo.tbx_Flow_ProcePath fs ON fs.BillID = fpp.BillID --没得终止的
                                                           AND fs.BillType = fpp.BillType
                                                           AND fs.WorkID = fpp.WorkID
                                                           AND fs.ProceResult = 2
            WHERE   fpp.ProceResult = 0
                    AND fpp.FlowETypeID = @Custom
                    AND fs.ProcePathID IS NULL
            ORDER BY fpp.CreateTime
        END      

    IF ( @QryType = 6 )
        BEGIN
            SET @aSQL = 'SELECT  fh.*, fp.ProcesseName, e.EFullname
						FROM    dbo.tbx_Flow_His fh
								LEFT JOIN dbo.tbx_Flow_ProcePath fpp ON fpp.ProcePathID = fh.ProcePathID
								LEFT JOIN dbo.tbx_Flow_Process fp ON fp.ProcessID = fpp.ProcessID
								LEFT JOIN dbo.tbx_Base_Etype e ON fh.CreaterETypeID = e.ETypeId
						WHERE   ' + @Custom + ' 
						ORDER BY fh.CreateTime'

            EXEC(@aSQL) 
        END  
    IF ( @QryType = 7 )
        BEGIN
            SET @aSQL = 'SELECT  fpp.*, e.EFullname
						FROM    dbo.tbx_Flow_ProcePath fpp LEFT JOIN dbo.tbx_Base_Etype e ON fpp.FlowETypeID = e.ETypeId 
						WHERE   ' + @Custom + ' 
						ORDER BY fpp.ProcePathID'
            EXEC(@aSQL) 
        END            
    RETURN 0

GO 
