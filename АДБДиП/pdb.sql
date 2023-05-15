SELECT name,open_mode from v$pdbs;
alter pluggable database GUS_PDB open;
drop user C##U1_GUS_PDB;

drop tablespace TS_GUS_4;
drop tablespace TEMP_TS_GUS_4;
DROP role c##RL_PDBGUS;
drop user C##U_GUS_PDB;
drop profile C##PF_PDBGUS;

drop table GUS_table;

------1------
select name,open_mode,RESTRICTED from v$pdbs; 
------2------
select * from v$instance;
------3------
select * from PRODUCT_COMPONENT_VERSION;
------4------
--создать собственный экземпл€р PDB 
--connect system/6378383@//localhost:1521/pdb_gus as sysdba;
--alter pluggable database pdb_gus unplug into 'D:\app\oracle_install_user\pdb_gus.xml';
------5------
select name from v$pdbs;
------6------
create tablespace TS_GUS_4
  datafile 'D:\app\Tablespaces\TS_GUS_4.dbf'
  size 7 m
  autoextend on next 5 m
  maxsize 20 m;
  
create temporary tablespace TEMP_TS_GUS_4
  tempfile 'D:\app\Tablespaces\temp_ts_gus_4.dbf'
  size 5 m
  autoextend on next 3 m
  maxsize 30 m;
  
create role c##RL_PDBGUS;
grant create session to c##RL_PDBGUS; 
grant connect to c##RL_PDBGUS; 
grant create table to c##RL_PDBGUS; 
grant alter any table to c##RL_PDBGUS; 
grant drop any table to c##RL_PDBGUS; 
grant create view to c##RL_PDBGUS; 
grant drop any view to c##RL_PDBGUS; 
grant create tablespace to c##RL_PDBGUS; 
grant drop tablespace to c##RL_PDBGUS;
grant alter tablespace to c##RL_PDBGUS; 
grant create procedure to c##RL_PDBGUS; 
grant drop any procedure to c##RL_PDBGUS;
grant alter any procedure to c##RL_PDBGUS;
grant alter user to c##RL_PDBGUS;

commit;

create profile C##PF_PDBGUS limit
  password_life_time 180       
  sessions_per_user 3         
  failed_login_attempts 7 
  password_lock_time 1  
  password_reuse_time 10    
  password_grace_time default
  connect_time 180             
  idle_time 30;  
  
alter user gus_pdb_admin identified by qwerty  default 
tablespace TS_GUS_4  
quota unlimited on TS_GUS_4 
temporary tablespace TEMP_TS_GUS_4  profile C##PF_PDBGUS; 
GRANT c##RL_PDBGUS TO C##U_GUS_PDB;
grant unlimited tablespace to C##U_GUS_PDB;
grant create table to C##U_GUS_PDB container=all;
alter user C##U_GUS_PDB quota unlimited on USERS;
commit;
------7------

create table GUS_table (X NUMBER(3), Y NUMBER (3));
INSERT INTO GUS_table values ('1','1');
commit;
INSERT INTO GUS_table values ('2','2');
commit;
INSERT INTO GUS_table values ('1','2');  
commit;
select * from GUS_table;

------8------
select * from DBA_TABLESPACES;  --все таб. простр
select * from DBA_DATA_FILES;   --перманентные файлы 
select * from DBA_TEMP_FILES;  --временные файлы
select * from DBA_ROLES; --роли
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;  --привилег
select * from DBA_PROFILES;  
select * from ALL_USERS;  --все пользователи

------9-----
--создайте общего пользовател€ c##gus_cdb

create user c##gus identified by 1234
grant create session to c##gus
connect c##gus/1234

select USER#, USERNAME,OSUSER from v$session where username is not null

