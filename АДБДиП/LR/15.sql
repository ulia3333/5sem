grant CREATE TRIGGER to C##U_GUS_PDB;
grant CREATE ANY TRIGGER   to C##U_GUS_PDB;
grant ALTER ANY TRIGGER   to C##U_GUS_PDB;
grant DROP ANY TRIGGER   to C##U_GUS_PDB;
grant ADMINISTER DATABASE TRIGGER  to C##U_GUS_PDB;
drop table t_pk;
drop table audits;

drop trigger before_trigger;
drop trigger before_trigger_row;
drop trigger after_trigger;
drop trigger after_trigger_row;
    
drop trigger audits_trigger_after_row;
drop trigger audits_trigger_after;
drop trigger audits_trigger_before;
drop trigger audits_trigger_before_row;

drop trigger no_drop_trg;
drop view tablview;

ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
--1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
drop table t_pk;
create table t_pk(x int primary key, y varchar(30));
--2.	��������� ������� �������� (10 ��.).
declare
q number(3):=0;
w number(3):=10;
begin
  while q<10
  loop
    q :=q+1;
    insert into t_pk(x,y) values (q,w);
    w :=w-1;
  end loop;
end;
COMMIT;
select * from t_pk;

--3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. 
drop trigger before_trigger;

create or replace trigger before_trigger
  before insert or delete or update on t_pk
    begin
      if inserting then
        dbms_output.put_line('�������� before-������� �� ������� insert');
      elsif deleting then
        dbms_output.put_line('�������� before-������� �� ������� delete');
      elsif updating then
        dbms_output.put_line('�������� before-������� �� ������� update');
      end if;
    end;

--5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
drop trigger before_trigger_row;

create or replace trigger before_trigger_row
  before insert or delete or update on t_pk
  for each row
    begin 
      if inserting then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� insert');
      elsif deleting then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� delete');
      elsif updating then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� update');
      end if;
    end;

--6.	��������� ��������� INSERTING, UPDATING � DELETING.
insert into t_pk(x,y) values(11,0);
update t_pk set y=9 where x=10;
delete t_pk where x='11';

--7.	������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
drop trigger after_trigger;

create or replace trigger after_trigger
  after insert or delete or update on t_pk
    begin 
      if inserting then
        dbms_output.put_line('�������� after-������� �� ������� insert');
      elsif deleting then
        dbms_output.put_line('�������� after-������� �� ������� delete');
      elsif updating then
        dbms_output.put_line('�������� after-������� �� ������� update');
      end if;
    end;
--8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
drop trigger after_trigger_row;

create or replace trigger after_trigger_row
  after insert or delete or update on t_pk
  for each row
    begin 
      if inserting then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� insert');
      elsif deleting then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� delete');
      elsif updating then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� update');
      end if;
    end;
--9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: 
--OperationDate, 
--OperationType (�������� �������, ���������� � ��������),
--TriggerName(��� ��������),
--Data (������ � ���������� ����� �� � ����� ��������).
DROP TABLE AUDITS;

CREATE TABLE AUDITS
(
    ID numeric(10,0) GENERATED ALWAYS AS IDENTITY,
    OperationDate date NOT NULL,
    OperationType varchar(6) NOT NULL,
    TriggerName varchar(30) NOT NULL,
    OldData varchar(200) NULL,
    NewData varchar(200) NULL,
    PRIMARY KEY (ID)
);

--10.	�������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.
create or replace trigger audits_trigger_before
  before insert or update or delete on t_pk
    begin
      if inserting then
        dbms_output.put_line('�������� before-������� �� ������� insert ������� audits');
        insert into AUDITS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'audits_trigger_before',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif updating then
        dbms_output.put_line('�������� before-������� �� ������� update ������� audits');
        insert into AUDITS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'audits_trigger_before',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif deleting then
        dbms_output.put_line('�������� before-������� �� ������� delete ������� audits');
        insert into AUDITS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'audits_trigger_before',concat(t_pk.x ,t_pk.y)
        from t_pk;
      end if;
    end;
    
  
    -------------------------------
create or replace trigger audits_trigger_after
  after insert or update  or delete on t_pk
    begin
      if inserting then
        dbms_output.put_line('�������� after-������� �� ������� insert ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'audits_trigger_after',concat(x ,y)
        from t_pk;
      elsif updating then
        dbms_output.put_line('�������� after-������� �� ������� update ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'audits_trigger_after',concat(x ,y)
        from t_pk;
      elsif deleting then
        dbms_output.put_line('�������� after-������� �� ������� delete ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'audits_trigger_after',concat(x ,y)
        from t_pk;
      end if;
    end; 

drop trigger audits_trigger_after_row;
drop trigger audits_trigger_after;
drop trigger audits_trigger_before;
drop trigger audits_trigger_before_row;
--*****
--11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������, ��������������� �� ������� ��� �������. ��������� ���������.
select * from t_pk;
select * from audits;
insert into t_pk(x,y) values(11,0);
update t_pk set y=9 where x=10;
delete t_pk where x='11';
    
select object_name, status from user_objects where object_type='TRIGGER';
---******
--12.	������� (drop) �������� �������. ��������� ���������. 

drop table t_pk;
---****
--.. ��� �������, ������. ���� t_pk
drop trigger no_drop_trg;
CREATE OR REPLACE TRIGGER no_drop_trg
  BEFORE DROP ON SCHEMA
    BEGIN
        IF ORA_DICT_OBJ_NAME = 'T_PK'
        THEN
        RAISE_APPLICATION_ERROR (-20905, '������ ������� t_pk!!!');
        END IF;
    END; 
--13.	������� (drop) ������� AUDIT.��������� ���������.
drop table audits;

drop trigger no_drop_trg_AUDITS;
CREATE OR REPLACE TRIGGER no_drop_trg_AUDITS
  BEFORE DROP ON SCHEMA
    BEGIN
        IF ORA_DICT_OBJ_NAME = 'AUDITS'
        THEN
        RAISE_APPLICATION_ERROR (-20905, '������ ������� AUDITS!!!');
        END IF;
    END;
--14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. ������� ������ ��������� ������ � �������.
--15.	�����������������, � ����� ������� ����������� ��������.
drop view tablview;
create view tablview as SELECT * FROM t_pk;
    
CREATE OR REPLACE TRIGGER tabl_trigg
instead of insert on tablview
  BEGIN
     if inserting then
       dbms_output.put_line('insert');
       insert into t_pk VALUES (102, 'b');
     end if;
   END tabl_trigg;
    
INSERT INTO tablview (x,y) values(12,'c');
SELECT * FROM tablview;




-----------------------------------------------------------------------

create or replace trigger audits_trigger_before_row
  before insert or update  or delete on t_pk
  for each row
    begin
      if inserting then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� insert ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'AUDITS_trigger_before_row',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif updating then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� update ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'AUDITS_trigger_before_row',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif deleting then
        dbms_output.put_line('�������� before-������� ������ ������ �� ������� delete ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'AUDITS_trigger_before_row',concat(x ,y)
        from t_pk;
      end if;
    end;


    
create or replace trigger audits_trigger_after_row
  after insert or update  or delete on t_pk
  for each row
    begin
      if inserting then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� insert ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'AUDITS_trigger_after_row',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif updating then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� update ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'AUDITS_trigger_after_row',concat(t_pk.x ,t_pk.y)
        from t_pk;
      elsif deleting then
        dbms_output.put_line('�������� after-������� ������ ������ �� ������� delete ������� audits');
        insert into audits(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'AUDITS_trigger_after_row',concat(x ,y)
        from t_pk;
      end if;
    end;
        
    

