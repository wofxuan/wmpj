IF OBJECT_ID('dbo.pbx_Base_GetGroup') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetGroup
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�p_hh_GetBaseGroup                                                 
--  ||   ���̹��ܣ��õ�������Ϣ�������
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                     �������
--  ||            -----------------------------------------------------------------------------
--  ||            @cMode 	char(5)		:������Ϣ���Ͳ���			IN
--  ||            @szTypeid 	varchar(50)	:���ڵ�Typeid			IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Base_GetGroup
    (
      @cMode VARCHAR(5) ,
      @szTypeid VARCHAR(50) ,
      @OperatorID VARCHAR(25)
    )
AS 
    DECLARE @sql VARCHAR(8000)
    DECLARE @TableStr VARCHAR(200) , @TableWhereStr VARCHAR(200)
    DECLARE @DTableStr VARCHAR(200) , @DTableWhereStr VARCHAR(200)

    IF @cMode = 'I'  --���ذ�
        BEGIN
            SELECT  *
            FROM    tbx_Base_PackageInfo
            WHERE   Parid = @szTypeid
            ORDER BY RowIndex , ITypeId
        END 
	
    IF @cMode = 'P'  --��Ʒ��Ϣ
        BEGIN
		    --exec p_hh_GetRightStr 'P','p',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ptype p
			         WHERE  p.PARID = ''' + @szTypeid + ''' and p.deleted = 0 ORDER BY RowIndex, p.ptypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'B'  --��λ��Ϣ
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Btype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.btypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'E'  --ְԱ��Ϣ
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Etype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Etypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'D'  --������Ϣ
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Dtype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Dtypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'K'  --�ֿ���Ϣ
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ktype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Ktypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
go


