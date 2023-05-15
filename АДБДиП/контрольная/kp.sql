-- 1
select instance_name from v$instance;

-- 2
select * from dba_data_files;

-- 3
select * from dba_users where username like 'C##%';

-- 6
show PARAMETERS instance;

-- 7
select * from v$log;

-- 9
select * from v$sga;

-- 10
select * from v_$sga_dynamic_components;

-- 11
select * from v$session where type != 'BACKGROUND';


















