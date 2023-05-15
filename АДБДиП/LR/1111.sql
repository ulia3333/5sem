--alter pluggable database SVA_PDB open;
--alter session set container = CDB$ROOT;
--alter session set container = SVA_PDB;
--ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
GRANT CREATE JOB TO C##U_GUS_PDB;
GRANT CREATE EXTERNAL JOB TO C##U_GUS_PDB;
GRANT MANAGE SCHEDULER TO C##U_GUS_PDB;
GRANT EXECUTE ON DBMS_SCHEDULER TO C##U_GUS_PDB;

--созд таблицы куда копир д-е
drop table teacher_backup;
create table teacher_backup (
teacher char(10),
teacher_name nvarchar2(50),
pulpit char(10),
BIRTHDAY date,
salary number
);

drop table teacher_backup2;
create table teacher_backup2 (
teacher char(10),
teacher_name nvarchar2(50),
pulpit char(10),
BIRTHDAY date,
salary number
);
drop table job_status;
create table job_status (
status nvarchar2(50),
datetime timestamp default current_timestamp
);

--копирование части д-х по усл.из 1 табл в другую из первой табл д-е удаляются
--провер.выполнено ли задание + сохран.сведения о попытках выполения (успешн и нет)
drop procedure jobprocedure
create or replace procedure jobprocedure is
cursor teachercursor is select teacher,teacher_name,pulpit, BIRTHDAY, salary from teacher where salary > 32;
begin
for n in teachercursor
loop
insert into teacher_backup (teacher, teacher_name, pulpit, BIRTHDAY, salary)
values (n.teacher, n.teacher_name, n.pulpit, n.BIRTHDAY, n.salary);
end loop;
delete from teacher where salary > 32;
insert into job_status (status) values ('SUCCESS');
commit;
exception when others then insert into job_status (status) values (sqlcode);
end;

begin
jobprocedure();
end;

  select * from teacher_backup;
select * from teacher;
select * from job_status;
delete job_status


--создать задание (задание выполняется в опред.время (через неделю))
declare v_job number;
begin
SYS.dbms_job.submit(
job => v_job,
what => 'BEGIN jobprocedure(); END;',
next_date => trunc(sysdate+7) + 3 / 24,
interval => 'trunc(sysdate + 7) + 60/86400');
commit;
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

--выполняется ли сейчас
select * from dba_jobs_running;

--запустить немедленно
begin
dbms_job.run(106);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;


— next date & interval
begin
dbms_job.next_date(106,sysdate);
dbms_job.interval(106,'SYSDATE + 5/(24*60)');
end;
commit;

— broken
begin
dbms_job.broken(106, broken => true);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

--удалить задание из очереди
begin
dbms_job.remove(107);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;



--создать задание с номером
begin
dbms_job.isubmit(1, 'BEGIN jobprocedure(); END;', sysdate, 'sysdate + 60/86400');
commit;
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;



--=========================================================================================


--выполняется копирование из 1 табл в другую
--раз в неделю в определенное время
create or replace procedure jobprocedure2 is
cursor teachercursor2 is select * from teacher where salary < 450;
begin
for n in teachercursor2
loop
insert into teacher_backup2 (teacher, teacher_name, pulpit, salary)
values (n.teacher, n.teacher_name, n.pulpit, n.salary);
end loop;
delete from teacher where salary < 450;
insert into job_status (status) values ('SUCCESS 2');
commit;
exception when others then insert into job_status (status) values ('FAIL');
end;

begin
jobprocedure2();
end;

select * from teacher_backup2;
select * from teacher;
select * from job_status;
--delete job_status;

begin
dbms_scheduler.create_schedule(
schedule_name => 'Sch_2',
start_date => sysdate,
repeat_interval => 'FREQ=WEEKLY; BYDAY=MON; BYHOUR=15; BYMINUTE=30;',
comments => 'Sch_2 WEEKLY on Mondays at 3:30 PM'
);
end;
select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
program_name => 'Pr_2',
program_type => 'STORED_PROCEDURE',
program_action => 'jobprocedure2',
number_of_arguments => 0,
enabled => true,
comments => 'Sch_2 DAILY'
);
end;
select * from user_scheduler_programs;

begin
SYS.dbms_scheduler.create_job(
job_name => 'jsh_2',
program_name => 'Pr_2',
schedule_name => 'Sch_2',
enabled => true);
end;
select job_name, job_type, job_action, start_date, repeat_interval, next_run_date, enabled from user_scheduler_jobs;

--select * from dba_jobs_running;
--select * from dba_scheduler_job_run_details where JOB_NAME='jsh_2';

BEGIN
DBMS_SCHEDULER.RUN_JOB('JSH_2');
END;


BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE(
name => 'Sch_2',
attribute => 'start_date',
value => sysdate
);
DBMS_SCHEDULER.SET_ATTRIBUTE(
name => 'Sch_2',
attribute => 'repeat_interval',
value => 'FREQ=HOURLY;'
);
END;

BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE(
name => 'jsh_2',
attribute => 'enabled',
value => false
);
END;


--удаление
begin
dbms_scheduler.drop_job('jsh_2');
DBMS_SCHEDULER.DROP_SCHEDULE('Sch_2');
DBMS_SCHEDULER.DROP_PROGRAM('Pr_2');
end;
