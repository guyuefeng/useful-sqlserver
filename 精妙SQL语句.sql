--	˵�������Ʊ�(ֻ���ƽṹ,Դ������a �±�����b) 
select * into t_moudle_b from t_module where 1<>1
--select * from t_moudle_b

--o	˵����������(��������,Դ������a Ŀ�������b)
insert into t_moudle_b (module_id, module_name, parent_id) 
select module_id, module_name, parent_id from t_module;


--o	˵������ʾ���¡��ύ�˺����ظ�ʱ��
select a.title,a.username,b.adddate from table a,
(select max(adddate) adddate from table where table.title=a.title) b
--o	˵���������Ӳ�ѯ(����1��a ����2��b)
select a.a, a.b, a.c, b.c, b.d, b.f from a 
LEFT OUT JOIN b 
ON a.a = b.c

--o	˵�����ճ̰�����ǰ���������
select * from �ճ̰��� 
where datediff('minute',f��ʼʱ��,getdate())>5

--o	˵�������Ź�����ɾ���������Ѿ��ڸ�����û�е���Ϣ
delete from info where not exists 
( select * from infobz where info.infid=infobz.infid )

--o	˵����-- 
--SQL: 
SELECT A.NUM, A.NAME, B.UPD_DATE, B.PREV_UPD_DATE 
FROM TABLE1, 
(SELECT X.NUM, X.UPD_DATE, Y.UPD_DATE PREV_UPD_DATE 
FROM (SELECT NUM, UPD_DATE, INBOUND_QTY, STOCK_ONHAND 
FROM TABLE2 
WHERE TO_CHAR(UPD_DATE,'YYYY/MM') = TO_CHAR(SYSDATE, 'YYYY/MM')) X, 
(SELECT NUM, UPD_DATE, STOCK_ONHAND 
FROM TABLE2 
WHERE TO_CHAR(UPD_DATE,'YYYY/MM') = 
TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM') || '/01','YYYY/MM/DD') - 1, 'YYYY/MM') ) Y, 
WHERE X.NUM = Y.NUM ��+�� 
AND X.INBOUND_QTY + NVL(Y.STOCK_ONHAND,0) <> X.STOCK_ONHAND ) B 
WHERE A.NUM = B.NUM
--o	˵����-- 
select * from studentinfo 
where not exists(select * from student where studentinfo.id=student.id) 
and ϵ����='"&strdepartmentname&"' 
and רҵ����='"&strprofessionname&"' 
order by �Ա�,��Դ��,�߿��ܳɼ�


o	�����ݿ���ȥһ��ĸ���λ�绰��ͳ��(�绰�Ѷ���ص绯���嵥��������Դ�� 
SELECT a.userper
, a.tel
, a.standfee
, TO_CHAR(a.telfeedate, 'yyyy') AS telyear, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '01', a.factration)) AS JAN, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '02', a.factration)) AS FRI, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '03', a.factration)) AS MAR, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '04', a.factration)) AS APR, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '05', a.factration)) AS MAY, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '06', a.factration)) AS JUE, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '07', a.factration)) AS JUL, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '08', a.factration)) AS AGU, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '09', a.factration)) AS SEP, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '10', a.factration)) AS OCT, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '11', a.factration)) AS NOV, 
SUM(decode(TO_CHAR(a.telfeedate, 'mm'), '12', a.factration)) AS DEC 
FROM (SELECT a.userper, a.tel, a.standfee, b.telfeedate, b.factration 
FROM TELFEESTAND a, TELFEE b 
WHERE a.tel = b.telfax) a 
GROUP BY a.userper, a.tel, a.standfee, TO_CHAR(a.telfeedate, 'yyyy')

--o	˵�����ı���������
select * from a left inner join b on a.a=b.b 
right inner join c on a.a=c.c 
inner join d on a.a=d.d where ..... 

o	˵�����õ�������С��δʹ�õ�ID��
o	SELECT (CASE WHEN EXISTS(SELECT * FROM Handle b WHERE b.HandleID = 1) THEN MIN(HandleID) + 1 
            ELSE 1 END) as HandleID  
            FROM Handle WHERE NOT HandleID IN (SELECT a.HandleID - 1 FROM Handle a)
