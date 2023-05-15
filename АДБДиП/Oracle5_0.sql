--1
--select * from dba_tablespaces where TABLESPACE_NAME like '%YAN%';
SELECT * FROM DBA_DATA_FILES;
select * from dba_temp_files;
--2
create tablespace yan_qdata1
    datafile 'yan_qdata1.dat'
    size 10m
    reuse
    autoextend on next 5 m maxsize 20m
    offline;
alter tablespace yan_qdata1 online;

alter user YAN quota 2m on yan_qdata1;
create table yan_t1 (
                                    pkey number primary key,
                                    str varchar(20))
                                    tablespace yan_qdata1;
insert into yan_t1 values (1,'aaa');
insert into yan_t1 values (2,'bbb');
INSERT INTO YAN_T1 VALUES (3,'ccc');
SELECT * FROM YAN_T1;
DROP TABLE YAN_T1;

--3
select * from dba_segments where tablespace_name = 'YAN_QDATA1' 
AND SEGMENT_NAME='YAN_T1';

--4
drop table yan_t1;
select * from dba_segments where tablespace_name = 'YAN_QDATA1';
select * from user_recyclebin;    select * from recyclebin;
--5
flashback table yan_t1 to before drop;
--6
CREATE SEQUENCE PKEY_SEQ MINVALUE 1 MAXVALUE 100000 START WITH 4 INCREMENT BY 1 CACHE 20;
begin 
for i in 1 .. 10000 loop
insert into yan_t1 (pkey,str) values (pkey_seq.nextval,'aa');
end loop;
end;
drop sequence pkey_seq;
select * from yan_t1;
--7
select count(*),sum(bytes),sum(blocks) from user_extents where segment_name like '%YAN_T1%';
select * from user_extents where segment_name like '%YAN_T1%';
select * from user_extents;
--8
drop tablespace yan_qdata1 including contents;    
--9-10    
select * from v$log;--?????? ???????
select * from v$logfile;--???????? ?????? ???????
--11
13:56 PM 29/11/2022
alter system switch logfile;
select * from v$log;
alter system switch logfile;
select * from v$log;
alter system switch logfile;
select * from v$log;
--12
alter database add logfile group 4 'C:\app\Veronika\oradata\orcl\REDO04.LOG' 
SIZE 50M BLOCKSIZE 512;
select * from v$log;

ALTER DATABASE ADD LOGFILE GROUP 4  'C:\app\Veronika\oradata\orcl\REDO04.LOG' 
SIZE 50 M BLOCKSIZE 512;
alter database add logfile member  'C:\app\Veronika\oradata\orcl\REDO041.LOG' to group 4;
alter database add logfile member  'C:\app\Veronika\oradata\orcl\REDO042.LOG' to group 4;
alter database add logfile member  'C:\app\Veronika\oradata\orcl\REDO043.LOG' to group 4;
alter system switch logfile;
select * from v$log;
select GROUP#, FIRST_CHANGE# from v$log;
--13
alter database drop logfile member 'C:\app\Veronika\oradata\orcl\REDO041.LOG' ;
alter database drop logfile member 'C:\app\Veronika\oradata\orcl\REDO043.LOG';
alter database drop logfile member 'C:\app\Veronika\oradata\orcl\REDO042.LOG';
alter database drop logfile 'C:\app\Veronika\oradata\orcl\REDO04.LOG';
alter database drop logfile group 4;
alter database clear logfile group 4;
select * from v$log;
--14
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;
--15
SELECT MAX(SEQUENCE#) FROM V$ARCHIVED_LOG;
--select * from v$archived_log;
--16
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;

select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
select * from v$database;
select * from v$instance;
--17
alter system switch logfile;
select * from v$log;
SHOW PARAMETER DB_RECOVERY;
SELECT * FROM V$ARCHIVED_LOG;
--18

--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--alter database open;
select name, log_mode from v$database;
-----------------------------------------------------------------
--19
--show parameter control;
select * from v$controlfile;
--20
select type, record_size, records_total from v$controlfile_record_section;

--21
show parameter spfile;
--22
create pfile ='yan_pfile.ora' from spfile;
show parameter pfile;
ORACLE_HOME\database> attrib;
--23
show parameter remote_login_passwordfile;

select * from v$pwfile_users;
--24
select * from v$diag_info;
--25
DROP TABLESPACE YAN_QDATA1 INCLUDING CONTENTS AND DATAFILES;