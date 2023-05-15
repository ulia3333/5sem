
--1.список всех файлов табличных пространств
select *
from dba_tablespaces;
--2.
alter session set "_ORACLE_SCRIPT" = true;
alter session set nls_language = 'AMERICAN';

--drop tablespace lms_qdata including contents;
--drop role lms_qrole;
--drop table lms_t1;
--DROP USER lms CASCADE;

create tablespace lms_qdata_2
datafile 'lms_qdata_2.dbf'
size 10 m
offline;

alter tablespace lms_qdata_2 online;--перевести в состояне онлайн

create role lms_qrole;

grant create session, create table, create view, create procedure to lms_qrole;

create profile lms_qprofile
    limit password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default
    connect_time 180
    idle_time 30;

select * from DBA_TABLESPACES;
create user lms identified by qwerty default tablespace lms_qdata_2 quota unlimited on lms_qdata_2 profile lms_qprofile account unlock;
--grant quota unlimited to lms;--предоставитьь не ограниченное пространство  в Oracle

select * from DBA_USERS;

alter user lms quota 2 m on lms_qdata_2;--Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA
grant lms_qrole to lms;

create table lms_t1
( id   number(8) primary key,
    name varchar2(16)
) tablespace lms_qdata_2;
--добавить три строки
insert into lms_t1
values (1,'Marina');
insert into lms_t1
values (2,'Alina');
insert into lms_t1
values (3,'Anton');

select * from lms_t1;
--drop table lms_t1;

-- Task 3
select segment_name, segment_type
   from DBA_SEGMENTS where tablespace_name='lms_QDATA_2';

--4.4. Удалите таблицу
drop table lms_t1;

---Изменяется имя сегмента, и информация об удалении записывается в словарь бд.
select segment_name, segment_type
   from DBA_SEGMENTS where tablespace_name='lms_QDATA_2';

---инфа о корзине, принадлежащей текущему пользователю
select *
from recyclebin;

--Выполните SELECT-запрос к представлению USER_RECYCLEBIN
SELECT SUBSTR(object_name,1,50),object_type,owner
FROM dba_objects
WHERE object_name LIKE '%RECYCLEBIN%';

---5.Восстановите (FLASHBACK) удаленную таблицу
flashback table lms_t1 to before drop;

select *
from lms_t1;

--6.Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).
BEGIN
  FOR k IN 4..10004
  LOOP
    insert into lms_t1 values(k, 'A');
  END LOOP;
  COMMIT;
END;
select * from lms_t1 ;

---7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов.

select extent_id,
       blocks,
       bytes
from dba_extents
where segment_name like 'lms_T1';


---8.Удалите табличное пространство XXX_QDATA и его файл.
drop tablespace lms_qdata including contents and datafiles;

--9.Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
select *
from v$log;

--10.Получите перечень файлов всех журналов повтора инстанса.
select *
from v$logfile;
---------------------------------------------------------------
--11.изменяем систему на переключатель журналов
alter system switch logfile;

-- 4673479

select *
from v$log;

--12.дополнительная группа журналов повтора
alter database add logfile group 4 'D:\3kr_5sem\lab5\REDO04.LOG' size 50 m blocksize 512;

alter database add logfile member 'D:\3kr_5sem\lab5\REDO041.LOG' to group 4;

alter database add logfile member 'D:\3kr_5sem\lab5\REDO042.LOG' to group 4;

select *
from v$log;

alter system switch logfile;--switch-переключатель системы

---13.Удалите созданную группу журналов повтора
alter database clear logfile group 4;
--Удалите созданные вами файлы журналов на сервере.
alter database drop logfile group 4;

select *
from v$log;

--14.выполняется или нет архивирование журналов

select * from v$DATABASE;
select * from v$instance;

---15. Определите номер последнего архива.
select *
from v$archived_log;

--16.Включите архивирование.
-- sqlplus /nolog
-- connect /as sysdba
-- shutdown immediate;--немедленное выключение
-- startup mount;--старт
-- alter database archivelog;--изменить архивный журнал базы данных
-- alter database open;--изменить открытую базу данных

--17.Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии.
--Проследите последовательность SCN в архивах и журналах повтора.

alter system set log_archive_dest_1 = 'LOCATION=D:\3kr_5sem\lab5\archive';

alter system switch logfile;
---наличие файла
select *
from v$archived_log;

-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;
select * from v$DATABASE;

--18.Отключите архивирование. Убедитесь, что архивирование отключено.
-- connnect /as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database noarchivelog;
-- select name, log_mode from v$database;
-- alter database open;

--archive log list;--список архивных журналов
--19.Получите список управляющих файлов.
select *
from v$controlfile;

-- Task 20
show parameter control;

-- Task 21
alter database backup controlfile to trace as 'C:\Users\Administrator\Programs\Oracle\oradata\ORCL\control-to-trace.txt';

show parameter spfile;

-- Task 22
create pfile = 'lms_pfile.ora' from spfile;

-- create spfile = 'spfileorcl1.ora'from pfile = 'lms_pfile.ora';
-- C:\Users\Administrator\Downloads\WINDOWS.X64_193000_db_home\database

select decode(value,null, 'PFILE','SPFILE') "Init File Type"--тип файла инициализации
from sys.v_$parameter
where name = 'spfile';

-- Task 23
select *
from v$pwfile_users;--перечисляет всех пользователей в файле паролей и указывает были ли предоставлены пользователю привелегии SYSDBA

show parameter remote_login_passwordfile;

--14.перечень директориев для файлов сообщений и диагностики
select *
from v$diag_info;
