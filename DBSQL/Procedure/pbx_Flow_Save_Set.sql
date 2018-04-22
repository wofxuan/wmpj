IF OBJECT_ID('dbo.pbx_Flow_Save_Set') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_Save_Set
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Flow_Save_Set
--  ||   过程功能：配置一个审批流程
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Flow_Save_Set
    (
      @TaskID INT , --流程作业ID
      @TType INT , --单据业务0；人事1；
      @TComment VARCHAR(255) ,--备注
      @TaskProcName VARCHAR(8000) ,--流程名称
      @ProcesseName VARCHAR(8000) ,--项目名称
      @OperType VARCHAR(8000) ,--操作类型，0审核，1知会，2执行。（知会不需要输入审批意见）
      @ProceOrder VARCHAR(8000) ,--项目顺序,从小到大执行
      --@PermiType VARCHAR(8000) ,--0职员
      @OperId VARCHAR(8000) ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'

    UPDATE  tbx_Flow_TaskType
    SET     TType = @TType, TComment = @TComment
    WHERE   TaskID = @TaskID

	--删除原来的记录
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

	--插入新记录
    INSERT  INTO dbo.tbx_Flow_TaskProc ( TaskID, TaskProcName )
    SELECT DISTINCT
            @TaskID, a.Col
    FROM    dbo.Fun_SplitStr(@TaskProcName, @Splitstr) a
    WHERE   ISNULL(a.Col, '') <> ''

    INSERT  INTO dbo.tbx_Flow_Process ( TaskProcID, ProcesseName, OperType, ProceOrder )
    SELECT  DISTINCT
            e.TaskProcID, a.Col, b.Col, c.Col
    FROM    dbo.Fun_SplitStr(@ProcesseName, @Splitstr) a
            LEFT JOIN dbo.Fun_SplitStr(@OperType, @Splitstr) b ON b.ID = a.ID
            LEFT JOIN dbo.Fun_SplitStr(@ProceOrder, @Splitstr) c ON c.ID = a.ID
            LEFT JOIN dbo.Fun_SplitStr(@TaskProcName, @Splitstr) d ON d.ID = a.ID
            LEFT JOIN dbo.tbx_Flow_TaskProc e ON d.Col = e.TaskProcName
    WHERE   ISNULL(c.Col, '') <> '' 

    INSERT  INTO dbo.tbx_Flow_ProcePermi ( ProcessID, PermiType, OperId )
    SELECT  DISTINCT
            b.ProcessID, 0, a.Col1
    FROM    ( SELECT    a1.Col Col1, a2.Col Col2, a3.Col Col3
              FROM      dbo.Fun_SplitStr(@OperId, @Splitstr) a1
                        LEFT JOIN dbo.Fun_SplitStr(@ProcesseName, @Splitstr) a2 ON a2.ID = a1.ID
                        LEFT JOIN dbo.Fun_SplitStr(@TaskProcName, @Splitstr) a3 ON a3.ID = a1.ID
              WHERE     ISNULL(a3.Col, '') <> ''
            ) a
            LEFT JOIN ( SELECT  b1.ProcessID, b1.ProcesseName, b2.TaskProcName
                        FROM    dbo.tbx_Flow_Process b1
                                LEFT JOIN dbo.tbx_Flow_TaskProc b2 ON b2.TaskProcID = b1.TaskProcID
                      ) b ON a.Col2 = b.ProcesseName
                             AND a.Col3 = b.TaskProcName
    WHERE   b.ProcessID IS NOT NULL
			 
    GOTO Success

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
