---------1---------
--доступ к объектам базы данных,управляемой другим сервером
grant create database link to C##U_GUS_PDB;
--Чтобы иметь возможность создать dblink типа global, необходимо выдать привилегии:
grant create public database link, drop public database link to C##U_GUS_PDB;--C#KASCORE


--drop database link oralink;
select * from t_pk;

--создание приватной связи бд   
create database link oralink
   connect to C##U_PDB
   identified by qwerty
   using 'PDB_A';
   
drop database link oralink;  

select * from td@oralink;

drop database link oralink;
--delete database link oralink;
select * from testpdb@oralink;
create synonym F for CHAL_PDB_TABLE@oralink;
--drop synonym syn;
alter user C##U_GUS_PDB identified by qwerty;
select * from for_ulya@oralink;
select * from for_ulya@"ORALINK"
insert into F@oralink values ('A', 55);

update A@oralink set comanwlumn_ = '111' where ID = 123;
--delete from A@oralink where id = 123;

alter pluggable database KAS_PDB open;
select * from dba_pdbs;
--процедура
begin
  GET_TEACHERS@oralink('ЛХФ');
end;

--функция
select GET_NUM_TEACHERS@oralink('ИДиП') from dual;


create table KAStabl
 (
  spec number(15) primary key,
  name varchar(10)
 );

--3-общедоступная связь
--Чтобы создать dblink типа global
create public database link oralinkPUBLIC
   connect to C##U_PDB
   identified by qwerty
   using 'DESKTOP-0KJ1QLP:1521/PDB_A';


drop public database link oralinkPUBLIC;


create synonym A for A@oralinkPUBLIC;
select * from testpdb@oralinkPUBLIC;

insert into A values (123, 'vgvgh');

insert into A values (123, 'vgvgh');

update A set str = '111' where ID = 123;

delete from A where str = '111';


begin
  GET_TEACHERS('ЛХФ');
end;

--функция
select GET_NUM_TEACHERS('ИДиП') from dual;
------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------------------------------------------------------
--------------------------------------------------------------------------
--SET AUTOCOMMIT ON

create database link oralink
connect to testuser
identified by qweqwe
using 'DESKTOP-MG0TEPB:1521/SVA_PDB';

-------------------------------------------------—
--[testuser]
create table testpdb (a int, b varchar(30));

drop table testpdb
CREATE TABLE testpdb(a int,b varchar(30));

CREATE OR REPLACE PROCEDURE HelloProcedure IS
BEGIN
INSERT INTO testpdb values (500,500);
END;
--exec HelloProcedure

CREATE OR REPLACE FUNCTION HelloFunction RETURN NUMBER IS
numb NUMBER;
BEGIN
SELECT COUNT(*) INTO numb FROM testpdb;
RETURN numb;
END;

DECLARE
numb NUMBER;
BEGIN
numb := HelloFunction;
DBMS_OUTPUT.PUT_LINE('Количество строк в таблице: ' || numb);
END;
-------------------------------------------------—

select * from testpdb;
--1
--drop database link another_pdb;
create database link another_pdb
connect to testuser
identified by qweqwe
using 'DESKTOP-MG0TEPB:1521/SVA_PDB';

------2----—
select * from testpdb@another_pdb;
insert into testpdb@another_pdb values (100,500);
update testpdb@another_pdb set a = 1000 where b = 500;
delete testpdb@another_pdb where a = 1000;
COMMIT
exec HelloProcedure@another_pdb;
select * from testpdb@another_pdb;



declare
numb number(10);
begin
numb := HelloFunction@another_pdb;
DBMS_OUTPUT.PUT_LINE('Количество строк в таблице: ' || numb);
end;
commit



------3----—
--drop public database link PUBLIC_ANOTHER_PDB;
create public database link public_another_pdb
connect to testuser
identified by qweqwe
using 'ORCLK';

------4----—
select * from testpdb@another_pdb;
insert into testpdb@another_pdb values (100,500);
update testpdb@another_pdb set a = 1000 where b = 100;
delete testpdb@another_pdb where a = 1000;

exec HelloProcedure@another_pdb;



declare
numb number(10);
begin
numb := HelloFunction@another_pdb;
DBMS_OUTPUT.PUT_LINE('Количество строк в таблице: ' || numb);
end;