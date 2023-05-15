drop tablespace TS_GUS_TEMP;
drop tablespace TS_GUS;
drop role C##RL_GUSCORE;
DROP USER C##GUSCORE;
drop profile C##PF_GUSCORE;
------1------
create tablespace TS_GUS
  datafile 'D:\app\Tablespaces\ts_GUS.dbf'
  size 7 m
  autoextend on next 5 m
  maxsize 20 m;
------2------- 
create temporary tablespace TS_GUS_TEMP
  tempfile 'D:\app\Tablespaces\ts_GUS_TEMP.dbf'
  size 5 m
  autoextend on next 3 m
  maxsize 30 m;
------3------
select tablespace_name, contents logging from sys.dba_tablespaces;
------4------
create role C##RL_GUSCORE;
grant create session to c##RL_GUSCORE;
grant create table to c##RL_GUSCORE;
grant create view to c##RL_GUSCORE;
grant create tablespace to c##RL_GUSCORE;
grant create procedure to c##RL_GUSCORE;
grant drop any table to c##RL_GUSCORE;
grant drop tablespace to c##RL_GUSCORE;
grant drop any view to c##RL_GUSCORE;
grant drop any procedure to c##RL_GUSCORE;
grant alter tablespace to c##RL_GUSCORE;
grant alter user to c##rl_guscore;
commit;
------5------
select * from DBA_ROLES where role='C##RL_GUSCORE';
select * from DBA_SYS_PRIVS where grantee='C##RL_GUSCORE';
------6------
create profile C##PF_GUSCORE limit
  password_life_time 180  ---дни жизни пароля       
  sessions_per_user 3   ---сессии для юзера       
  failed_login_attempts 7 --- попытки входа
  password_lock_time 1  --- дни блокирования после ошибок
  password_reuse_time 10  ---через сколько дней можно повторить пароль   
  password_grace_time default ---дни предупреждения о смене пароля
  connect_time 180 ---время соединения            
  idle_time 30; --- минут простоя 
------7------
select * from DBA_PROFILES;
select * from DBA_PROFILES where profile='С##PF_GUSCORE';  
select * from DBA_PROFILES where profile='DEFAULT';
------8------1234
create user C##GUSCORE identified by 12345
  default tablespace TS_GUS 
        quota unlimited on TS_GUS   
  temporary tablespace TS_GUS_TEMP  
  profile C##PF_GUSCORE 
  account unlock 
  password expire; 
GRANT C##RL_GUSCORE TO C##GUSCORE;
------10------
CREATE TABLE GUS_T1(X NUMBER(3));
CREATE VIEW GUS_V AS SELECT X FROM GUS_T1;
------11------
CREATE TABLESPACE GUS_QDATA
   datafile 'D:\app\Tablespaces\GUS_QDATA.dbf'
  size 10 m
  autoextend on next 10 m
  maxsize 30 m;
alter tablespace GUS_QDATA online;
alter user c##guscore quota 2m on GUS_QDATA;
CREATE TABLE GUS_T(q NUMBER(3)) tablespace GUS_QDATA;
insert into gus_t values ('1');
insert into gus_t values ('2');
insert into gus_t values ('3');
--------------
DROP TABLE GUS_T1;
DROP VIEW GUS_V;
DROP TABLE GUS_T;
drop TABLESPACE GUS_QDATA;