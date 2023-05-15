CREATE public DATABASE LINK SEI_SMS
    CONNECT TO C##AlinaChagan
        IDENTIFIED BY '123'
    USING 'WIN-248JMBUG03J:1521/orcl.be.by';

select * from T_ALINA@PDB_CHAL;

SELECT *
from STUDENTS@SEI_PDB;

insert into STUDENTS@SEI_PDB (NAME, AVG)
values ('MAK', 6);
COMMIT;

update STUDENTS@SEI_PDB
set AVG = 5
where NAME = 'MARK';

delete
from LAB14_TEST_TABLE@TVS_PDB
where ID = 1;

begin
    DBMS_OUTPUT.PUT_LINE(SYS.TEACHERS_PACKAGE.TEACHERS_COUNT@TVS_PDB('????'));
end;

create or replace package TEST_PACKAGE as
    function test_proc return number;
end TEST_PACKAGE;

create or replace package body TEST_PACKAGE as
    function test_proc return number as
    begin
        return 2;
    end;
end TEST_PACKAGE;

create table LINK_TEST_TABLE
(
    ID   NUMBER,
    NAME VARCHAR2(50)
);


select * from LINK_TEST_TABLE;



CREATE DATABASE LINK TVS_PDB_Local
    CONNECT TO U1_TVS_PDB
        IDENTIFIED BY qwerty
    USING 'desktop-ksa6bbp:1521/TVS_PDB';

begin
    DBMS_OUTPUT.PUT_LINE(SYS.TEACHERS_PACKAGE.TEACHERS_COUNT@TVS_PDB_Local('????'));
end;
