IF OBJECT_ID('dbo.pbx_Base_UpdateB') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateB
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Base_UpdateP                                                 
--  ||   ���̹��ܣ��޸Ļ�����Ϣ--��λ                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateB
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --�����ǻ�����Ϣ����Ĳ���
      @Name VARCHAR(30) ,
      @Address VARCHAR(1000) ,
      @Tel VARCHAR(66) ,
      @EMail VARCHAR(100) ,
      @Contact1 VARCHAR(120) ,--��ϵ��һ
      @Contact2 VARCHAR(120) ,--��ϵ�˶�
      @LinkerTel1 VARCHAR(60) ,--��ϵ�绰һ
      @LinkerTel2 VARCHAR(60) ,--��ϵ�绰��
      @DefEtype VARCHAR(50) ,--Ĭ�Ͼ�����
      @BankOfDeposit VARCHAR(50) ,--��������
      @BankAccounts VARCHAR(50) ,--�����˺�
      @PostCode VARCHAR(50) ,--��������
      @Fax VARCHAR(50) ,--����
      @TaxNumber VARCHAR(50) ,--˰��
      @Rtypeid VARCHAR(50) ,--����
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
	
    SELECT  @dbname = 'tbx_Base_Btype'

    IF EXISTS ( SELECT  [Busercode]
                FROM    tbx_Base_Btype
                WHERE   BtypeId <> '00000'
                        AND [BtypeId] <> @typeid
                        AND [Busercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @errorValue = '�ü�¼�ı�Ż�ȫ����������¼��ͬ,���ܸ��£�'
            GOTO ErrorGeneral
        END

    SET @UpdateTag = 0
    --������Ϣ���±�ʶ  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Btype
    SET     [Parid] = @Parid, [BUsercode] = @UserCode, [BFullname] = @FullName, [BComment] = @Comment, [BNamepy] = @Namepy, 
			[Address] = @Address, [Tel] = @Tel, [EMail] = @EMail, [Contact1] = @Contact1, [Contact2] = @Contact2, 
			[LinkerTel1] = @LinkerTel1, [LinkerTel2] = @LinkerTel2, [DefEtype] = @DefEtype, [BankOfDeposit] = @BankOfDeposit, 
			[BankAccounts] = @BankAccounts, [PostCode] = @PostCode, [Fax] = @Fax, [TaxNumber] = @TaxNumber, 
			[Rtypeid] = Rtypeid, [IsStop] = @IsStop
    WHERE   BTypeId = @typeId 


    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '�����¼����ʧ�ܣ����Ժ����ԣ�'
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
