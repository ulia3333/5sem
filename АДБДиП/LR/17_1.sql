GRANT CREATE JOB TO C##U_GUS_PDB;
GRANT CREATE EXTERNAL JOB TO C##U_GUS_PDB;
GRANT MANAGE SCHEDULER TO C##U_GUS_PDB;
GRANT EXECUTE ON DBMS_SCHEDULER TO C##U_GUS_PDB;

DROP TABLE initial_table;
DROP TABLE backup_table;
--1.	Разработайте пакет выполнения заданий, в котором:
--2.	Раз в неделю в определенное время выполняется копирование части данных по условию из одной таблицы в другую, после чего эти данные из первой таблицы удаляются. 
--3.	Необходимо проверять, было ли выполнено задание, и в какой-либо таблице сохранять сведения о попытках выполнения, как успешных, так и неуспешных.
--4.	Необходимо проверять, выполняется ли сейчас это задание.
--5.	Необходимо дать возможность выполнять задание в другое время, приостановить или отменить вообще.
create table initial_table( 
name nvarchar2(50), 
salary number
);

create table backup_table( 
name nvarchar2(50), 
salary number
);


insert into initial_table (name,salary) values ('Ulia',1000);
insert into initial_table (name,salary) values ('Marina',900);
insert into initial_table (name,salary) values ('Dasha',1010);
insert into initial_table (name,salary) values ('Alina',700);
insert into initial_table (name,salary) values ('Ksusha',600);
insert into initial_table (name,salary) values ('Sasha',800);
insert into initial_table (name,salary) values ('Maha',650);
insert into initial_table (name,salary) values ('Glaha',500);
commit;


drop  procedure archive;
create or replace procedure archive is
  begin
    insert into backup_table select * from initial_table;
    delete from initial_table;
end archive;

begin
  archive();
end;

select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;


select * from backup_table;
select * from initial_table;

drop table job_status;
create table job_status (
status nvarchar2(50),
datetime timestamp default current_timestamp
);

------------------------
drop  procedure archive;
create or replace procedure archive is
  begin
    insert into backup_table select * from initial_table where SALARY >1300;
    delete from initial_table where SALARY >1300;
insert into job_status (status) values ('SUCCESS');
commit;
exception when others then insert into job_status (status) values ('FAIL');
end;

begin
archive();
end;

select * from backup_table;
select * from initial_table
select * from job_status;
delete job_status


--создать задание (задание выполняется в опред.время (через неделю))
declare v_job number;
begin
SYS.dbms_job.submit(
job => v_job,
what => 'BEGIN archive(); END;',
next_date => trunc(sysdate+7) + 3 / 24,
interval => 'trunc(sysdate + 7) + 60/86400');
commit;
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;


--запустить немедленно
begin
dbms_job.run(66);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;


-- next date & interval
begin
dbms_job.next_date(66,sysdate);
dbms_job.interval(66,'SYSDATE + 5/(24*60)');
end;
commit;

-- broken
begin
dbms_job.broken(65, broken => true);
end;
begin
dbms_job.broken(65, broken => false);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

--удалить задание из очереди
begin
dbms_job.remove(65);
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;



--создать задание с номером
begin
dbms_job.isubmit(1, 'BEGIN archive(); END;', sysdate, 'sysdate + 60/86400');
commit;
end;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;



--=========================================================================================


--выполняется копирование из 1 табл в другую
--раз в неделю в определенное время
drop  procedure archive2;
create or replace procedure archive2 is
  begin
    insert into backup_table select * from initial_table;
    delete from initial_table;
insert into job_status (status) values ('SUCCESS');
commit;
exception when others then insert into job_status (status) values ('FAIL');
end;
begin
archive2();
end;

select * from initial_table;
select * from backup_table;
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
program_action => 'archive',
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

---
begin
dbms_scheduler.stop_job('jsh_2');
end;
begin
dbms_scheduler.stop_job('jsh_2');
end;


--удаление
begin
dbms_scheduler.drop_job('jsh_2');
DBMS_SCHEDULER.DROP_SCHEDULE('Sch_2');
DBMS_SCHEDULER.DROP_PROGRAM('Pr_2');
end;

