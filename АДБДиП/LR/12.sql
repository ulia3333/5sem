-- 1. Добавьте в таблицу TEACHERS два столбца BIRTHDAY и SALARY, заполните их значениями.
ALTER TABLE TEACHER ADD (BIRTHDAY DATE, SALARY NUMBER(3));
ALTER TABLE TEACHER DROP COLUMN BIRTHDAY;
ALTER TABLE TEACHER DROP COLUMN SALARY;
SELECT * FROM TEACHER;
UPDATE TEACHER SET BIRTHDAY='01.04.1970', SALARY= 50 WHERE TEACHER='СМЛВ';
UPDATE TEACHER SET BIRTHDAY='02.05.1990', SALARY= 40 WHERE TEACHER='АКНВЧ               ';
UPDATE TEACHER SET BIRTHDAY='05.06.1990', SALARY= 12 WHERE TEACHER='КЛСНВ               ';
UPDATE TEACHER SET BIRTHDAY='04.07.1990', SALARY= 52 WHERE TEACHER='ГРМН                ';
UPDATE TEACHER SET BIRTHDAY='07.08.1990', SALARY= 32 WHERE TEACHER='ЛЩНК                ';
UPDATE TEACHER SET BIRTHDAY='20.09.1978', SALARY= 44 WHERE TEACHER='БРКВЧ               ';
UPDATE TEACHER SET BIRTHDAY='23.10.1990', SALARY= 26 WHERE TEACHER='ДДК                 ';
UPDATE TEACHER SET BIRTHDAY='13.11.1960', SALARY= 9 WHERE TEACHER='КБЛ                 ';
UPDATE TEACHER SET BIRTHDAY='26.12.1986', SALARY= 20 WHERE TEACHER='УРБ                 ';
UPDATE TEACHER SET BIRTHDAY='16.04.1990', SALARY= 40 WHERE TEACHER='РМНК                ';
UPDATE TEACHER SET BIRTHDAY='01.01.1990', SALARY= 33 WHERE TEACHER='ПСТВЛВ              ';
UPDATE TEACHER SET BIRTHDAY='01.03.1964', SALARY= 23 WHERE TEACHER='ГРН                 ';
UPDATE TEACHER SET BIRTHDAY='01.03.1980', SALARY= 42 WHERE TEACHER='ЖЛК                 ';
UPDATE TEACHER SET BIRTHDAY='07.02.1990', SALARY= 15 WHERE TEACHER='БРТШВЧ              ';
UPDATE TEACHER SET BIRTHDAY='20.01.1990', SALARY= 33 WHERE TEACHER='ЮДНКВ               ';
UPDATE TEACHER SET BIRTHDAY='01.04.1970', SALARY= 50 WHERE TEACHER='БРНВСК    ';
UPDATE TEACHER SET BIRTHDAY='02.05.1990', SALARY= 40 WHERE TEACHER='НВРВ      ';
UPDATE TEACHER SET BIRTHDAY='05.06.1990', SALARY= 12 WHERE TEACHER='ЖРСК      ';
UPDATE TEACHER SET BIRTHDAY='04.07.1990', SALARY= 52 WHERE TEACHER='ЕЩНК      ';
UPDATE TEACHER SET BIRTHDAY='07.08.1990', SALARY= 32 WHERE TEACHER='МХВ       ';
UPDATE TEACHER SET BIRTHDAY='20.09.1978', SALARY= 44 WHERE TEACHER='НСКВЦ     ';
UPDATE TEACHER SET BIRTHDAY='23.10.1990', SALARY= 26 WHERE TEACHER='ПРКПЧК    ';
UPDATE TEACHER SET BIRTHDAY='13.11.1960', SALARY= 9 WHERE TEACHER='БЗБРДВ    ';
UPDATE TEACHER SET BIRTHDAY='26.12.1986', SALARY= 20 WHERE TEACHER='ЗВГЦВ     ';
UPDATE TEACHER SET BIRTHDAY='16.04.1990', SALARY= 40 WHERE TEACHER='ЛБХ       ';
UPDATE TEACHER SET BIRTHDAY='01.01.1990', SALARY= 33 WHERE TEACHER='МШКВСК    ';
UPDATE TEACHER SET BIRTHDAY='01.03.1964', SALARY= 23 WHERE TEACHER='ДМДК      ';
UPDATE TEACHER SET BIRTHDAY='01.03.1980', SALARY= 42 WHERE TEACHER='БРНВСК    ';
UPDATE TEACHER SET BIRTHDAY='07.02.1990', SALARY= 15 WHERE TEACHER='НВРВ      ';
UPDATE TEACHER SET BIRTHDAY='20.01.1990', SALARY= 33 WHERE TEACHER='РВКЧ      ';
--*********
-- 2. Получите список преподавателей в виде Фамилия И.О.
select teacher_name from TEACHER;
      select regexp_substr(teacher_name,'(\S+)',1, 1)||' '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 2),1, 1)||'. '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 3),1, 1)||'. '
    from teacher;

-- 3. Получите список преподавателей, родившихся в понедельник.
select * from teacher
where TO_CHAR((birthday), 'd') = 1;

-- 4. Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.
create view TeacherBirtdayInNextMons as
select * from teacher
where TO_CHAR(sysdate,'mm') + 1 = TO_CHAR(birthday, 'mm'); 

select * from TeacherBirtdayInNextMons; 
-- 5. Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.
 create view NumberMonths as
     select to_char(birthday, 'Month') Month,
            count(*) count
            from teacher
            group by to_char(birthday, 'Month')
            having count(*)>=1;
select * from numbermonths;
--**********
-- 6. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.
cursor TeacherBirtday(teacher%rowtype) 
        return teacher%rowtype is
        select * from teacher
        where MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(birthday, 'yyyy') + 1), 5) = 0; 
--***********
-- 7. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых, 
cursor tAvgSalary(teacher.salary%type,teacher.pulpit%type) 
return teacher.salary%type,teacher.pulpit%type  is
 select floor(avg(salary)) Avg_Salary, pulpit
 from teacher
 group by pulpit;

--вывести средние итоговые значения для каждого факультета
cursor tAvgSalary(teacher.salary%type,pulpit.faculty%type) 
return teacher.salary%type,pulpit.faculty%type  is
select round(AVG(T.salary),3),P.faculty
    from teacher T
    inner join pulpit P
    on T.pulpit = P.pulpit
    group by P.faculty;
--для всех факультетов в целом.
cursor tAvgSalary(teacher.salary%type) 
return teacher.salary%type  is
select round(avg(salary),3) Avg_Salary from teacher;
 

-- 8. Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним. 
--Продемонстрируйте работу с вложенными записями. Продемонстрируйте и объясните операцию присвоения. 
declare
 type ADDRESS is record (town nvarchar2(20), country nvarchar2(20));
   type PERSON is record (name teacher.teacher_name%type, pulp teacher.pulpit%type, homeAddress ADDRESS);
    per1 PERSON;
    per2 PERSON;
  begin
   select teacher_name, pulpit into per1.name, per1.PULP
   from teacher
    where teacher='СМЛВ';
     per1.homeAddress.town := 'Минск';
     per1.homeAddress.country := 'Беларусь';
     per2 := per1;
     dbms_output.put_line( per2.name||' '|| per2.pulp||' из города '|| per2.homeAddress.town||', '|| per2.homeAddress.country);
  end;

