alter session set "_ORACLE_SCRIPT" = true;

SELECT * FROM DBA_DATA_FILES;
select tablespace_name, contents from DBA_TABLESPACES;


SELECT name, description FROM v$parameter;

--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).
select tablespace_name, contents from DBA_TABLESPACES;

--2-
drop tablespace gus_qdata_3 including contents;
drop role gus_qrole;
drop table gus_t1;
DROP USER gus CASCADE;

create tablespace gus_qdata_3
datafile 'gus_qdata_3.dbf'
size 10 m
offline;

alter tablespace gus_qdata_3 online;--��������� � �������� ������

create role gus_qrol;

grant create session, create table, create view, create procedure to gus_qrol;

create profile gus_qprofil
    limit password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default
    connect_time 180
    idle_time 30;

select * from DBA_TABLESPACES;
create user gus_u identified by qwerty default tablespace gus_qdata_3 quota unlimited on gus_qdata_3 profile gus_qprofil account unlock;
--grant quota unlimited to gus;

select * from DBA_USERS;


alter user gus_u quota 2 m on gus_qdata_3;
grant gus_qrol to gus_u;

create table gus_t1
( id   number(8) primary key,
    name varchar2(16)
) tablespace gus_qdata_3;


insert into gus_t1
values (1,'Ulia');
insert into gus_t1
values (2,'Alina');
insert into gus_t1
values (3,'Marina');

select * from gus_t1;
--drop table gus_t1;


--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. 
--���������� ������� ������� XXX_T1. ���������� ��������� ��������.
select segment_name, segment_type
   from DBA_SEGMENTS where tablespace_name='GUS_QDATA_3';
--4. ������� (DROP) ������� XXX_T1. 
drop table gus_t1;
--�������� ������ ��������� ���������� ������������  XXX_QDATA.
--���������� ������� ������� XXX_T1. 
--��������� SELECT-������ � ������������� USER_RECYCLEBIN.
select * from user_recyclebin;

--5. ������������ (FLASHBACK) ��������� �������. 
flashback table gus_t1 to before drop;

select *
from gus_t1;

--6. ����������� ������� XXX_T1 ������� (10000 �����). 
BEGIN
  FOR k IN 4..10004
  LOOP
    insert into gus_t1 values(k, 'A');
  END LOOP;
  COMMIT;
END;
select * from gus_t1 ;


--7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. 
select SEGMENT_NAME,EXTENT_ID,BYTES,BLOCKS
from user_extents;
--8. ������� ��������� ������������ XXX_QDATA � ��� ����. 
drop tablespace gus_qdata_3 including contents and datafiles;

--9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;

--10. �������� �������� ������ ���� �������� ������� ��������.
SELECT * FROM V$LOGFILE;


--12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������. 
-- ��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). ���������� ������������������ SCN. 
alter database add logfile group 4 'D:\app\REDO04.LOG' size 50 m blocksize 512;

alter database add logfile member 'D:\app\REDO041.LOG' to group 4;

alter database add logfile member 'D:\app\REDO042.LOG' to group 4;

select * from v$log;

alter system switch logfile;


--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. �������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).
ALTER SYSTEM SWITCH LOGFILE;
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;


---13.������� ��������� ������ �������� �������
alter database clear logfile group 4;
--������� ��������� ���� ����� �������� �� �������.
alter database drop logfile group 4;

select *
from v$log;


--14. ����������, ����������� ��� ��� ������������� �������� ������� (������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
select * from v$diag_info;
--15. ���������� ����� ���������� ������.  
select * from v$archived_log; 

--16. EX.  �������� �������������. 
--sql plus
--connect /as sysdba
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;

--
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
--select * from V$LOG;

--17. ������������� �������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������. ���������� ������������������ SCN � ������� � �������� �������. 
alter system set log_archive_dest_1 = 'LOCATION=D:\app\archive';

alter system switch logfile;
SELECT NAME, FIRST_CHANGE#, NEXT_CHANGE# FROM V$ARCHIVED_LOG;


--18. ��������� �������������. ���������, ��� ������������� ���������.  
--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--select name, log_mode from v$database;
--alter database open;

--archive log list;--������ �������� ��������

--19. �������� ������ ����������� ������.
select name from v$controlfile;

--20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.
show parameter control;

--21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. 
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
show parameter spfile ;

--22. ����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.
--CREATE PFILE='GUS_PFILE.ora' FROM SPFILE;
-- � ����� D:\app\oracle_install_user\product\12.1.0\dbhome_1\database


--23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. 
SELECT * FROM V$PWFILE_USERS;
SELECT * FROM V$DIAG_INFO;
show parameter remote_login_passwordfile;



