--1.	�������� ������ ������ ������� ���������. 
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

--2.	���������� ������� ��������, ������� �������� � �������� � ��������� ������.
SELECT * FROM v$process ; 

--3.	����������, ������� ��������� DBWn �������� � ��������� ������.
show parameter db_writer_processes;

--4.	�������� �������� ������� ���������� � �����������.
SELECT * FROM V$INSTANCE;

--5.	���������� ������ ���� ����������.
select name, log_mode from v$database;
select  INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

--6.	���������� ������� (����� ����������� ����������).
select NAME,NETWORK_NAME,PDB from V$SERVICES ;  

--7.	�������� ��������� ��� ��������� ���������� � �� ��������.
SELECT * FROM V$DISPATCHER;
show parameter DISPATCHERS;

--8.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
--OracleOraDB12Home1TNSListener

--9.	�������� �������� ������� ���������� � ���������. (dedicated, shared). 
SELECT USERNAME,SERVER FROM V$SESSION;

--10.	����������������� � �������� ���������� ����� LISTENER.ORA. 
--D:\app\ora_natasha\product\12.1.0\dbhome_1\NETWORK\ADMIN

--11-12.	��������� ������� lsnrctl � �������� �� �������� �������. 
--�������� ������ ����� ��������, ������������� ��������� LISTENER. 


