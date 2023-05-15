--1.	Найдите на компьютере конфигурационные файлы SQLNET.ORA и
--    TNSNAMES.ORA и ознакомьтесь с их содержимым.
--D:\app\oracle_install_user\product\12.1.0\dbhome_1\NETWORK\ADMIN

--2.	Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM, 
--    получите перечень параметров экземпляра Oracle.
select name, description from v$parameter;

--3.	Соединитесь при помощи sqlplus с подключаемой базой данных как 
--    пользователь SYSTEM, получите список табличных пространств, 
--    файлов табличных пространств, ролей и пользователей.
select TABLESPACE_NAME from DBA_TABLESPACES; 
SELECT file_name, tablespace_name FROM DBA_DATA_FILES;
select ROLE  from DBA_ROLES;
select USERNAME from dba_users;

--4.	Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере.
--INST_LOC - Задает расположение файлов универсального установщика Oracle. 

--5.	Запустите утилиту Oracle Net Manager и подготовьте строку подключения
--    с именем имя_вашего_пользователя_SID, где SID – идентификатор 
--    подключаемой базы данных. 
--connect C##U_GUS_PDB/12345@gus_pdb;

--6.	Подключитесь с помощью sqlplus под собственным пользователем 
--    и с применением подготовленной строки подключения. 
connect C##U_GUS_PDB/12345@gus_pdb;

--7.	Выполните select к любой таблице, которой владеет ваш пользователь. 
select * from gus_table;

--8.	Ознакомьтесь с командой HELP.Получите справку по команде TIMING.
--    Подсчитайте, сколько времени длится select к любой таблице.
set timing on
select * from gus_table;
--Elapsed: 00:00:00.004
set timing off

--9.	Ознакомьтесь с командой DESCRIBE.Получите описание столбцов любой таблицы.
describe gus_table;

--10.	Получите перечень всех сегментов, владельцем которых является ваш пользователь.
select * from user_segments;

--11.	Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают
grant drop any view TO  C##U_GUS_PDB;
grant create any view to C##U_GUS_PDB container=all;


drop view v_gus;
create view v_gus as select count(*)  segments_count, sum(extents) extents_count,sum(blocks) bloks_count, sum(bytes) memory_size from user_segments;

SELECT * FROM v_gus;












