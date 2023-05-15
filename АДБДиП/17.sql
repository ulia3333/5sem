ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

ALTER SYSTEM SET JOB_QUEUE_PROCESSES = 5;

--1.	������������ ����� ���������� �������, � �������:
--2.	��� � ������ � ������������ ����� ����������� ����������� ����� ������ �� ������� �� ����� ������� � ������, ����� ���� ��� ������ �� ������ ������� ���������. 
--3.	���������� ���������, ���� �� ��������� �������, � � �����-���� ������� ��������� �������� � �������� ����������, ��� ��������, ��� � ����������.
--4.	���������� ���������, ����������� �� ������ ��� �������.
--5.	���������� ���� ����������� ��������� ������� � ������ �����, ������������� ��� �������� ������.

grant create job to C##U_GUS_PDB;
--����� ���������� �������
drop table WORKOFFERS;
drop table WORKOFFERS_ARCH;
create table WORKOFFERS
(
  workerid int primary key,
  fullname varchar2(255),
  offerdate date
);

create table WORKOFFERS_ARCH
(
  workerid int primary key,
  fullname varchar2(255),
  offerdate date
);

insert into WORKOFFERS values (1, '��������� ���� ���������', '18.12.2022');
insert into WORKOFFERS values (2, '�o���� ���������� ���������', '10.12.2022');
insert into WORKOFFERS values (3, '������ ����� ���������', '01.11.2022');
insert into WORKOFFERS values (4, '������ ����� ���������', '18.11.2022');
insert into WORKOFFERS values (5, '����� ����� ����������', '14.10.2022');

drop table JOBAUDIT;
create table JOBAUDIT 
(
  jobnumber number,
  last_date date,
  last_sec varchar2(8),
  runresult varchar2(15)
);
select * from JOBAUDIT;
--����� � ���� ���� � �������� �� ������ ����
create or replace procedure ARCHOFFERS (startdate date, enddate date)
    is
    countdict int;
    begin
      insert into WORKOFFERS_ARCH select * from WORKOFFERS where offerdate between startdate and enddate;
      delete from WORKOFFERS where offerdate between startdate and enddate;
end ARCHOFFERS;

begin
ARCHOFFERS('14.10.2022', '18.12.2022');
end;
select * from WORKOFFERS_ARCH;
select * from WORKOFFERS;
------------- ����� DBMS_JOB ------------

create or replace package LAB17_TASK01_PKG is
  procedure ARCHOFFERS (startdate date, enddate date);
  procedure CREATE_JOB (jobnumber number);
  procedure CHECK_JOB (jobnumber number);
  procedure IS_JOB_RUNNING (jobnumber number);
  procedure RETIME_JOB (jobnumber number);
  procedure SUSPEND_JOB (jobnumber number);
  procedure CANCEL_JOB (jobnumber number);
end LAB17_TASK01_PKG;