o	һ��SQL��������:����ת��
select * from v_temp
�������ͼ�������:
user_name role_name
-------------------------
ϵͳ����Ա ����Ա 
feng ����Ա 
feng һ���û� 
test һ���û� 
��ѽ���������:
user_name role_name
---------------------------
ϵͳ����Ա ����Ա 
feng ����Ա,һ���û� 
test һ���û�
===================
create table a_test(name varchar(20),role2 varchar(20))
insert into a_test values('��','����Ա')
insert into a_test values('��','����Ա')
insert into a_test values('��','һ���û�')
insert into a_test values('��','һ���û�')
create function join_str(@content varchar(100))
returns varchar(2000)
as
begin
declare @str varchar(2000)
set @str=''
select @str=@str+','+rtrim(role2) from a_test where [name]=@content
select @str=right(@str,len(@str)-1)
return @str
end
go
--���ã�
select [name],dbo.join_str([name]) role2 from a_test group by [name]
--select distinct name,dbo.uf_test(name) from a_test
o	���ٱȽϽṹ��ͬ������
�ṹ��ͬ������һ���м�¼3�������ң�һ���м�¼2�������ң����������ٲ�������Ĳ�ͬ��¼��
============================
����һ�����Է�������northwind�е�orders��ȡ���ݡ�
select * into n1 from orders
select * into n2 from orders
select * from n1
select * from n2
--���������Ȼ���޸�n1�������ֶε�������
alter table n1 add constraint pk_n1_id primary key (OrderID)
alter table n2 add constraint pk_n2_id primary key (OrderID)
select OrderID from (select * from n1 union select * from n2) a group by OrderID having count(*) > 1
Ӧ�ÿ��ԣ����ҽ���ͬ�ļ�¼��ID��ʾ������
�����������˫����¼һ���������
select * from n1 where orderid in (select OrderID from (select * from n1 union select * from n2) a group by OrderID having count(*) > 1) 
����˫���������ڵļ�¼�ǱȽϺô����
--ɾ��n1,n2����������¼
delete from n1 where orderID in ('10728','10730')
delete from n2 where orderID in ('11000','11001')
--*************************************************************
-- ˫�����иü�¼ȴ����ȫ��ͬ
select * from n1 where orderid in(select OrderID from (select * from n1 union select * from n2) a group by OrderID having count(*) > 1)
union
--n2�д��ڵ���n1�в������10728,10730
select * from n1 where OrderID not in (select OrderID from n2)
union
--n1�д��ڵ���n2�в������11000,11001
select * from n2 where OrderID not in (select OrderID from n1)
o	���ַ���ȡ����n��m����¼��
1.
select top m * into ��ʱ��(������) from tablename order by columnname -- ��top m�ʲ���
set rowcount n
select * from ����� order by columnname desc
2.
select top n * from (select top m * from tablename order by columnname) a order by columnname desc
3.���tablename��û������identity�У���ô��
select identity(int) id0,* into #temp from tablename
ȡn��m�������Ϊ��
select * from #temp where id0 >=n and id0 <= m
�������ִ��select identity(int) id0,* into #temp from tablename��������ʱ�򱨴�,������Ϊ���DB�м��select into/bulkcopy����û�д�Ҫ��ִ�У�
exec sp_dboption ���DB����,'select into/bulkcopy',true
4.���������identity���ԣ���ô�򵥣�
select * from tablename where identitycol between n and m 
o	���ɾ��һ�������ظ��ļ�¼��
create table a_dist(id int,name varchar(20))
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
exec up_distinct 'a_dist','id'
select * from a_dist
create procedure up_distinct(@t_name varchar(30),@f_key varchar(30))
--f_key��ʾ�Ƿ����ֶΩo�������ֶ�
as
begin
declare @max integer,@id varchar(30) ,@sql varchar(7999) ,@type integer
select @sql = 'declare cur_rows cursor for select '+@f_key+' ,count(*) from ' +@t_name +' group by ' +@f_key +' having count(*) > 1'
exec(@sql)
open cur_rows 
fetch cur_rows into @id,@max 
while @@fetch_status=0 
begin 
select @max = @max -1 
set rowcount @max 
select @type = xtype from syscolumns where id=object_id(@t_name) and name=@f_key
if @type=56
select @sql = 'delete from '+@t_name+' where ' + @f_key+' = '+ @id 
if @type=167
select @sql = 'delete from '+@t_name+' where ' + @f_key+' = '+''''+ @id +'''' 
exec(@sql)
fetch cur_rows into @id,@max 
end 
close cur_rows 
deallocate cur_rows
set rowcount 0
end
select * from systypes
select * from syscolumns where id = object_id('a_dist')
o	��ѯ���ݵ�����������⣨ֻ����һ�����д�� 
CREATE TABLE hard (qu char (11) ,co char (11) ,je numeric(3, 0)) 
insert into hard values ('A','1',3)
insert into hard values ('A','2',4)
insert into hard values ('A','4',2)
insert into hard values ('A','6',9)
insert into hard values ('B','1',4)
insert into hard values ('B','2',5)
insert into hard values ('B','3',6)
insert into hard values ('C','3',4)
insert into hard values ('C','6',7)
insert into hard values ('C','2',3)
Ҫ���ѯ�����Ľ�����£�
qu co je 
----------- ----------- ----- 
A 6 9
A 2 4
B 3 6
B 2 5
C 6 7
C 3 4
����Ҫ��qu���飬ÿ����ȡje����ǰ2λ����
����ֻ����һ��sql��䣡����
select * from hard a where je in (select top 2 je from hard b where a.qu=b.qu order by je) 
o	��ɾ���ظ���¼��sql��䣿 
�����Ѿ�����ͬ�ֶεļ�¼ɾ����ֻ����һ����
���磬��test����id,name�ֶ�
�����name��ͬ�ļ�¼ ֻ����һ���������ɾ����
name�����ݲ�������ͬ�ļ�¼��������
��û��������sql��䣿
==============================
A:һ�������Ľ��������
���ظ��ļ�¼����temp1��:
select [��־�ֶ�id],count(*) into temp1 from [����]
group by [��־�ֶ�id]
having count(*)>1
2�������ظ��ļ�¼����temp1��:
insert temp1 select [��־�ֶ�id],count(*) from [����] group by [��־�ֶ�id] having count(*)=1
3����һ���������в��ظ���¼�ı�
select * into temp2 from [����] where ��־�ֶ�id in(select ��־�ֶ�id from temp1)
4��ɾ���ظ���:
delete [����]
5���ָ���
insert [����] select * from temp2
6��ɾ����ʱ��:
drop table temp1
drop table temp2
================================
B:
create table a_dist(id int,name varchar(20))
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
insert into a_dist values(1,'abc')
exec up_distinct 'a_dist','id'
select * from a_dist
create procedure up_distinct(@t_name varchar(30),@f_key varchar(30))
--f_key��ʾ�Ƿ����ֶΩo�������ֶ�
as
begin
declare @max integer,@id varchar(30) ,@sql varchar(7999) ,@type integer
select @sql = 'declare cur_rows cursor for select '+@f_key+' ,count(*) from ' +@t_name +' group by ' +@f_key +' having count(*) > 1'
exec(@sql)
open cur_rows 
fetch cur_rows into @id,@max 
while @@fetch_status=0 
begin 
select @max = @max -1 
set rowcount @max 
select @type = xtype from syscolumns where id=object_id(@t_name) and name=@f_key
if @type=56
select @sql = 'delete from '+@t_name+' where ' + @f_key+' = '+ @id 
if @type=167
select @sql = 'delete from '+@t_name+' where ' + @f_key+' = '+''''+ @id +'''' 
exec(@sql)
fetch cur_rows into @id,@max 
end 
close cur_rows 
deallocate cur_rows
set rowcount 0
end
select * from systypes
select * from syscolumns where id = object_id('a_dist')
o	����ת��--��ͨ 
��������ѧ���ɼ���(CJ)���� 
Name Subject Result 
���� ���� 80 
���� ��ѧ 90 
���� ���� 85 
���� ���� 85 
���� ��ѧ 92 
���� ���� 82 
���� 
���� ���� ��ѧ ���� 
���� 80 90 85 
���� 85 92 82 
declare @sql varchar(4000) 
set @sql = 'select Name' 
select @sql = @sql + ',sum(case Subject when '''+Subject+''' then Result end) ['+Subject+']' 
from (select distinct Subject from CJ) as a 
select @sql = @sql+' from test group by name' 
exec(@sql) 
����ת��--�ϲ� 
�б�A, 
id pid 
1 1 
1 2 
1 3 
2 1 
2 2 
3 1 
��λ��ɱ�B: 
id pid 
1 1,2,3 
2 1,2 
3 1 
����һ���ϲ��ĺ��� 
create function fmerg(@id int) 
returns varchar(8000) 
as 
begin 
declare @str varchar(8000) 
set @str='' 
select @str=@str+','+cast(pid as varchar) from ��A where id=@id 
set @str=right(@str,len(@str)-1) 
return(@str) 
End 
go 
--�����Զ��庯���õ���� 
select distinct id,dbo.fmerg(id) from ��A 
o	���ȡ��һ�����ݱ���������� 
�������£��ȴ�SYSTEMOBJECTϵͳ����ȡ�����ݱ��SYSTEMID,Ȼ����SYSCOLUMN����ȡ�ø����ݱ������������ 
SQL������£� 
declare @objid int,@objname char(40) 
set @objname = 'tablename' 
select @objid = id from sysobjects where id = object_id(@objname) 
select 'Column_name' = name from syscolumns where id = @objid order by colid 
��
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME ='users'
o	ͨ��SQL����������û������� 
�޸ı��˵�,��Ҫsysadmin role 
EXEC sp_password NULL, 'newpassword', 'User' 
����ʺ�ΪSAִ��EXEC sp_password NULL, 'newpassword', sa
o	��ô�жϳ�һ�������Щ�ֶβ�����Ϊ�գ� 
select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where IS_NULLABLE='NO' and TABLE_NAME=tablename 
o	��������ݿ����ҵ�������ͬ�ֶεı� 
a. ����֪��������� 
SELECT b.name as TableName,a.name as columnname 
From syscolumns a INNER JOIN sysobjects b 
ON a.id=b.id 
AND b.type='U' 
AND a.name='����ֶ�����' 
o	δ֪�����������ڲ�ͬ����ֹ������� 
Select o.name As tablename,s1.name As columnname 
From syscolumns s1, sysobjects o 
Where s1.id = o.id 
And o.type = 'U' 
And Exists ( 
Select 1 From syscolumns s2 
Where s1.name = s2.name 
And s1.id <> s2.id 
) 
o	��ѯ��xxx������ 
����id�������� 
select * from (select top xxx * from yourtable) aa where not exists(select 1 from (select top xxx-1 * from yourtable) bb where aa.id=bb.id) 
���ʹ���α�Ҳ�ǿ��Ե� 
fetch absolute [number] from [cursor_name] 
����Ϊ�������� 
o	SQL Server���ڼ��� 
a. һ���µĵ�һ�� 
SELECT DATEADD(mm, DATEDIFF(mm,0,getdate()), 0) 
b. ���ܵ�����һ 
SELECT DATEADD(wk, DATEDIFF(wk,0,getdate()), 0) 
c. һ��ĵ�һ�� 
SELECT DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) 
d. ���ȵĵ�һ�� 
SELECT DATEADD(qq, DATEDIFF(qq,0,getdate()), 0) 
e. �ϸ��µ����һ�� 
SELECT dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)) 
f. ȥ������һ�� 
SELECT dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)) 
g. ���µ����һ�� 
SELECT dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,getdate())+1, 0)) 
h. ���µĵ�һ������һ 
select DATEADD(wk, DATEDIFF(wk,0, 
dateadd(dd,6-datepart(day,getdate()),getdate()) 
), 0) 
i. ��������һ�� 
SELECT dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate())+1, 0))�� 
o	��ȡ��ṹ[�� 'sysobjects' �滻 �� 'tablename' ����] 
SELECT CASE IsNull(I.name, '') 
When '' Then '' 
Else '*' 
End as IsPK, 
Object_Name(A.id) as t_name, 
A.name as c_name, 
IsNull(SubString(M.text, 1, 254), '') as pbc_init, 
T.name as F_DataType, 
CASE IsNull(TYPEPROPERTY(T.name, 'Scale'), '') 
WHEN '' Then Cast(A.prec as varchar) 
ELSE Cast(A.prec as varchar) + ',' + Cast(A.scale as varchar) 
END as F_Scale, 
A.isnullable as F_isNullAble 
FROM Syscolumns as A 
JOIN Systypes as T 
ON (A.xType = T.xUserType AND A.Id = Object_id('sysobjects') ) 
LEFT JOIN ( SysIndexes as I 
JOIN Syscolumns as A1 
ON ( I.id = A1.id and A1.id = object_id('sysobjects') and (I.status & 0x800) = 0x800 AND A1.colid <= I.keycnt) ) 
ON ( A.id = I.id AND A.name = index_col('sysobjects', I.indid, A1.colid) ) 
LEFT JOIN SysComments as M 
ON ( M.id = A.cdefault and ObjectProperty(A.cdefault, 'IsConstraint') = 1 ) 
ORDER BY A.Colid ASC
o	��ȡ���ݿ������б���ֶ���ϸ˵����SQL��� 
SELECT 
(case when a.colorder=1 then d.name else '' end) N'����', 
a.colorder N'�ֶ����', 
a.name N'�ֶ���', 
(case when COLUMNPROPERTY( a.id,a.name,'IsIdentity')=1 then '��'else '' 
end) N'��ʶ', 
(case when (SELECT count(*) 
FROM sysobjects 
WHERE (name in 
(SELECT name 
FROM sysindexes 
WHERE (id = a.id) AND (indid in 
(SELECT indid 
FROM sysindexkeys 
WHERE (id = a.id) AND (colid in 
(SELECT colid 
FROM syscolumns 
WHERE (id = a.id) AND (name = a.name))))))) AND 
(xtype = 'PK'))>0 then '��' else '' end) N'����', 
b.name N'����', 
a.length N'ռ���ֽ���', 
COLUMNPROPERTY(a.id,a.name,'PRECISION') as N'����', 
isnull(COLUMNPROPERTY(a.id,a.name,'Scale'),0) as N'С��λ��', 
(case when a.isnullable=1 then '��'else '' end) N'�����', 
isnull(e.text,'') N'Ĭ��ֵ', 
isnull(g.[value],'') AS N'�ֶ�˵��' 
FROM syscolumns a 
left join systypes b 
on a.xtype=b.xusertype 
inner join sysobjects d 
on a.id=d.id and d.xtype='U' and d.name<>'dtproperties' 
left join syscomments e 
on a.cdefault=e.id 
left join sysproperties g 
on a.id=g.id AND a.colid = g.smallid 
order by object_name(a.id),a.colorder
o	���ٻ�ȡ��test�ļ�¼����[�Դ�������ǳ���Ч] 
���ٻ�ȡ��test�ļ�¼����: 
select rows from sysindexes where id = object_id('test') and indid in (0,1)
update 2 set KHXH=(ID+1)\2 2�е������
update [23] set id1 = 'No.'+right('00000000'+id,6) where id not like 'No%' //����
update [23] set id1= 'No.'+right('00000000'+replace(id1,'No.',''),6) //��λ����
delete from [1] where (id%2)=1 
����
o	�滻�����ֶ�
update [1] set domurl = replace(domurl,'Upload/Imgswf/','Upload/Photo/') where domurl like '%Upload/Imgswf/%'
o	��λ
SELECT LEFT(����, 5)   
