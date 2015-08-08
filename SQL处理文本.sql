
-- =============================================
-- Author:		HUANGZT
-- Create date: 2012-11-14
-- Description:	��ȡÿ��SAP�ͻ��޸��б�
-- =============================================
CREATE PROCEDURE [dbo].[P_SBI_GetCustomerChangeList]
	
AS
BEGIN
	DECLARE @FilePath VARCHAR(500),      --�ͻ��޸��ļ��б�(TXT),���·��
			@FileName VARCHAR(50) ,      --�ļ�����
			@FileNamePrefix VARCHAR(2) ,--�ļ�����ǰ׺
			@FileDirectory VARCHAR(512), --�ļ�λ��
			@StrSql varchar(1024),       --SQL��
			@ROWTERMINATOR  VARCHAR(1),  --�ַ���������
			@FIELDTERMINATOR VARCHAR(1), --�ļ��ֶηָ��
			@BATCHID VARCHAR(20),        --����ID
			@CURRENTDATE DATETIME,       --��ǰʱ��
			@CompanyCode NVARCHAR(4),    --��˾���
			@YESTERDAY DATETIME          --����
			
	BEGIN TRY			
    
		SET @CURRENTDATE = GETDATE()
		SET @YESTERDAY = @CURRENTDATE - 1
		SET @ROWTERMINATOR='X'
		SET @FIELDTERMINATOR =''
		SET @BATCHID = CONVERT(VARCHAR(20),@CURRENTDATE,112)+REPLACE(CONVERT(VARCHAR(20),@CURRENTDATE,108),':','')
		
		/*����Ѵ��ڵ�����ļ����ݣ����ٶ�ȡ�����ļ�*/
		IF EXISTS(SELECT 1 FROM SBI..SBI_CustomerChangeList(NOLOCK) WHERE create_date>CONVERT(VARCHAR(10),@CURRENTDATE,20))
		BEGIN
			RETURN
		END

		/*��ȡ���TXT�ļ���·��*/   
		SELECT @FilePath = string_value FROM SBI..SBI_Config(NOLOCK) WHERE function_code =28
		SET @CompanyCode = SBI.dbo.F_SBI_GetCompanyCode()
		
		/*���ݳ�����������ļ���ǰ׺HZ_CUS_CHG_LST_20121120.TXT\NJ_CUS_CHG_LST_20121120.TXT*/
		IF @CompanyCode = '3005'
		BEGIN
		   SET @FileNamePrefix = 'NJ'
		END
		ELSE IF (@CompanyCode = '3006')
		BEGIN
		   SET @FileNamePrefix = 'HZ'
		END
		ELSE IF (@CompanyCode = '3007')
		BEGIN
		   SET @FileNamePrefix = 'XN'
		END
		ELSE IF (@CompanyCode = '3008')
		BEGIN
		   SET @FileNamePrefix = 'ZZ'
		END
		ELSE IF (@CompanyCode = '3009')
		BEGIN
		   SET @FileNamePrefix = 'HF'
		END
		ELSE IF (@CompanyCode = '3010')
		BEGIN
		   SET @FileNamePrefix = 'XM'
		END
		ELSE IF (@CompanyCode = '3013')
		BEGIN
		   SET @FileNamePrefix = 'GD'
		END
		ELSE IF (@CompanyCode = '3018')
		BEGIN
		   SET @FileNamePrefix = 'LQ'
		END
		ELSE IF (@CompanyCode = '3036')
		BEGIN
		   SET @FileNamePrefix = 'HR'
		END
		ELSE
		BEGIN
			RETURN
		END
		
		/*ƴ���ļ���*/
		SET @FileName = @FileNamePrefix+'_CUS_CHG_LST_'+CONVERT(VARCHAR(8),@YESTERDAY,112)+'.TXT'
		SET @FileDirectory = @FilePath +'\'+ @FileName

		/*������ʱ�����޸Ŀͻ�����Ϣ��ÿ���޸Ŀͻ�һ����¼*/
		CREATE TABLE #TempCustomerChangeList(
			char_content VARCHAR(50)
		)
	    
		/*��ȡTXT�ļ�����ʱ��*/
		SET @StrSql = 'BULK INSERT #TempCustomerChangeList FROM ' +''''+@FileDirectory+'''' +' WITH (FIELDTERMINATOR ='+ ''''+@FIELDTERMINATOR+''''+', ROWTERMINATOR = '+''''+@ROWTERMINATOR+''''+' )'
		EXEC (@StrSql)

		/*��CHAR(32)�ո��滻�ո�CHAR(10)�ո񣬷���LTRIM��RTRIM����*/
		UPDATE #TempCustomerChangeList SET char_content= REPLACE(char_content,CHAR(10),CHAR(32))
		UPDATE #TempCustomerChangeList SET char_content = LTRIM(RTRIM(char_content))
	    
		/*���һ�пռ�¼*/
		DELETE FROM #TempCustomerChangeList WHERE char_content = ''

		INSERT INTO SBI..SBI_CustomerChangeList(file_name, outlet_no, text_content,batch_id, create_date, create_by,sap_update_date)
		   SELECT @FileName,SUBSTRING(char_content,1,10),char_content,@BATCHID,GETDATE(),'CUST_CHA_LIST'
				  ,CONVERT(VARCHAR(10), SUBSTRING(char_content,11,4))+'-'+CONVERT(VARCHAR(10), SUBSTRING(char_content,15,2))+'-'+CONVERT(VARCHAR(10), SUBSTRING(char_content,17,2))+' '+CONVERT(VARCHAR(10), SUBSTRING(char_content,19,2))+':'+CONVERT(VARCHAR(10), SUBSTRING(char_content,21,2))+':'+CONVERT(VARCHAR(10), SUBSTRING(char_content,23,2))
		   FROM #TempCustomerChangeList WITH(NOLOCK)
	END TRY
	BEGIN CATCH
	    DECLARE @error_message NVARCHAR(255)
        SET @error_message='��ȡ�ͻ��޸��б��ļ�ʧ�ܣ�'+SUBSTRING(ERROR_MESSAGE(),0,254)
        RAISERROR(@error_message,11,1)
	END CATCH

	DROP TABLE #TempCustomerChangeList  

END

