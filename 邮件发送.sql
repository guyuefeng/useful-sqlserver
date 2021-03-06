/*
  SQL2008发送邮件实例一、简单发送邮件
*/
		   
--------  邮件标题
DECLARE @subject_title nvarchar(100);
SET @subject_title ='部门信息表'

--------  邮件内容                
DECLARE @table_html  NVARCHAR(4000) ;
SET @table_html =
N'<H1>' + N'部门信息列表</H1>' +
N'<table border="1">' +
N'<tr><th>部门编号</th><th>部门名称</th><th>预付款</th><th>开始时间</th><th>管理员级别</th></tr>' +
CAST ( ( 
SELECT td=t1.DepartmentID,''
	  ,td=ISNULL(t1.Name,'-'),''
	  ,td=ISNULL(t1.Budget,'-'),''
	  ,td=ISNULL(t1.StartDate,'-'),''
	  ,td=ISNULL(t1.Administrator,'-') ,''
FROM 
[SQLServer2005DB].[dbo].[Department] t1

FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>' ;

--SELECT @table_html

EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'PROFILE',  --定义的邮件@profile_name
	@recipients='dzhong_net@qq.com',  -- 发送给谁,多个人用";"分割
	@importance =High,             --重要级别
	@subject = @subject_title,     --标题
	@body = @table_html,           --内容
	@body_format = 'HTML' ;        --内容格式  
	
	
	
	
/*
  SQL2008发送邮件实例 二、发送附件功能
*/
	
		

  --启动xp_cmdshell
  EXEC sp_configure 'show advanced options', 1;
  RECONFIGURE;

  EXEC sp_configure 'xp_cmdshell','1'
  RECONFIGURE
  --GO
   
  -- 生成指定目录文件名
  declare @output_file1 varchar(100) ='C:\Result.xls'  

  
  -------利用bcp生成文档
  declare @sql1 varchar(500)='"select DepartmentID,Name,Budget,StartDate,Administrator from [SQLServer2005DB].[dbo].[Department]"';

  
  declare @server_name varchar(30)
  set @server_name=convert(varchar(30),@@SERVERNAME)
  
  -------bcp指令
  declare @bcp1 varchar(2000) = 'bcp '+ @sql1 +' queryout ' + @output_file1 + ' -c -S"' + @server_name + '" -T' 

  ------ 执行bcp指令,生成文件至
  exec xp_cmdshell @bcp1

  
  
  --sp_send_dbmail所使用的Profile
  declare @profile varchar(20) = 'CLUSTER'            
  declare @to varchar(1000) =  'chennianlai@swirebev.com;huangzhaoting@swirebev.com;liguofeng@swirebev.com;liaojialong@swirebev.com' --收件者
  
  declare @output_file varchar(max) = @output_file1

  exec msdb.dbo.sp_send_dbmail @profile_name = @profile
                              ,@recipients = @to
                              ,@file_attachments =@output_file
                              ,@subject = '测试邮件标题' 
                              
   --安全考虑 关闭xp_cmdshell
  EXEC sp_configure 'xp_cmdshell','0'
  RECONFIGURE
  EXEC sp_configure 'show advanced options', 0;
  RECONFIGURE;
  
  
-- 生成附件过大，可以设置SQLSERVER附件大小
--File attachment or query results size exceeds allowable value of 1000000 bytes.
