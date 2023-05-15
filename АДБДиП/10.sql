set serveroutput on  for SQLPlus
alter session set NLS_LANGUAGE='RUSSIAN';
--1.	Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов. 
BEGIN
 null;
END;
--2.	Разработайте АБ, выводящий «Hello World!». 
--Выполните его в SQLDev и SQL+.
--connect C##U_GUS_PDB/12345@gus_pdb;
SET SERVEROUTPUT ON;
BEGIN
 dbms_output.put_line('Hello World!');
END;
--3.	Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
declare
    x number(3) := 3;
    y number(3) := 0;
    z number (10,2);
 begin
     z:=x/y;
     exception when others
     then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--4.	Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
declare
    x number(3) := 3;
    y number(3) := 0;
    z number (10,2);
 begin
 dbms_output.put_line('x='||x||', y='||y);
  begin
     z:=x/y;
     exception when others
     then dbms_output.put_line(sqlcode||': error = '||sqlerrm);
  end;
  z:=x/y;
  dbms_output.put_line('z='||z);
end;
--5.	Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
SELECT name, value FROM v$parameter WHERE name = 'plsql_warnings';
SHOW PARAMETERS plsql_warnings;
--6.	Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword from v$reserved_words
        where length = 1 and keyword != 'A';
--7.	Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.
select keyword from v$reserved_words
        where length > 1 and keyword!='A' order by keyword;
--8.	Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. Просмотрите эти же параметры с помощью SQL+-команды show.
select name,value from v$parameter where name like 'plsql%';
show parameter plsql;
--9.	Разработайте анонимный блок, демонстрирующий 
--(выводящий в выходной серверный поток результаты): 
declare
  t10 number(3):= 50;
  t11 number(3):=15;
  suma number(10,2);
  dwo number(10,2);
  t12 number(10,2):= 2.11;
  t13 number(10, -3):= 222999.45;
  t14 binary_float:= 1234.1234;
  t15 binary_double:= 1234.1234;
  t16 number(38,10):=1E+10;
  t17 boolean:= true;
 begin
    dbms_output.put_line('t10 = '||t10);
    dbms_output.put_line('t11 = '||t11);
    dwo:=mod(t10,t11);
    dbms_output.put_line('ostatok = '||dwo);
    suma:=t10+t11;
    dbms_output.put_line('suma = '||suma);
    dbms_output.put_line('fix = '||t12);
    dbms_output.put_line('okr = '||t13);
    dbms_output.put_line('binaryfloat = '||t14);
    dbms_output.put_line('binarydobuble = '||t15);
    dbms_output.put_line('E+10 = '||t16); 
    if t17 then dbms_output.put_line('bool = '||'true'); end if;
end;
--18.	Разработайте анонимный блок PL/SQL содержащий объявление констант 
--(VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции c константами.  
DECLARE
nyear CONSTANT NUMBER := TO_CHAR (SYSDATE, 'YYYY');
vc CONSTANT VARCHAR2(10) := 'Varchar2';
c CHAR(5) := 'Char';
BEGIN
c := 'Nchar';
DBMS_OUTPUT.PUT_LINE(nyear); 
DBMS_OUTPUT.PUT_LINE('vc='||vc||'   length='||length(vc)); 
DBMS_OUTPUT.PUT_LINE(c); 
EXCEPTION
  WHEN OTHERS
  THEN DBMS_OUTPUT.PUT_LINE('error = ' || sqlerrm);
END;
--19.	Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
DECLARE
pulp pulpit.pulpit%TYPE;
BEGIN 
pulp := 'ИСиТ';
DBMS_OUTPUT.PUT_LINE(pulp);
END;
--20.	Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
DECLARE
faculty_res faculty%ROWTYPE;
BEGIN 
faculty_res.faculty := 'ФИТ';
faculty_res.faculty_name := 'Факультет информационных технологий';
DBMS_OUTPUT.PUT_LINE(faculty_res.faculty||'--    '||faculty_res.faculty_name);
END;
--21.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
DECLARE 
x PLS_INTEGER := 10;
BEGIN
IF 8 > x THEN
DBMS_OUTPUT.PUT_LINE('8 > '|| x);
ELSIF 8 < x THEN
DBMS_OUTPUT.PUT_LINE('8 < '|| x);
ELSE
DBMS_OUTPUT.PUT_LINE('8 = '|| x);
END IF;
END;
--23.	Разработайте АБ, демонстрирующий работу оператора CASE.
DECLARE 
x PLS_INTEGER := 15;
BEGIN
CASE
WHEN x BETWEEN 10 AND 30 THEN
DBMS_OUTPUT.PUT_LINE('BETWEEN 10 AND 30');
WHEN x > 30 THEN
DBMS_OUTPUT.PUT_LINE(x||'>30');
ELSE
DBMS_OUTPUT.PUT_LINE('ELSE');
END CASE;
END;
--24.	Разработайте АБ, демонстрирующий работу оператора LOOP.
--25.	Разработайте АБ, демонстрирующий работу оператора WHILE.
--26.	Разработайте АБ, демонстрирующий работу оператора FOR.

DECLARE 
x PLS_INTEGER := 0;
BEGIN

LOOP
x := x + 1;
DBMS_OUTPUT.PUT_LINE(x);
EXIT WHEN x >= 5;
END LOOP;

FOR k IN 1..5
LOOP
DBMS_OUTPUT.PUT_LINE(k);
END LOOP;

WHILE (x > 0)
LOOP
x := x - 1;
DBMS_OUTPUT.PUT_LINE(x);
END LOOP;
END;