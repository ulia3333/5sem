-- 1. �������� � ������� TEACHERS ��� ������� BIRTHDAY � SALARY, ��������� �� ����������.
ALTER TABLE TEACHER ADD (BIRTHDAY DATE, SALARY NUMBER(3));
ALTER TABLE TEACHER DROP COLUMN BIRTHDAY;
ALTER TABLE TEACHER DROP COLUMN SALARY;
SELECT * FROM TEACHER;
UPDATE TEACHER SET BIRTHDAY='01.04.1970', SALARY= 50 WHERE TEACHER='����';
UPDATE TEACHER SET BIRTHDAY='02.05.1990', SALARY= 40 WHERE TEACHER='�����               ';
UPDATE TEACHER SET BIRTHDAY='05.06.1990', SALARY= 12 WHERE TEACHER='�����               ';
UPDATE TEACHER SET BIRTHDAY='04.07.1990', SALARY= 52 WHERE TEACHER='����                ';
UPDATE TEACHER SET BIRTHDAY='07.08.1990', SALARY= 32 WHERE TEACHER='����                ';
UPDATE TEACHER SET BIRTHDAY='20.09.1978', SALARY= 44 WHERE TEACHER='�����               ';
UPDATE TEACHER SET BIRTHDAY='23.10.1990', SALARY= 26 WHERE TEACHER='���                 ';
UPDATE TEACHER SET BIRTHDAY='13.11.1960', SALARY= 9 WHERE TEACHER='���                 ';
UPDATE TEACHER SET BIRTHDAY='26.12.1986', SALARY= 20 WHERE TEACHER='���                 ';
UPDATE TEACHER SET BIRTHDAY='16.04.1990', SALARY= 40 WHERE TEACHER='����                ';
UPDATE TEACHER SET BIRTHDAY='01.01.1990', SALARY= 33 WHERE TEACHER='������              ';
UPDATE TEACHER SET BIRTHDAY='01.03.1964', SALARY= 23 WHERE TEACHER='���                 ';
UPDATE TEACHER SET BIRTHDAY='01.03.1980', SALARY= 42 WHERE TEACHER='���                 ';
UPDATE TEACHER SET BIRTHDAY='07.02.1990', SALARY= 15 WHERE TEACHER='������              ';
UPDATE TEACHER SET BIRTHDAY='20.01.1990', SALARY= 33 WHERE TEACHER='�����               ';
UPDATE TEACHER SET BIRTHDAY='01.04.1970', SALARY= 50 WHERE TEACHER='������    ';
UPDATE TEACHER SET BIRTHDAY='02.05.1990', SALARY= 40 WHERE TEACHER='����      ';
UPDATE TEACHER SET BIRTHDAY='05.06.1990', SALARY= 12 WHERE TEACHER='����      ';
UPDATE TEACHER SET BIRTHDAY='04.07.1990', SALARY= 52 WHERE TEACHER='����      ';
UPDATE TEACHER SET BIRTHDAY='07.08.1990', SALARY= 32 WHERE TEACHER='���       ';
UPDATE TEACHER SET BIRTHDAY='20.09.1978', SALARY= 44 WHERE TEACHER='�����     ';
UPDATE TEACHER SET BIRTHDAY='23.10.1990', SALARY= 26 WHERE TEACHER='������    ';
UPDATE TEACHER SET BIRTHDAY='13.11.1960', SALARY= 9 WHERE TEACHER='������    ';
UPDATE TEACHER SET BIRTHDAY='26.12.1986', SALARY= 20 WHERE TEACHER='�����     ';
UPDATE TEACHER SET BIRTHDAY='16.04.1990', SALARY= 40 WHERE TEACHER='���       ';
UPDATE TEACHER SET BIRTHDAY='01.01.1990', SALARY= 33 WHERE TEACHER='������    ';
UPDATE TEACHER SET BIRTHDAY='01.03.1964', SALARY= 23 WHERE TEACHER='����      ';
UPDATE TEACHER SET BIRTHDAY='01.03.1980', SALARY= 42 WHERE TEACHER='������    ';
UPDATE TEACHER SET BIRTHDAY='07.02.1990', SALARY= 15 WHERE TEACHER='����      ';
UPDATE TEACHER SET BIRTHDAY='20.01.1990', SALARY= 33 WHERE TEACHER='����      ';
--*********
-- 2. �������� ������ �������������� � ���� ������� �.�.
select teacher_name from TEACHER;
      select regexp_substr(teacher_name,'(\S+)',1, 1)||' '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 2),1, 1)||'. '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 3),1, 1)||'. '
    from teacher;

-- 3. �������� ������ ��������������, ���������� � �����������.
select * from teacher
where TO_CHAR((birthday), 'd') = 1;

-- 4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.
create view TeacherBirtdayInNextMons as
select * from teacher
where TO_CHAR(sysdate,'mm') + 1 = TO_CHAR(birthday, 'mm'); 

select * from TeacherBirtdayInNextMons; 
-- 5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.
 create view NumberMonths as
     select to_char(birthday, 'Month') Month,
            count(*) count
            from teacher
            group by to_char(birthday, 'Month')
            having count(*)>=1;
select * from numbermonths;
--**********
-- 6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
cursor TeacherBirtday(teacher%rowtype) 
        return teacher%rowtype is
        select * from teacher
        where MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(birthday, 'yyyy') + 1), 5) = 0; 
--***********
-- 7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, 
cursor tAvgSalary(teacher.salary%type,teacher.pulpit%type) 
return teacher.salary%type,teacher.pulpit%type  is
 select floor(avg(salary)) Avg_Salary, pulpit
 from teacher
 group by pulpit;

--������� ������� �������� �������� ��� ������� ����������
cursor tAvgSalary(teacher.salary%type,pulpit.faculty%type) 
return teacher.salary%type,pulpit.faculty%type  is
select round(AVG(T.salary),3),P.faculty
    from teacher T
    inner join pulpit P
    on T.pulpit = P.pulpit
    group by P.faculty;
--��� ���� ����������� � �����.
cursor tAvgSalary(teacher.salary%type) 
return teacher.salary%type  is
select round(avg(salary),3) Avg_Salary from teacher;
 

-- 8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. 
--����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������. 
declare
 type ADDRESS is record (town nvarchar2(20), country nvarchar2(20));
   type PERSON is record (name teacher.teacher_name%type, pulp teacher.pulpit%type, homeAddress ADDRESS);
    per1 PERSON;
    per2 PERSON;
  begin
   select teacher_name, pulpit into per1.name, per1.PULP
   from teacher
    where teacher='����';
     per1.homeAddress.town := '�����';
     per1.homeAddress.country := '��������';
     per2 := per1;
     dbms_output.put_line( per2.name||' '|| per2.pulp||' �� ������ '|| per2.homeAddress.town||', '|| per2.homeAddress.country);
  end;

