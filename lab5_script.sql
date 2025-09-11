-- Task 1
-- a

-- create super type
CREATE TYPE lb5_student_type AS OBJECT(
    sid CHAR(8),
    sname VARCHAR2(15),
    phone CHAR(10)
) NOT FINAL;
/

ALTER TYPE lb5_student_type NOT FINAL;
DESC lb5_student_type;

-- create sub type
CREATE TYPE lb5_ug_type UNDER lb5_student_type(
    gpa REAL,
    deptid CHAR(6),
    course VARCHAR2(10)
)
/
DESC lb5_ug_type;

-- b
CREATE TABLE lb5_students OF lb5_student_type(
    sid PRIMARY KEY
);

INSERT INTO lb5_students VALUES (
    lb5_ug_type('12354326' , 'Janet Paeres' , null, 3.2, 'CS01', 'InfoTech' )
);

INSERT INTO lb5_students VALUES (
    lb5_student_type('12359874', 'Pavan Uthsar', '0714169538')
);

-- c
SELECT VALUE(s) 
FROM lb5_students s;

SELECT s.sid, s.sname
FROM lb5_students s
WHERE VALUE(s) IS OF (ONLY lb5_ug_type) AND 
TREAT(VALUE(s) AS lb5_ug_type).deptid='CS01';

-- a) i) creating types
CREATE TYPE lb5_customer_t AS OBJECT (
    cid CHAR(6),
    name VARCHAR2(15),
    birthdate DATE,
    phone CHAR(10),
    address VARCHAR2(50)
)
/

CREATE TYPE lb5_car_t AS OBJECT (
    regno CHAR(9),
    make VARCHAR2(12),
    model VARCHAR2(10),
    mdate DATE,
    owner REF lb5_customer_t
)
/

CREATE TYPE lb5_claim_t AS OBJECT (
    claimno CHAR(12),
    cdate DATE,
    amount NUMBER(8,2),
    claimant REF lb5_customer_t
)
/

CREATE TYPE lb5_cliam_ntab AS
TABLE OF lb5_claim_t
/

CREATE TYPE lb5_policy_t AS OBJECT (
    pid CHAR(7),
    sdate DATE,
    edate DATE,
    inscar REF lb5_car_t,
    premium NUMBER(6,2),
    claims lb5_cliam_ntab
)
/
DESC lb5_policy_t;

-- creating tables
CREATE TABLE lb5_customers OF lb5_customer_t(
    cid PRIMARY KEY
);

CREATE TABLE lb5_cars OF lb5_car_t(
    regno PRIMARY KEY
);

CREATE TABLE lb5_policies OF lb5_policy_t (
    pid PRIMARY KEY
) NESTED TABLE claims STORE AS claims_ntable;

-- insert data to customers table
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25431', 'Pavan', TO_DATE('2003-08-29', 'YYYY-MM-DD'), '0714169358', 'Weligama, Sri Lanka'));
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25432', 'Kalani', TO_DATE('2001-09-26', 'YYYY-MM-DD'), '0714169357', 'Monaragala, Sri Lanka'));
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25433', 'Oshani', TO_DATE('1999-05-14', 'YYYY-MM-DD'), '0714169385', 'Anuradhapua, Sri Lanka'));
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25434', 'Kasun', TO_DATE('2000-03-22', 'YYYY-MM-DD'), '0771234567', 'Colombo, Sri Lanka'));
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25435', 'Nimali', TO_DATE('1998-11-05', 'YYYY-MM-DD'), '0759876543', 'Kandy, Sri Lanka'));
INSERT INTO lb5_customers VALUES (lb5_customer_t('S25436', 'Ravindu', TO_DATE('2001-08-17', 'YYYY-MM-DD'), '0784567890', 'Galle, Sri Lanka'));


