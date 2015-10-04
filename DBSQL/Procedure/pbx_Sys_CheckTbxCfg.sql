IF OBJECT_ID('dbo.pbx_Sys_CheckTbxCfg') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_CheckTbxCfg
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Sys_CheckTbxCfg                                                 
--  ||   ���̹��ܣ�������ɾ����������
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                     �������
--  ||            -----------------------------------------------------------------------------
--  ||            @CheckType 		VARCHAR		:��������					IN
--  ||            @errorValue 		VARCHAR	    :������Ϣ					IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Sys_CheckTbxCfg
    (
      @CheckType VARCHAR(10) ,
      @errorValue VARCHAR(500) OUTPUT --���ش�����Ϣ 
    )
AS 
    DECLARE @MaxIndex INT
    
    IF @CheckType = 'Insert' 
        BEGIN
            SELECT  @MaxIndex = ISNULL(MAX(TbxRowIndex), 0) FROM dbo.tbx_Sys_TbxCfg 
            
            INSERT dbo.tbx_Sys_TbxCfg ( TbxId, TbxName, TbxType, TbxRowIndex, TbxComment)
			SELECT  so.id, so.name, -1, @MaxIndex + row_number() over (order by tbxId) as rowid, 'ϵͳ�Զ����'
			FROM    SysObjects so LEFT JOIN tbx_Sys_TbxCfg tst ON tst.TbxId = so.id   
			WHERE   XType = 'U' AND (tst.TbxId IS NULL)
        END
        
    IF @CheckType = 'Del' 
        BEGIN
			DELETE  dbo.tbx_Sys_TbxCfg
			WHERE   TbxId NOT IN ( SELECT   id
								   FROM     SysObjects
								   WHERE    XType = 'U')
        END
        
    RETURN 0

go