create or replace package body LAB17_TASK01_PKG is
    
    --1.����� � ���� ���� � ��������� �� ������ ����
    procedure ARCHOFFERS (startdate date, enddate date)
    is
    countdict int;
    begin
      insert into WORKOFFERS_ARCH select * from WORKOFFERS where offerdate between startdate and enddate;
      delete from WORKOFFERS where offerdate between startdate and enddate;
    end ARCHOFFERS;
    
    --2.�������� ������� � �������
    procedure CREATE_JOB (jobnumber number)
    is
        startdate DATE := to_date('01.12.2022','DD.MM.YYYY');
        enddate DATE := to_date('18.12.2022','DD.MM.YYYY');
        action varchar2(255) := 'begin ARCHOFFERS(''' 
                                || to_char(startdate, 'DD.MM.YYYY') 
                                || ''',''' 
                                || to_char(enddate,'DD.MM.YYYY') 
                                || '''); end;';
    begin
        dbms_job.isubmit(jobnumber, 
                       action, 
                       SYSDATE, 
                       --'SYSDATE + 60/86400' 
                       --'SYSDATE + interval ''7'' day' 
                       'SYSDATE + interval ''1'' minute'
                       );
        commit;
    end CREATE_JOB;
    
    --3.��������� �� �������
    procedure CHECK_JOB (jobnumber number)
    is
      res number;
      resstatus varchar2(15);
    begin
        insert into JOBAUDIT (select JOB, LAST_DATE, LAST_SEC, case when FAILURES = 0 then 'SUCCESS' else 'FAILURE' end from user_jobs where JOB = jobnumber); 
        commit;
    end CHECK_JOB;
    
    --4. ����������� �� ������
    procedure IS_JOB_RUNNING (jobnumber number)
    is
        runningtime date;
    begin
        select THIS_DATE into runningtime from user_jobs where JOB = jobnumber;
        if runningtime is null then dbms_output.put_line('������ �� �����������');
        else dbms_output.put_line('������ �����������');
        end if;
    end IS_JOB_RUNNING;
    
    --5. ��� ���������� �������
    procedure RETIME_JOB (jobnumber number)
    is
    begin
        dbms_job.change(jobnumber, null, null, 'SYSDATE + interval ''5'' minute');
    end RETIME_JOB;
    
    --6. ��� ������� ���������
    procedure SUSPEND_JOB (jobnumber number)
    is
    begin
        dbms_job.next_date(jobnumber, SYSDATE + interval '10' minute);
    end SUSPEND_JOB;
    
    --7. ���������� �������
    procedure CANCEL_JOB (jobnumber number)
    is
    begin
        dbms_job.broken(jobnumber, true, null);
    end CANCEL_JOB;
    
end LAB17_TASK01_PKG;

--�������� �����
begin
  LAB17_TASK01_PKG.CREATE_JOB(98);
end;

begin
dbms_job.run(98);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;


select * from
begin
  LAB17_TASK01_PKG.CHECK_JOB(98);
end;

select * from JOBAUDIT;

--
begin
  LAB17_TASK01_PKG.IS_JOB_RUNNING(98);
end;

begin
  LAB17_TASK01_PKG.RETIME_JOB(97);
end;
select JOB, INTERVAL from user_jobs;

begin
  LAB17_TASK01_PKG.SUSPEND_JOB(97);
end;

begin
  LAB17_TASK01_PKG.CANCEL_JOB(97);
end;




drop table WORKOFFERS;
drop table WORKOFFERS_ARCH;
drop table JOBAUDIT;

drop package LAB17_TASK01_PKG;



--------------------------------------------------------
----------------------------------------------------------
-----------------------------------------------------------
drop procedure SCHEDULPROC;
drop package LAB17_TASK02_PKG;
drop table JOBAUDIT_SCHEDULED;

create or replace procedure SCHEDULPROC (startdate date, enddate date)
    is
    countdict int;
    begin
      insert into WORKOFFERS_ARCH select * from WORKOFFERS where offerdate between startdate and enddate;
      delete from WORKOFFERS where offerdate between startdate and enddate;
end SCHEDULPROC;

create or replace package LAB17_TASK02_PKG 
is
   procedure BUILD_JOB (jobname user_scheduler_jobs.job_name%type);
   procedure CHECK_JOB (jobname user_scheduler_jobs.job_name%type);
   procedure IS_JOB_RUNNING (jobname user_scheduler_jobs.job_name%type);
   procedure RETIME_JOB;
   procedure SUSPEND_JOB (jobname user_scheduler_jobs.job_name%type);
   procedure RESUME_JOB (jobname user_scheduler_jobs.job_name%type);
   procedure CANCEL_JOB (jobname user_scheduler_jobs.job_name%type);
end LAB17_TASK02_PKG;

create or replace package body LAB17_TASK02_PKG is  
    procedure BUILD_JOB (jobname user_scheduler_jobs.job_name%type)
    is
    begin  
    --����������
    dbms_scheduler.create_schedule(
    schedule_name => 'Sch01',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=5;',
    comments => 'Sch01');
    
    --���������  
    dbms_scheduler.create_program(
    program_name => 'Pr01',
    program_type => 'STORED_PROCEDURE',
    program_action => 'SCHEDULPROC',
    number_of_arguments => 2,
    enabled => false,
    comments => 'SCHEDULPROC'); 

    dbms_scheduler.define_program_argument(
    program_name => 'Pr01', 
    argument_name => 'startdate', 
    argument_position => 1,  
    argument_type  => 'DATE', 
    default_value  => null);

    dbms_scheduler.define_program_argument(
    program_name => 'Pr01', 
    argument_name => 'enddate', 
    argument_position => 2,  
    argument_type  => 'DATE', 
    default_value  => null);

    dbms_scheduler.enable (name => 'Pr01');

    --�������� ���������
    dbms_scheduler.create_job(
    job_name => jobname, 
    program_name => 'Pr01', 
    schedule_name => 'Sch01',
    enabled => true);
    
    dbms_scheduler.set_job_argument_value(job_name => jobname, argument_position => 1, argument_value => to_date('01.12.2022','DD.MM.YYYY'));
    dbms_scheduler.set_job_argument_value(job_name => jobname, argument_position => 2, argument_value => to_date('18.12.2022','DD.MM.YYYY'));

    commit;
    
    end BUILD_JOB;
    
--3.��������� �� �������
   procedure CHECK_JOB (jobname user_scheduler_jobs.job_name%type)
    is
    begin
       delete from JOBAUDIT_SCHEDULED;
       insert into JOBAUDIT_SCHEDULED (select JOB_NAME, LOG_DATE, STATUS from user_scheduler_job_log where JOB_NAME = jobname); 
       commit;
    end CHECK_JOB;
    
--4.����������� �� �������
    procedure IS_JOB_RUNNING (jobname user_scheduler_jobs.job_name%type)
    is
    ispresent int;
    begin
      select count(*) into ispresent from user_scheduler_running_jobs where JOB_NAME = jobname;
        if ispresent = 0 then dbms_output.put_line('������ �� �����������');
        else dbms_output.put_line('������ �����������');
        end if;
    end IS_JOB_RUNNING;
 
  --5.� �� �����
    procedure RETIME_JOB
    is
    begin
        dbms_scheduler.set_attribute(name => 'SCH01', attribute => 'repeat_interval', value => 'FREQ=MINUTELY;INTERVAL=10;');
    end RETIME_JOB;
    
    --6.
    
     procedure SUSPEND_JOB (jobname user_scheduler_jobs.job_name%type)
     is
      begin
          dbms_scheduler.disable(jobname);
    end SUSPEND_JOB;
    
    --6.1 �������������
    procedure RESUME_JOB (jobname user_scheduler_jobs.job_name%type)
     is
      begin
          dbms_scheduler.enable(jobname);
    end RESUME_JOB;
    
   --7.��������
    procedure CANCEL_JOB (jobname user_scheduler_jobs.job_name%type)
    is
    begin
      dbms_scheduler.stop_job(job_name => jobname);
    end CANCEL_JOB;
    
end LAB17_TASK02_PKG;

create table JOBAUDIT_SCHEDULED
(
  jobname varchar2(261),
  logdate timestamp(6) with time zone,
  status varchar2(30)
);

begin
  LAB17_TASK02_PKG.BUILD_JOB('ARCH_WORKERS_JOB1');
end;

begin
  LAB17_TASK02_PKG.CHECK_JOB('ARCH_WORKERS_JOB1');
end;

begin
  LAB17_TASK02_PKG.IS_JOB_RUNNING('ARCH_WORKERS_JOB1');
end;

begin
  LAB17_TASK02_PKG.RETIME_JOB;
end;

begin
  LAB17_TASK02_PKG.SUSPEND_JOB('ARCH_WORKERS_JOB1');
end;

begin
  LAB17_TASK02_PKG.RESUME_JOB('ARCH_WORKERS_JOB1');
end;

begin
  LAB17_TASK02_PKG.CANCEL_JOB('ARCH_WORKERS_JOB1');
end;







