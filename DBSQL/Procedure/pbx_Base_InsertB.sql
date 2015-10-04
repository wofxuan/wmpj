IF OBJECT_ID('dbo.pbx_Base_InsertB') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertB
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Base_InsertB                                                
--  ||   ���̹��ܣ���ӻ�����Ϣ--��λ
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertB
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
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
      @RltTypeID VARCHAR(50) OUTPUT , --���ش�����ID
      @errorValue VARCHAR(500) OUTPUT ,--���ش�����Ϣ
      @uErueMode INT = 0 --���ݲ����ʶ 0 Ϊ�������  1Ϊexcel����
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(25)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(25)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    DECLARE @tmpEtypeid VARCHAR(25)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Btype'

    EXEC @nReturntype = pbx_Base_CreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT, @errorValue OUT

    IF @nReturntype <> 0 
        BEGIN
            GOTO ErrorGeneral
        END
        
    IF ( @uErueMode = 0 )
        OR ( @uErueMode = 1
             AND @UserCode <> ''
           ) --�������� ���� excel���벢����Ʒ��Ų�Ϊ��
        BEGIN
            IF EXISTS ( SELECT  [btypeid]
                        FROM    tbx_Base_Btype
                        WHERE   btypeId <> '00000'
                                AND ( [btypeId] = @typeid_1
                                      OR ( [busercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '�ü�¼�ı�Ż���������¼��ͬ�����ܲ������ݣ�'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Btype
                    WHERE   [btypeId] = @typeid_1
                            AND bsonnum > 0 ) 
            BEGIN
                SET @errorValue = '��Ʒ�Ѿ����ڲ���ͣ��!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Btype
    WHERE   [btypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --�������ŵ����ֵ
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Btype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --������Ϣ���±�ʶ  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Btype ( BTypeId, Parid, Leveal, BUsercode, BFullname, BComment, BNamepy, Parrec, RowIndex, Deleted, Updatetag, [Address], Tel, EMail, Contact1, Contact2, LinkerTel1, LinkerTel2, DefEtype, BankOfDeposit, BankAccounts, PostCode, Fax, TaxNumber, Rtypeid, IsStop )
    VALUES  ( @typeid_1, @ParId, @leveal, @UserCode, @FullName, @Comment, @Namepy, @Parrec, @RowIndex, 0, @UpdateTag, @Address, @Tel, @EMail, @Contact1, @Contact2, @LinkerTel1, @LinkerTel2, @DefEtype, @BankOfDeposit, @BankAccounts, @PostCode, @Fax, @TaxNumber, @Rtypeid, 0 )
          
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '�����¼����ʧ�ܣ����Ժ����ԣ�'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Btype]
    SET     [bsonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [btypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '���¼�¼�ĸ������ݲ���ʧ�ܣ����Ժ����ԣ�'
            GOTO ErrorRollback
        END
	 
        --���ӻ�����Ϣ��Ȩ
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright ( etypeid, RightID, RState )
        --            SELECT  a.etypeid, @typeId_1, 2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO Success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN insertproc 
    RETURN -2 
go
