IF OBJECT_ID('dbo.pbx_Flow_DoOne') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Flow_DoOne
GO

--����һ����˼�¼

CREATE PROCEDURE pbx_Flow_DoOne
    (
      @ETypeId VARCHAR(50) ,  --ְԱ��ID
      @ProcePathID INT ,--tbx_Flow_ProcePath��ID
      @ProceResult INT ,--δ����0��ͨ��1����ֹ2���˻�-1
      @FlowInfo VARCHAR(255) ,--�������
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    DECLARE @BillID INT
    DECLARE @BillType INT
    DECLARE @WorkID VARCHAR(50)

    IF NOT ( EXISTS ( SELECT    *
                      FROM      dbo.tbx_Flow_ProcePath
                      WHERE     ProcePathID = @ProcePathID ) )
        BEGIN
            SET @ErrorValue = 'û���ҵ�����·��'
            RETURN -1
        END
       
    IF ( EXISTS ( SELECT    *
                  FROM      dbo.tbx_Flow_ProcePath
                  WHERE     ProceResult <> 0
                            AND ProcePathID = @ProcePathID ) )
        BEGIN
            SET @ErrorValue = '�Ѿ��������������ظ�����'
            RETURN -1
        END

    SELECT  @BillID = BillID, @BillType = BillType, @WorkID = WorkID
    FROM    dbo.tbx_Flow_ProcePath
    WHERE   ProcePathID = @ProcePathID 

    IF ( EXISTS ( SELECT TOP 1
                            ProcePathID
                  FROM      dbo.tbx_Flow_ProcePath
                  WHERE     BillType = @BillType
                            AND BillID = @BillID
                            AND WorkID = @WorkID
                            AND ProcePathID < @ProcePathID
                            AND ProceResult = 0 ) )
        BEGIN
            SET @ErrorValue = 'ǰ�滹������û��������ɣ�����ɺ�������'
            RETURN -1  
        END

    INSERT  dbo.tbx_Flow_His ( ProcePathID, ProceResult, FlowInfo, CreaterETypeID, CreateTime )
    VALUES  ( @ProcePathID, @ProceResult, @FlowInfo, @ETypeId, CONVERT(VARCHAR, GETDATE(), 120) )

    IF ( @ProceResult = 1 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 1, FlowInfo = @FlowInfo
            WHERE   ProcePathID = @ProcePathID
        END 

    IF ( @ProceResult = 2 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 2, FlowInfo = @FlowInfo
            WHERE   ProcePathID = @ProcePathID
        END 

    IF ( @ProceResult = -1 )
        BEGIN
            UPDATE  dbo.tbx_Flow_ProcePath
            SET     ProceResult = 0, FlowInfo = ''
            WHERE   ProcePathID = ( SELECT TOP 1
                                            ProcePathID
                                    FROM    dbo.tbx_Flow_ProcePath
                                    WHERE   BillType = @BillType
                                            AND BillID = @BillID
                                            AND WorkID = @WorkID
                                            AND ProcePathID < @ProcePathID
                                    ORDER BY ProcePathID DESC
                                  )

			--����ǵ�һ���������˻ؾ�ɾ�����е���������
            IF ( @ProcePathID = ( SELECT TOP 1
                                            ProcePathID
                                  FROM      dbo.tbx_Flow_ProcePath
                                  WHERE     BillType = @BillType
                                            AND BillID = @BillID
                                            AND WorkID = @WorkID
                                  ORDER BY  ProcePathID
                                ) )
                BEGIN
                    DELETE  dbo.tbx_Flow_ProcePath
                    WHERE   BillType = @BillType
                            AND BillID = @BillID
                            AND WorkID = @WorkID
                END
        END  
    --EXEC(@aSQL)        
    RETURN 0

GO 
