-- creating relational tables (EMP, DEPT)

-- Creating the dept table

create table dept(
deptno char(3),
deptname varchar(36) not null,
mgrno char(6),
admrdept char(3),
constraint pk_dept primary key (deptno),
constraint fk_dept_admrdept_deptno foreign key (admrdept) references dept(deptno));

-- Creating the employee table

create table emp(
empno char(6),
firstname varchar(12) not null,
midinit char(1) not null,
lastname varchar(15) not null,
workdept char(3),
phoneno char(9),
hiredate date,
job char (15),
edlevel number(2),
sex char(1),
birthdate date,
salary number(8,2),
bonus number(8,2),
comm number(8,2),
constraint pk_emp primary key (empno),
constraint fk_emp_dept foreign key (workdept) references dept(deptno));

alter table dept add( 
constraint fk_dept_emp foreign key (mgrno) references emp(empno));


-- Inserting data to dept table

insert into dept values('1','Admin','','');
insert into dept values('2','Academic','','1');
insert into dept values('3','CSD','','1');
commit;

-- Inserting data to emp table


insert into emp values('111','Shiran','M', 'Wikramasinghe','3', '74747474', '01-Jan-2000','Manager','8','F','12-Jan-1970','30000','5000','15000');

insert into emp values('100','Saman','K', 'Kumara','2', '67699099', '01-Jan-2000','Instructor','4','M','12-Jan-1970','10000','1000','5000');

insert into emp values('101','Rukshan','A', 'Weerakoon','3', '88778099', '02-feb-2001','Engineer','5','M','02-Jan-1960','25000','2000','10000');

insert into emp values('102','Anusha','P','Sandamalie','2', '33778011', '04-jun-2000','Lecturer','4','F','05-mar-1960','15000','1500','7000');

insert into emp values('103','Suresh','R','Wikramasuriya','1', '77998011', '01-jan-2000','Acountant','3','M','06-mar-1975','9000','1000','4000');

insert into emp values('104','Inoka','E','Edirithilaka','3','71123123','4-apr-2002','Programmer','3','F','5-jan-1976','15000','2000','3000');

insert into emp values('105','Kamal','A','Prasanna','2','3345645','7-sep-2001','Lecturer','3','M','1-feb-1975','15000','1500','7000');

insert into emp values('106','Harsha','U','Fernando','1','4134534','05-MAY-2000','Manager','5','F','5-May-1975','15000','2000','3000');

insert into emp values('107','Ganga','S','Peshala','2','1467467','4-Apr-2000','Instructor','3','F','3-Mar-1977','10000','1000','5000');

insert into emp values('108','Tharaka','H','Ranasighe','2','77300300','1-Apr-2002','Lecturer','2','M','3-Jun-1975','15000','1500','7000');

insert into emp values('109','Amani','T','Sakunthala','2','77890890','4-Feb-2001','Instructor','1','F','2-Feb-1978','10000','1000','3000');

insert into emp values('110','MAhesha','S','Kapurubandara','2','77111111','01-AUG-2000','Manager','7','F','20-JAN-1958','30000','5000','15000');

commit;