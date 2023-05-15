---------1---------
--доступ к объектам базы данных,управляемой другим сервером
grant create database link to C##U_GUS_PDB;
--Чтобы иметь возможность создать dblink типа global, необходимо выдать привилегии:
grant create public database link to C##U_GUS_PDB;--C#KASCORE


--drop database link oralink;


--создание приватной связи бд
create database link oralink
   connect to PDB_CHAL_ADMIN
   identified by qwerty
   using 'WIN-248JMBUG03J:1521/pdb_chal.be.by';
   
--delete database link oralink;
select * from CHAL_PDB_TABLE@oralink;
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
   connect to BND_user
   identified by qwerty
   using 'nadezhda:1521/orcl.Nadezhda';

drop public database link oralinkPUBLIC;


create synonym A for A@oralinkPUBLIC;
select * from A;

insert into A values (123, 'vgvgh');

insert into A values (123, 'vgvgh');

update A set str = '111' where ID = 123;

delete from A where str = '111';


begin
  GET_TEACHERS('ЛХФ');
end;

--функция
select GET_NUM_TEACHERS('ИДиП') from dual;

