--1.	������� �� ���������� ���������������� ����� SQLNET.ORA �
--    TNSNAMES.ORA � ������������ � �� ����������.
--D:\app\oracle_install_user\product\12.1.0\dbhome_1\NETWORK\ADMIN

--2.	����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM, 
--    �������� �������� ���������� ���������� Oracle.
select name, description from v$parameter;

--3.	����������� ��� ������ sqlplus � ������������ ����� ������ ��� 
--    ������������ SYSTEM, �������� ������ ��������� �����������, 
--    ������ ��������� �����������, ����� � �������������.
select TABLESPACE_NAME from DBA_TABLESPACES; 
SELECT file_name, tablespace_name FROM DBA_DATA_FILES;
select ROLE  from DBA_ROLES;
select USERNAME from dba_users;

--4.	������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������.
--INST_LOC - ������ ������������ ������ �������������� ����������� Oracle. 

--5.	��������� ������� Oracle Net Manager � ����������� ������ �����������
--    � ������ ���_������_������������_SID, ��� SID � ������������� 
--    ������������ ���� ������. 
--connect C##U_GUS_PDB/12345@gus_pdb;

--6.	������������ � ������� sqlplus ��� ����������� ������������� 
--    � � ����������� �������������� ������ �����������. 
connect C##U_GUS_PDB/12345@gus_pdb;

--7.	��������� select � ����� �������, ������� ������� ��� ������������. 
select * from gus_table;

--8.	������������ � �������� HELP.�������� ������� �� ������� TIMING.
--    �����������, ������� ������� ������ select � ����� �������.
set timing on
select * from gus_table;
--Elapsed: 00:00:00.004
set timing off

--9.	������������ � �������� DESCRIBE.�������� �������� �������� ����� �������.
describe gus_table;

--10.	�������� �������� ���� ���������, ���������� ������� �������� ��� ������������.
select * from user_segments;

--11.	�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������
grant drop any view TO  C##U_GUS_PDB;
grant create any view to C##U_GUS_PDB container=all;


drop view v_gus;
create view v_gus as select count(*)  segments_count, sum(extents) extents_count,sum(blocks) bloks_count, sum(bytes) memory_size from user_segments;

SELECT * FROM v_gus;












