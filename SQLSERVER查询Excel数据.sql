--# 功能说明: 读取EXCEL数据
--# 署名作者: pipi
--# 适用版本: 2010 2007 2003以前版本 


-- 打开SQL SERVER的'Ad Hoc Distributed Queries'开关。

exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'Ad Hoc Distributed Queries',1;
reconfigure;
go

-----------------------------------
------------- 查询D盘1.xlsx中sheet1(2007/2010)
-----------------------------------
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=D:\1.xlsx', 'SELECT * FROM [Sheet1$]')

-----------------------------------
------------- 查询D盘1.xlsx中sheet1 A1:D100中内容(2007/2010)
-----------------------------------
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=D:\1.xlsx', 'SELECT * FROM [Sheet1$A1:D101]')


------------- 2003版本未验证
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=C:\book1.xls', 
--'SELECT * FROM [Sheet1$]')
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=C:\book1.xls', 
--'SELECT * FROM [Sheet1$A1:D100]')


-----------------------------------
-- 关闭SQL SERVER的'Ad Hoc Distributed Queries'开关。
----------------------------------- 
exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'Ad Hoc Distributed Queries',0;
reconfigure;