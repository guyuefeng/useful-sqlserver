
-- =============================================
-- Author:		HUANGZT
-- Create date: 2012-11-14
-- Description:	获取每天SAP客户修改列表
-- =============================================
CREATE PROCEDURE [dbo].[P_SBI_GetCustomerChangeList]
	
AS
BEGIN
	DECLARE @FilePath VARCHAR(500),      --客户修改文件列表(TXT),存放路径
			@FileName VARCHAR(50) ,      --文件名称
			@FileNamePrefix VARCHAR(2) ,--文件名称前缀
			@FileDirectory VARCHAR(512), --文件位置
			@StrSql varchar(1024),       --SQL串
			@ROWTERMINATOR  VARCHAR(1),  --字符串结束符
			@FIELDTERMINATOR VARCHAR(1), --文件字段分割符
			@BATCHID VARCHAR(20),        --批次ID
			@CURRENTDATE DATETIME,       --当前时间
			@CompanyCode NVARCHAR(4),    --公司编号
			@YESTERDAY DATETIME          --昨天
			
	BEGIN TRY			
    
		SET @CURRENTDATE = GETDATE()
		SET @YESTERDAY = @CURRENTDATE - 1
		SET @ROWTERMINATOR='X'
		SET @FIELDTERMINATOR =''
		SET @BATCHID = CONVERT(VARCHAR(20),@CURRENTDATE,112)+REPLACE(CONVERT(VARCHAR(20),@CURRENTDATE,108),':','')
		
		/*如果已存在当天的文件数据，则不再读取当天文件*/
		IF EXISTS(SELECT 1 FROM SBI..SBI_CustomerChangeList(NOLOCK) WHERE create_date>CONVERT(VARCHAR(10),@CURRENTDATE,20))
		BEGIN
			RETURN
		END

		/*获取存放TXT文件的路径*/   
		SELECT @FilePath = string_value FROM SBI..SBI_Config(NOLOCK) WHERE function_code =28
		SET @CompanyCode = SBI.dbo.F_SBI_GetCompanyCode()
		
		/*根据厂房编号设置文件名前缀HZ_CUS_CHG_LST_20121120.TXT\NJ_CUS_CHG_LST_20121120.TXT*/
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
		
		/*拼接文件名*/
		SET @FileName = @FileNamePrefix+'_CUS_CHG_LST_'+CONVERT(VARCHAR(8),@YESTERDAY,112)+'.TXT'
		SET @FileDirectory = @FilePath +'\'+ @FileName

		/*创建临时表存放修改客户的信息，每个修改客户一条记录*/
		CREATE TABLE #TempCustomerChangeList(
			char_content VARCHAR(50)
		)
	    
		/*读取TXT文件到临时表*/
		SET @StrSql = 'BULK INSERT #TempCustomerChangeList FROM ' +''''+@FileDirectory+'''' +' WITH (FIELDTERMINATOR ='+ ''''+@FIELDTERMINATOR+''''+', ROWTERMINATOR = '+''''+@ROWTERMINATOR+''''+' )'
		EXEC (@StrSql)

		/*用CHAR(32)空格替换空格CHAR(10)空格，方便LTRIM、RTRIM处理*/
		UPDATE #TempCustomerChangeList SET char_content= REPLACE(char_content,CHAR(10),CHAR(32))
		UPDATE #TempCustomerChangeList SET char_content = LTRIM(RTRIM(char_content))
	    
		/*最后一行空记录*/
		DELETE FROM #TempCustomerChangeList WHERE char_content = ''

		INSERT INTO SBI..SBI_CustomerChangeList(file_name, outlet_no, text_content,batch_id, create_date, create_by,sap_update_date)
		   SELECT @FileName,SUBSTRING(char_content,1,10),char_content,@BATCHID,GETDATE(),'CUST_CHA_LIST'
				  ,CONVERT(VARCHAR(10), SUBSTRING(char_content,11,4))+'-'+CONVERT(VARCHAR(10), SUBSTRING(char_content,15,2))+'-'+CONVERT(VARCHAR(10), SUBSTRING(char_content,17,2))+' '+CONVERT(VARCHAR(10), SUBSTRING(char_content,19,2))+':'+CONVERT(VARCHAR(10), SUBSTRING(char_content,21,2))+':'+CONVERT(VARCHAR(10), SUBSTRING(char_content,23,2))
		   FROM #TempCustomerChangeList WITH(NOLOCK)
	END TRY
	BEGIN CATCH
	    DECLARE @error_message NVARCHAR(255)
        SET @error_message='读取客户修改列表文件失败：'+SUBSTRING(ERROR_MESSAGE(),0,254)
        RAISERROR(@error_message,11,1)
	END CATCH

	DROP TABLE #TempCustomerChangeList  

END

