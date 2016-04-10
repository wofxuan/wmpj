IF OBJECT_ID('dbo.pbx_Bill_Load_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Load_D
go

--���ݲ�ѯ��ϸ

CREATE PROCEDURE pbx_Bill_Load_D
    (
      @DBName VARCHAR(50) ,
      @VchCode NUMERIC(10, 0) ,
      @UsedType VARCHAR(1)--�Ƿ��Զ����ɵļ�¼,�ڵ�����ʱ��������һ����Ӧ����ֿ�ļ�¼, 1��ԭ��¼, 2��ϵͳ���ɵļ�¼
    )
AS 
    SET NOCOUNT ON

    IF @DBName = 'tbx_Bill_Order_D' 
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Bill_Order_D d LEFT JOIN dbo.tbx_Base_Ptype p ON d.PtypeId = p.PTypeId
            WHERE   d.VchCode = @VchCode
            ORDER BY d.DlyOrder 
        END
    ELSE 
        IF @dbname = 'tbx_Bill_Buy_D' 
            BEGIN
                SELECT  *
                FROM    dbo.tbx_Bill_Buy_D d LEFT JOIN dbo.tbx_Base_Ptype p ON d.PtypeId = p.PTypeId
                WHERE   d.VchCode = @VchCode
                ORDER BY d.DlyOrder 
            END
    RETURN 0

GO 
