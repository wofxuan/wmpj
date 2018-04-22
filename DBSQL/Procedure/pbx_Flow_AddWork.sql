IF OBJECT_ID('dbo.pbx_Flow_AddWork') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_AddWork
GO

--����һ�����ݻ������������

CREATE PROCEDURE pbx_Flow_AddWork
    (
      @CETypeId VARCHAR(50) ,  --���������˵�ְԱID
      @Info VARCHAR(255) , --ժҪ��Ϣ,�Զ�����,������ܴ���ʱ�鿴
      @WorkID VARCHAR(50) ,--�����ҵ����ģ�������Id,�絥�ݵ�MoudelNo��
      @BillID INT ,--Ҫ��˵ļ�¼��ID
      @BillType INT ,--Ҫ��˵ļ�¼�����ͣ�����ͬһ�����壬�������
      @TaskProcID INT ,--ʹ�õ�������ҵID��,0��ʹ��Ĭ�ϵ�������ҵ
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
            SET @ErrorValue = '�˼�¼�Ѿ�������������'
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
            SET @ErrorValue = 'ѡ���������ҵ��ҵ����ģ�鲻ƥ��'
            RETURN -1
        END     

    IF NOT EXISTS ( SELECT TOP 1
                            ProcessID
                    FROM    dbo.tbx_Flow_Process
                    WHERE   TaskProcID = @TaskProcID )
        BEGIN
            SET @ErrorValue = 'ѡ���������ҵû�о���������Ŀ'
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
