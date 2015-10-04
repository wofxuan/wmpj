IF OBJECT_ID('dbo.pbx_Base_InsertE') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertE
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Base_InsertE                                                
--  ||   ���̹��ܣ���ӻ�����Ϣ--ְԱ
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertE
    (
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Comment VARCHAR(250) ,
      @Namepy VARCHAR(60) ,
      --�����ǻ�����Ϣ����Ĳ���
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
      @RltTypeID VARCHAR(50) OUTPUT , --���ش�����ID
      @errorValue VARCHAR(500) OUTPUT ,--���ش�����Ϣ
      @uErueMode INT = 0 --���ݲ����ʶ 0 Ϊ�������  1Ϊexcel����
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(50)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(50)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    DECLARE @tmpEtypeid VARCHAR(50)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Base_Etype'

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
            IF EXISTS ( SELECT  [Etypeid]
                        FROM    tbx_Base_Etype
                        WHERE   EtypeId <> '00000'
                                AND ( [EtypeId] = @typeid_1
                                      OR ( [Eusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '�ü�¼�ı�Ż���������¼��ͬ�����ܲ������ݣ�'
                    GOTO ErrorGeneral
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Base_Etype
                    WHERE   [EtypeId] = @typeid_1
                            AND Esonnum > 0 ) 
            BEGIN
                SET @errorValue = 'ְԱ�Ѿ����ڲ���ͣ��!'
                GOTO ErrorGeneral
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Base_Etype
    WHERE   [Etypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --�������ŵ����ֵ
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Base_Etype
    WHERE   [Parid] = @Parid
            AND deleted = 0
            
    --������Ϣ���±�ʶ  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT  @UpdateTag = 0

    INSERT  dbo.tbx_Base_Etype ( ETypeId, Parid, ESonnum, Soncount, Leveal, EUsercode, EFullname, EComment, Enamepy, DTypeId, Tel, [Address], Birthday, EMail, Job, TopTotal, LowLimitDiscount, IsStop, Parrec, RowIndex, Deleted, Updatetag )
    VALUES  ( @typeid_1, @ParId, 0, 0, @leveal, @UserCode, @FullName, @Comment, @Namepy, @DTypeId, @Tel, @Address, @Birthday, @EMail, @Job, @TopTotal, @LowLimitDiscount, @Isstop, @Parrec, @RowIndex, 0, @UpdateTag )
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '�����¼����ʧ�ܣ����Ժ����ԣ�'
            GOTO ErrorRollback
        END

    UPDATE  [tbx_Base_Etype]
    SET     [Esonnum] = @nSonnum + 1, [soncount] = @nSoncount + 1, [updatetag] = @UpdateTag
    WHERE   [Etypeid] = @Parid

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
    GOTO success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN insertproc 
    RETURN -2 
go
