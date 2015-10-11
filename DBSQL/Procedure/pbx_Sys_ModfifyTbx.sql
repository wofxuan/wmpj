IF OBJECT_ID('dbo.pbx_Sys_ModfifyTbx') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ModfifyTbx
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Sys_ModfifyTbx                                                 
--  ||   ���̹��ܣ��޸ı��������Ϣ                                           
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ModfifyTbx
    (
      @TbxId VARCHAR(50) ,
      @TbxDefName VARCHAR(50) ,
      @TbxType VARCHAR(66) ,
      @TbxComment VARCHAR(50) ,
      --�������Ǳ���Ĳ���
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    SET nocount ON

      
    UPDATE  dbo.tbx_Sys_TbxCfg
    SET TbxDefName = @TbxDefName, TbxType = @TbxType, TbxComment = @TbxComment
    WHERE TbxId = @TbxId
      
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
