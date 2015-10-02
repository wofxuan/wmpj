IF OBJECT_ID('dbo.pbx_Base_UpdateE') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateE
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Base_UpdateE                                                 
--  ||   ���̹��ܣ��޸Ļ�����Ϣ--ְԱ                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateE
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --�����ǻ�����Ϣ����Ĳ��� ,
      @DTypeId VARCHAR(50) ,--��������
      @Tel VARCHAR(20) ,--�绰
      @Address VARCHAR(80) ,--��ַ
      @Birthday VARCHAR(10) ,--����
      @EMail VARCHAR(100) ,--EMail
      @Job VARCHAR(100) ,--ְλ
      @TopTotal NUMERIC(22, 10) ,--ÿ���Ż��޶�
      @LowLimitDiscount NUMERIC(22, 10) ,--����ۿ�����
      @IsStop INT ,
      --�������ǻ�����Ϣ����Ĳ���
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Etype'

    IF EXISTS ( SELECT  [Eusercode]
                FROM    tbx_Base_Etype
                WHERE   EtypeId <> '00000'
                        AND [EtypeId] <> @typeid
                        AND [Eusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '�ü�¼�ı�Ż�ȫ����������¼��ͬ,���ܸ��£�'
            GOTO ErrorGeneral
        END


	--���Ҷ���Ѿ����ʣ������޸ĳɱ��㷨
	--����Ѿ����ʣ������޸ĳɱ��㷨
    --�ɷǼ�Ȩƽ������Ϊ��Ȩƽ��������ϲ�����
	--�ɼ�Ȩƽ�����ķ�Ϊ��Ȩƽ���������ж��Ƿ��и����

    SET @UpdateTag = 0
    --������Ϣ���±�ʶ  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Etype
    SET     [Parid] = @Parid, [EUsercode] = @UserCode, [EFullname] = @FullName, [EComment] = @Comment, 
			[DTypeId] = @DTypeId, [Tel] = @Tel, [Address] = @Address, [Birthday] = @Birthday, 
			[EMail] = @EMail, [Job] = @Job, [TopTotal] = @TopTotal,
			[LowLimitDiscount] = @LowLimitDiscount, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   ETypeId = @typeId
      
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '���¼�¼����ʧ�ܣ����Ժ����ԣ�'
            GOTO ErrorGeneral
        END
        
    GOTO success    

    Success:		 --�ɹ���ɺ���
    RETURN 0
    
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
