--# ����˵��: ��ȡEXCEL����
--# ��������: pipi
--# ���ð汾: 2010 2007 2003��ǰ�汾 


-- ��SQL SERVER��'Ad Hoc Distributed Queries'���ء�

exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'Ad Hoc Distributed Queries',1;
reconfigure;
go

-----------------------------------
------------- ��ѯD��1.xlsx��sheet1(2007/2010)
-----------------------------------
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=D:\1.xlsx', 'SELECT * FROM [Sheet1$]')

-----------------------------------
------------- ��ѯD��1.xlsx��sheet1 A1:D100������(2007/2010)
-----------------------------------
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=D:\1.xlsx', 'SELECT * FROM [Sheet1$A1:D101]')


------------- 2003�汾δ��֤
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=C:\book1.xls', 
--'SELECT * FROM [Sheet1$]')
--SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=C:\book1.xls', 
--'SELECT * FROM [Sheet1$A1:D100]')


-----------------------------------
-- �ر�SQL SERVER��'Ad Hoc Distributed Queries'���ء�
----------------------------------- 
exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'Ad Hoc Distributed Queries',0;
reconfigure;