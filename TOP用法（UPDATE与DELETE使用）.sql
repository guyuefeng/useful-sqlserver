set nocount on 

use tempdb 
go 

if (object_id ('tb' ) is not null )
drop table tb 
go 
create table tb (id int identity (1 , 1 ), name varchar (10 ), tag int default 0 )

insert into tb (name ) select 'a' 
insert into tb (name ) select 'b' 
insert into tb (name ) select 'c' 
insert into tb (name ) select 'd' 
insert into tb (name ) select 'e' 


/*--更新前两行 
id name tag 
----------- ---------- ----------- 
1 a 1 
2 b 1 
3 c 0 
4 d 0 
5 e 0 
*/ 
update top (2 ) tb set tag = 1 
select * from tb 

/*--更新后两行 
id name tag 
----------- ---------- ----------- 
1 a 1 
2 b 1 
3 c 0 
4 d 1 
5 e 1 

*/ 
;with t as 
(
select top (2 ) * from tb order by id desc 
)
update t set tag = 1 
select * from tb 

/*--删除前两行 
id name tag 
----------- ---------- ----------- 
3 c 0 
4 d 1 
5 e 1 
*/ 
delete top (2 ) from tb 
select * from tb 

/*--删除后两行 
id name tag 
----------- ---------- ----------- 
3 c 0 
*/ 
;with t as 
(
select top (2 ) * from tb order by id desc 
)
delete from t 
select * from tb 

set nocount off 