-- insert data to cars table
INSERT INTO lb5_cars VALUES(lb5_car_t('SP-KO3599', 'Hyundai', 'Tucson', TO_DATE('2011-01-13', 'YYYY-MM-DD'), (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25431' )));
INSERT INTO lb5_cars VALUES(lb5_car_t('SP-NZ3021', 'Yutong', 'Coach', TO_DATE('2025-01-13', 'YYYY-MM-DD'), (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25431' )));
INSERT INTO lb5_cars VALUES(lb5_car_t('UPABB4158', 'BENZ', 'E300', TO_DATE('2024-08-13', 'YYYY-MM-DD'), (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25432' )));
INSERT INTO lb5_cars VALUES(lb5_car_t('CPABC3987', 'BMW', '580', TO_DATE('2023-05-03', 'YYYY-MM-DD'), (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25433' )));

-- insert data to policy table
INSERT INTO lb5_policies VALUES(lb5_policy_t('SL12354',TO_DATE('2025-07-03', 'YYYY-MM-DD'), TO_DATE('2025-09-03', 'YYYY-MM-DD'), 
(SELECT REF(c) FROM lb5_cars c WHERE c.regno='SP-KO3599'), 1450.25, 
lb5_cliam_ntab(
lb5_claim_t('CLN-43562344', TO_DATE('2025-07-14', 'YYYY=MM-DD'), 125000.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25434')), 
lb5_claim_t ('CLN-43562345', TO_DATE('2025-07-15', 'YYYY=MM-DD'), 178000.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25434')), 
lb5_claim_t ('CLN-43562346', TO_DATE('2025-07-19', 'YYYY=MM-DD'), 3500.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25435'))
)));
INSERT INTO lb5_policies VALUES(lb5_policy_t('SL12355',TO_DATE('2025-07-09', 'YYYY-MM-DD'), TO_DATE('2026-02-03', 'YYYY-MM-DD'), 
(SELECT REF(c) FROM lb5_cars c WHERE c.regno='UPABB4158'), 1950.00, 
lb5_cliam_ntab(
lb5_claim_t('CLN-43562347', TO_DATE('2025-10-14', 'YYYY=MM-DD'), 530000.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25436')), 
lb5_claim_t ('CLN-43562348', TO_DATE('2025-11-15', 'YYYY=MM-DD'), 365500.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25435'))
)));

select *
from lb5_policies c;

-- a) i)
SELECT p.inscar.owner.name, (sum(p.premium) / count(premium)) AS average_insurance
FROM lb5_policies p
WHERE (MONTHS_BETWEEN(Sysdate, p.inscar.owner.birthdate) / 12) > 20 AND 
(MONTHS_BETWEEN(Sysdate, p.inscar.owner.birthdate) / 12) < 25
GROUP BY p.inscar.owner.name;

--WHERE MONTHS_BETWEEN(SYSDATE, start_date) BETWEEN 5.01 AND 9.99

-- a) ii)
SELECT p.inscar.make, p.inscar.model, SUM(c.amount) AS TOTAL_CLAIM_AMOUNT
FROM lb5_policies p, TABLE(p.claims) c
WHERE p.edate BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY (p.inscar.make, p.inscar.model);

-- b) inserting new object into existing nested table
INSERT INTO TABLE (SELECT p.claims FROM lb5_policies p WHERE p.pid='SL12354')
VALUES (lb5_claim_t('CLN-00000001', TO_DATE('2004-07-12', 'YYYY=MM-DD'), 2000.00, (SELECT REF(c) FROM lb5_customers c WHERE c.cid='S25431')));

SELECT * FROM lb5_policies;

--c 
-- need to create a method to calculate it
ALTER TYPE lb5_policy_t	
ADD MEMBER FUNCTION calculateRenewalPrimium
RETURN FLOAT
CASCADE;

--method body implementation
CREATE OR REPLACE TYPE BODY lb5_policy_t AS
MEMBER FUNCTION calculateRenewalPrimium
RETURN FLOAT IS
    totalClaim FLOAT;
    renewal FLOAT;
    BEGIN
    
        -- following NVL function says that SUM(c.amount) is NULL then return 0
        SELECT NVL(SUM(c.amount), 0)
        INTO totalClaim
        FROM TABLE(SELF.claims) c;
        
        IF totalClaim >= 1000.00 THEN
            renewal := SELF.premium * (120/100) ;
        ELSE 
            renewal := SELF.premium;
        END IF;
        RETURN renewal;
    END calculateRenewalPrimium;
END;
/

-- d
SELECT p.inscar.regno, p.calculateRenewalPrimium()
FROM lb5_policies p
WHERE p.inscar.regno='SP-KO3599';


