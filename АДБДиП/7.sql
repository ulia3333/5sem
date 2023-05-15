--1.	Получите полный список фоновых процессов. 
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

--2.	Определите фоновые процессы, которые запущены и работают в настоящий момент.
SELECT * FROM v$process ; 

--3.	Определите, сколько процессов DBWn работает в настоящий момент.
show parameter db_writer_processes;

--4.	Получите перечень текущих соединений с экземпляром.
SELECT * FROM V$INSTANCE;

--5.	Определите режимы этих соединений.
select name, log_mode from v$database;
select  INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

--6.	Определите сервисы (точки подключения экземпляра).
select NAME,NETWORK_NAME,PDB from V$SERVICES ;  

--7.	Получите известные вам параметры диспетчера и их значений.
SELECT * FROM V$DISPATCHER;
show parameter DISPATCHERS;

--8.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
--OracleOraDB12Home1TNSListener

--9.	Получите перечень текущих соединений с инстансом. (dedicated, shared). 
SELECT USERNAME,SERVER FROM V$SESSION;

--10.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
--D:\app\ora_natasha\product\12.1.0\dbhome_1\NETWORK\ADMIN

--11-12.	Запустите утилиту lsnrctl и поясните ее основные команды. 
--Получите список служб инстанса, обслуживаемых процессом LISTENER. 


