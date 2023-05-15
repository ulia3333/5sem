--1. ���������� ����� ������ ������� SGA
select sum(value) from v$sga;

--2.	���������� ������� ������� �������� ����� SGA.
select * from v$sga_dynamic_components where current_size > 0;

--3.���������� ������� ��� ������� ����
select component, granule_size from v$sga_dynamic_components where current_size > 0;

--4.���������� ����� ��������� ��������� ������ � SGA
select current_size from v$sga_dynamic_free_memory;

--5.���������� ������� ����� KEEP, DEFAULT, RECYCLE ��������� ����
select component, current_size 
from v$sga_dynamic_components 
where component like '%DEFAULT%'
  or  component like '%KEEP%'
  or  component like '%RECYCLE%';
--6.�������� �������, ������� ����� ���������� � ��� KEEP. ����������������� ������� �������
create table Mytable(x int) storage(buffer_pool keep);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name)='mytable';

--7.�������� �������, ������� ����� ������������ � ���� default. ������������������ ������ �������
create table Mytable2(x int) cache storage(buffer_pool default);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name)='mytable2';

--8.������� ������ ������ �������� �������
show parameter log_buffer;

--9.����� 10 ����� ������� �������� � ����������� ����
select *from (select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc) where rownum <=10;

--10. ������� ������ ��������� ������ � ������� ����
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.�������� �������� ������� ���������� � ���������
select * from v$session;

--12. ���������� ������ ������� ��������� � ���������
select username, server from v$session;

