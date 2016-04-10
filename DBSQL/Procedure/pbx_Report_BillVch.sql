IF OBJECT_ID('dbo.pbx_Report_BillVch') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Report_BillVch
GO

--�����������۵�ͳ�ƺͲ�ѯ����

CREATE PROCEDURE pbx_Report_BillVch
    @VchType INT ,	--��������--1ʱΪ��������,2Ϊ���۶���
    @CMode CHAR(2) ,	--L--�����б�, ͳ�Ʒ�ʽ��P-��Ʒ��B-��λ��E-������,�����'D'Ϊ��Ӧ��ϸ�б�
    @BeginDate VARCHAR(50) ,
    @EndDate VARCHAR(50) ,
    @TypeID VARCHAR(50) ,--��λ����Ʒ��ְԱ��ID��
    @PTypeId VARCHAR(50) ,
    @BTypeId VARCHAR(50) ,
    @ETypeId VARCHAR(50) ,
    @KTypeId VARCHAR(50) ,
    @OperatorID VARCHAR(50)
AS 
    DECLARE @sql VARCHAR(8000)
    
    --L.�����б�
    IF @CMode = 'L' 
        BEGIN
            SET @SQL = 'SELECT  m.*, v.VFullname
						FROM    dbo.tbx_Bill_M m
								LEFT JOIN dbo.tbx_Base_Vtype v ON m.VchType = v.VchType
						WHERE m.VchType = ' + CAST(@VchType AS VARCHAR(20))
        END
    PRINT ( @SQL )
    EXEC(@SQL)
GO