create table xxx_t( x number(3), s varchar2(50));

insert into xxx_t values ('1','one');
insert into xxx_t values ('2','two');
insert into xxx_t values ('3','three');
commit;


update xxx_t
  set s = 'two_2'
where s='two';

update xxx_t
  set x = '4',s='four'
where x='3';
commit;



select avg(xxx_t.x) from xxx_t;
select s,x from xxx_t where x=2;

delete from xxx_t where x=4;
commit;

alter table xxx_t
add constraint pk_x primary key (x);

create table xxx_t1 (x number(3),
constraint fk_x foreign key(x) references xxx_t(x),
d varchar2(50));
insert into xxx_t1 values(1, 'один');
insert into xxx_t1 values(2, 'два');
insert into xxx_t values(3,'three');
commit;
select s,d from xxx_t inner join xxx_t1
on xxx_t.x=xxx_t1.x;

select s,d from xxx_t left join xxx_t1
on xxx_t.x=xxx_t1.x;

select s,d from xxx_t full join xxx_t1
on xxx_t.x=xxx_t1.x;

drop table xxx_t;
drop table xxx_t1;