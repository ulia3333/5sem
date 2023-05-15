--1. ������ ������������ ����������� �����
grant create session to C##U_GUS_PDB;
grant create table to C##U_GUS_PDB;-- 7, 9-11, 15
grant create view to C##U_GUS_PDB;-- 15
grant create any sequence to C##U_GUS_PDB;-- 2-6
grant create cluster to C##U_GUS_PDB;-- 8
grant create public synonym to C##U_GUS_PDB;-- 14
grant create synonym to C##U_GUS_PDB;-- 13
grant create materialized view to C##U_GUS_PDB;-- 16
grant drop any table to C##U_GUS_PDB;
grant drop any view to C##U_GUS_PDB;
grant drop any sequence to C##U_GUS_PDB;
grant drop any cluster to C##U_GUS_PDB;
grant drop any synonym to C##U_GUS_PDB;
grant drop public synonym to C##U_GUS_PDB;
grant select any sequence to C##U_GUS_PDB;
alter user C##U_GUS_PDB quota unlimited on users;

--2. ������� ������������������ S1 (SEQUENCE). 
--   �������� ��������� �������� ������������������.
--   �������� ������� �������� ������������������.
drop sequence S1;
create sequence S1
    start with 1000
    increment by 10
    nomaxvalue
    nominvalue
    nocycle
    nocache
    noorder;
select s1.nextval from dual;
select s1.currval from dual;

--3. ������� ������������������ S2 (SEQUENCE).
--   �������� ��� �������� ������������������.
--   ����������� �������� ��������, ��������� �� ������������ ��������.
drop sequence S2;
create sequence S2
   start with 10
   increment by 10
   maxvalue 100
   nocycle;
select s2.nextval from dual;
alter sequence s2 increment by -10;

--4. ������� ������������������ S3 (SEQUENCE).
--   �������� ��� �������� ������������������.
--   ����������� �������� ��������, ������ ������������ ��������.
drop sequence S3;
create sequence S3
   start with 10
   increment by -10
   maxvalue 20
   minvalue -100
   nocycle
   order;
select s3.nextval from dual;
alter sequence s3 increment by 10;

--5. ������� ������������������ S4 (SEQUENCE).
--   ����������������� ����������� ��������� �������� ������������������� S4.
drop sequence S4;
create sequence S4
   start with 1
   increment by 1
   maxvalue 10
   cycle
   cache 5
   noorder;
select s4.nextval from dual;

--6. �������� ������ ���� ������������������� � ������� ���� ������, 
--   ���������� ������� �������� ������������ 
select * from sys.all_sequences where sequence_owner='C##U_GUS_PDB';

--7. ������� �������
--   �������� 7 �����, �������� �������� ��� �������� ������ 
--   ������������� � ������� ������������������� S1, S2, S3, S4
create table T1 (
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
    );
commit;
alter table T1 cache storage (buffer_pool keep);
BEGIN
  FOR i IN 1..7 LOOP
  insert into T1(N1,N2,N3,N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
  END LOOP;
END;
select * from T1;

--8. ������� ������� ABC, ������� hash-��� 
drop cluster ABC;
create cluster ABC
    (
        x number(10),
        v varchar2(12)
    )
    hashkeys 200;
commit;

--9-11. �������� ������� A/B/C, ������� ������� XA/XB/XC � VA/VB/VC, 
--      ������������� �������� ABC, � ���� ������������ �������.
create table A(XA number(10), VA varchar(12), QA char(10)) cluster ABC(XA,VA);
create table B(XB number(10), VB varchar(12), QB char(10)) cluster ABC(XB,VB);
create table C(XC number(10), VC varchar(12), QC char(10)) cluster ABC(XC,VC);
commit;

--12.	������� ��������� ������� � ������� � �������������� ������� Oracle.
select cluster_name, owner from DBA_CLUSTERS where cluster_name='ABC';
select * from dba_tables where cluster_name='ABC';

--13.	�������� ������� ������� ��� ������� XXX.� 
drop synonym Syn1;
create synonym Syn1 for C;
 select SYNONYM_NAME,TABLE_OWNER,TABLE_NAME,OWNER 
  from dba_synonyms where SYNONYM_NAME='SYN1';

--14.	�������� ��������� ������� ��� ������� XXX.B 
drop public synonym Syn2;
create public synonym Syn2 for B;
 select SYNONYM_NAME,TABLE_OWNER,TABLE_NAME,OWNER 
  from dba_synonyms where SYNONYM_NAME='SYN2';

--15.	�������� ��� ������������ ������� A � B, ��������� �� �������, 
-- �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. 
drop table A2;
drop table B2;
create table A2 (
    Q number(20) primary key
    );
create table B2 (
    W number(20),
    constraint fk_column
    foreign key (W) references A2(Q)
    );
insert into A2(Q) values (1);
insert into A2(Q) values (2);
insert into B2(W) values (1);
insert into B2(W) values (2);
commit;  
create view V1
as select Q, W from A2 inner join B2 on A2.Q=B2.W;

select * from V1;

--16.	�� ������ ������ A � B �������� ����������������� ������������� MV
drop materialized view MV;
create materialized view MV
    build immediate
    refresh complete
    start with sysdate
    next sysdate + numtodsinterval(1, 'minute')
    as
    select A2.Q, B2.W
from (select count(*) Q from A2) a2,
         (select count(*) W from B2) b2;

select * from MV;
select * from A2;
insert into A2(Q) values (9);
commit;
delete A2 where Q=9;


