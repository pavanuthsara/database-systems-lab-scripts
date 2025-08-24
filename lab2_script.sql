--1.a
--need to create dept_t as incomplete type to create emp_t
CREATE TYPE dept_t
/

CREATE TYPE emp_t AS OBJECT(
    empno CHAR(6),
    firstname VARCHAR(12),
    lastname VARCHAR(15),
    workdept REF dept_t,
    sex char(1),
    birthdate DATE,
    salary NUMBER(8,2)
)
/

CREATE TYPE dept_t AS OBJECT(
    deptno CHAR(3),
    deptname VARCHAR(36),
    mgrno REF emp_t,
    admrdept REF dept_t
)
/

ALTER TYPE dept_t DROP ATTRIBUTE admrdept CASCADE
/

ALTER TYPE dept_t ADD ATTRIBUTE (admrdept REF dept_t) CASCADE
/


CREATE TABLE oremp OF emp_t(
    empno PRIMARY KEY,
    firstname NOT NULL,
    lastname NOT NULL
)
/



CREATE TABLE ordept OF dept_t(
    deptno PRIMARY KEY,
    deptname NOT NULL
)
/

SELECT * FROM ordept
/
SELECT * FROM oremp
/

INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000010', 'CHRISTINE', 'HAAS', 'F', TO_DATE('1953-08-14', 'YYYY-MM-DD'), 72750)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000020', 'MICHAEL', 'THOMPSON', 'M', TO_DATE('1968-02-02', 'YYYY-MM-DD'), 61250)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000030', 'SALLY', 'KWAN', 'F', TO_DATE('11/MAY/71', 'DD/MON/RR'), 58250)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000060', 'IRVING', 'STERN', 'M', TO_DATE('07/JUL/65', 'DD/MON/RR'), 55555)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000070', 'EVA', 'PULASKI', 'F', TO_DATE('26/MAY/73 ', 'DD/MON/RR'), 56170)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000050', 'JOHN', 'GEYER', 'M', TO_DATE('15/SEP/55', 'DD/MON/RR'), 60175)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000090', 'EILEEN', 'HENDERSON', 'F', TO_DATE('15/MAY/61', 'DD/MON/RR'), 49750)
/
INSERT INTO oremp(empno, firstname, lastname, sex, birthdate,salary) 
VALUES ('000100', 'THEODORE', 'SPENSER', 'M', TO_DATE('18/DEC/76', 'DD/MON/RR'), 46150)
/

INSERT INTO ordept(deptno, deptname, mgrno) 
VALUES ('A00', 'SPIFFY COMPUTER SERVICE DIV.', (SELECT REF(m) FROM oremp m WHERE m.empno='000010'))
/
INSERT INTO ordept(deptno, deptname, mgrno) 
VALUES ('B01', 'PLANNING', (SELECT REF(m) FROM oremp m WHERE m.empno='000020'))
/
INSERT INTO ordept(deptno, deptname, mgrno) 
VALUES ('C01', 'INFORMATION CENTRE', (SELECT REF(m) FROM oremp m WHERE m.empno='000030'))
/
INSERT INTO ordept(deptno, deptname, mgrno) 
VALUES ('D01', 'DEVELOPMENT CENTRE', (SELECT REF(m) FROM oremp m WHERE m.empno='000060'))
/

SELECT * FROM ordept
/
SELECT * FROM oremp
/


UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='A00')
WHERE empno='000010'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='B01')
WHERE empno='000020'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='C01')
WHERE empno='000030'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='D01')
WHERE empno='000060'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='D01')
WHERE empno='000070'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='C01')
WHERE empno='000050'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='B01')
WHERE empno='000090'
/
UPDATE oremp
SET workdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='B01')
WHERE empno='000100'
/

UPDATE ordept
SET admrdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='A00')
WHERE deptno='A00'
/
UPDATE ordept
SET admrdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='A00')
WHERE deptno='B01'
/
UPDATE ordept
SET admrdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='A00')
WHERE deptno='C01'
/
UPDATE ordept
SET admrdept=(SELECT REF(d) FROM ordept d WHERE d.deptno='C01')
WHERE deptno='D01'
/

DESC ordept
/


--Question 2
--a
SELECT d.deptname, d.mgrno.lastname
FROM ordept d
/

--b
SELECT e.empno, e.lastname, e.workdept.deptname
FROM oremp e
/

--c
SELECT d.deptno, d.deptname, d.admrdept.deptname as Administrative_Department
FROM ordept d
/

--d
SELECT d.deptno, d.deptname, d.admrdept.deptname as Administrative_Department, d.mgrno.lastname AS Manager_lastname
FROM ordept d
/

--e
SELECT e.empno, e.firstname, e.lastname, e.salary, e.workdept.mgrno.lastname AS Manager_lastname, e.workdept.mgrno.salary AS Manager_salary
FROM oremp e
/

--f
SELECT e.workdept.deptno as Dept_NO, e.workdept.deptname as Dept_Name, e.sex, sum(e.salary)/count(e.salary) AS Average_Salary
FROM oremp e
GROUP BY e.workdept.deptno, e.workdept.deptname, e.sex
ORDER BY e.workdept.deptno ASC
/




