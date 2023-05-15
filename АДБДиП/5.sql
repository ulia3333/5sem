alter session set "_ORACLE_SCRIPT" = true;

SELECT * FROM DBA_DATA_FILES;
select tablespace_name, contents from DBA_TABLESPACES;


SELECT name, description FROM v$parameter;

--1. Получите список всех файлов табличных пространств (перманентных  и временных).
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

alter tablespace gus_qdata_3 online;--перевести в состояне онлайн

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


--3. Получите список сегментов табличного пространства  XXX_QDATA. 
--Определите сегмент таблицы XXX_T1. Определите остальные сегменты.
select segment_name, segment_type
   from DBA_SEGMENTS where tablespace_name='GUS_QDATA_3';
--4. Удалите (DROP) таблицу XXX_T1. 
drop table gus_t1;
--Получите список сегментов табличного пространства  XXX_QDATA.
--Определите сегмент таблицы XXX_T1. 
--Выполните SELECT-запрос к представлению USER_RECYCLEBIN.
select * from user_recyclebin;

--5. Восстановите (FLASHBACK) удаленную таблицу. 
flashback table gus_t1 to before drop;

select *
from gus_t1;

--6. заполняющий таблицу XXX_T1 данными (10000 строк). 
BEGIN
  FOR k IN 4..10004
  LOOP
    insert into gus_t1 values(k, 'A');
  END LOOP;
  COMMIT;
END;
select * from gus_t1 ;


--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. 
select SEGMENT_NAME,EXTENT_ID,BYTES,BLOCKS
from user_extents;
--8. Удалите табличное пространство XXX_QDATA и его файл. 
drop tablespace gus_qdata_3 including contents and datafiles;

--9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;

--10. Получите перечень файлов всех журналов повтора инстанса.
SELECT * FROM V$LOGFILE;


--12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. 
-- Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). Проследите последовательность SCN. 
alter database add logfile group 4 'D:\app\REDO04.LOG' size 50 m blocksize 512;

alter database add logfile member 'D:\app\REDO041.LOG' to group 4;

alter database add logfile member 'D:\app\REDO042.LOG' to group 4;

select * from v$log;

alter system switch logfile;


--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).
ALTER SYSTEM SWITCH LOGFILE;
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;


---13.Удалите созданную группу журналов повтора
alter database clear logfile group 4;
--Удалите созданные вами файлы журналов на сервере.
alter database drop logfile group 4;

select *
from v$log;


--14. Определите, выполняется или нет архивирование журналов повтора (архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
select * from v$diag_info;
--15. Определите номер последнего архива.  
select * from v$archived_log; 

--16. EX.  Включите архивирование. 
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

--17. Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии. Проследите последовательность SCN в архивах и журналах повтора. 
alter system set log_archive_dest_1 = 'LOCATION=D:\app\archive';

alter system switch logfile;
SELECT NAME, FIRST_CHANGE#, NEXT_CHANGE# FROM V$ARCHIVED_LOG;


--18. Отключите архивирование. Убедитесь, что архивирование отключено.  
--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--select name, log_mode from v$database;
--alter database open;

--archive log list;--список архивных журналов

--19. Получите список управляющих файлов.
select name from v$controlfile;

--20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.
show parameter control;

--21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. 
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
show parameter spfile ;

--22. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.
--CREATE PFILE='GUS_PFILE.ora' FROM SPFILE;
-- в папке D:\app\oracle_install_user\product\12.1.0\dbhome_1\database


--23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. 
SELECT * FROM V$PWFILE_USERS;
SELECT * FROM V$DIAG_INFO;
show parameter remote_login_passwordfile;



