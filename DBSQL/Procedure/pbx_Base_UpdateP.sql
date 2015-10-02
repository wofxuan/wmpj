IF OBJECT_ID('dbo.pbx_Base_UpdateP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateP
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Base_UpdateP                                                 
--  ||   ���̹��ܣ��޸Ļ�����Ϣ--��Ʒ                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateP
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --�����ǻ�����Ϣ����Ĳ���
      @Name VARCHAR(30) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
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
	
    SELECT  @dbname = 'tbx_Base_Ptype'

    IF EXISTS ( SELECT  [Pusercode]
                FROM    tbx_Base_Ptype
                WHERE   PtypeId <> '00000'
                        AND [PtypeId] <> @typeid
                        AND [Pusercode] = @usercode
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
      
    UPDATE  dbo.tbx_Base_Ptype
    SET     [Parid] = @Parid, [PUsercode] = @UserCode, [PFullname] = @FullName, [PComment] = @Comment, [Name] = @Name, [pnamepy] = @Namepy, [Standard] = @Standard, [Model] = @Model, [Area] = @Area, [UsefulLifeday] = @UsefulLifeday, [Costmode] = @CostMode, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   PTypeId = @typeId

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
