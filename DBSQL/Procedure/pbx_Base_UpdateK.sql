IF OBJECT_ID('dbo.pbx_Base_UpdateK') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateK
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Base_UpdateE                                                 
--  ||   ���̹��ܣ��޸Ļ�����Ϣ--ְԱ                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateK
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --�����ǻ�����Ϣ����Ĳ��� ,
      @Name VARCHAR(66) ,--���
      @Address VARCHAR(256) ,--��ַ
      @Person VARCHAR(100) ,--������
      @Tel VARCHAR(50) ,--�����˵绰
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
	
    SELECT  @dbname = 'tbx_Base_Ktype'

    IF EXISTS ( SELECT  [Kusercode]
                FROM    tbx_Base_Ktype
                WHERE   KtypeId <> '00000'
                        AND [KtypeId] <> @typeid
                        AND [Kusercode] = @usercode
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
      
    UPDATE  dbo.tbx_Base_Ktype
    SET     [Parid] = @Parid, [KUsercode] = @UserCode, [KFullname] = @FullName, [KComment] = @Comment, 
			[Name] = @Name, [Address] = @Address, [Person] = @Person, [Tel] = @Tel, 
			[IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   KTypeId = @typeId
      
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
