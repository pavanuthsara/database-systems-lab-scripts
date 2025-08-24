--client table `address` column
CREATE TYPE lb3_address AS OBJECT (
    streetno VARCHAR2(10),
    streetname VARCHAR2(10),
    suburb VARCHAR2(10),
    state VARCHAR2(10),
    pin CHAR(4)
)
/

--stocks table `exchange traded` column
CREATE TYPE lb3_exchanges AS VARRAY(3) OF VARCHAR2(10)
/

--object type for `stock` table
CREATE TYPE lb3_stocks AS OBJECT(
    company VARCHAR2(10),
    current_rate NUMBER(4,2),
    exchanges_traded lb3_exchanges,
    last_dividend NUMBER(3,2),
    earnings_per_share NUMBER(4,2)
)
/

--object type for invesments / this will be inside the clients table
CREATE TYPE lb3_investments_type AS OBJECT (
    company REF lb3_stocks,
    purchaseprice NUMBER(4,2),
    dateofinvestment DATE,
    qty NUMBER(5)
)
/

--`invesment nested table`
CREATE TYPE lb3_invesments_table AS TABLE OF lb3_investments_type
/

--creating a `client` object type
CREATE TYPE lb3_clients_type AS OBJECT(
    firstname VARCHAR2(10),
    lastname VARCHAR2(10),
    address lb3_address,
    invesments lb3_invesments_table
)
/
desc lb3_clients_type;

--creation of stocks table 
CREATE TABLE lb3_stocks_table OF lb3_stocks (
    company PRIMARY KEY
);
SELECT * FROM lb3_stocks_table;

--create `client` table 
CREATE TABLE lb3_clients_table OF lb3_clients_type(
    PRIMARY KEY (firstname, lastname)
) NESTED TABLE invesments STORE AS invesments_table;
SELECT * FROM lb3_clients_table;

--insert data into `stocks` table
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('BHP', 10.50, lb3_exchanges('Sydney', 'New York'), 1.50, 3.20));
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('IBM', 70.00, lb3_exchanges('London', 'New York', 'Tokyo'), 4.25, 10.00));
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('INTEL', 76.50, lb3_exchanges('London', 'New York'), 5.00, 12.40));
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('FORD', 40.00, lb3_exchanges('New York'), 2.00, 8.50));
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('GM', 60.00, lb3_exchanges('New York'), 2.50, 9.20));
INSERT INTO lb3_stocks_table VALUES (lb3_stocks('INFOSYS', 45.00, lb3_exchanges('New York'), 3.00, 7.80));

SELECT * FROM lb3_clients_table;
--insert data into `clients` table
INSERT INTO lb3_clients_table VALUES ('John', 'Smith', lb3_address('3', 'East Av', 'Bentley', 'WA', '6102'), lb3_invesments_table(
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='BHP'), 12.00, TO_DATE('2001-10-02', 'YYYY-MM-DD') , 1000),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='BHP'), 10.50, TO_DATE('2002-06-08', 'YYYY-MM-DD') , 2000),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='IBM'), 58.00, TO_DATE('2000-02-12', 'YYYY-MM-DD') , 500),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='IBM'), 65.00, TO_DATE('2001-04-10', 'YYYY-MM-DD') , 1200),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INFOSYS'), 64.00, TO_DATE('2001-08-11', 'YYYY-MM-DD') , 1000)
));
INSERT INTO lb3_clients_table VALUES ('Jill', 'Brody', lb3_address('42', 'Bent St', 'Perth', 'WA', '6001'), lb3_invesments_table(
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INTEL'), 35.00, TO_DATE('2000-01-30', 'YYYY-MM-DD') , 300),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INTEL'), 54.00, TO_DATE('2001-01-30', 'YYYY-MM-DD') , 400),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INTEL'), 60.00, TO_DATE('2001-10-02', 'YYYY-MM-DD') , 200),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='FORD'), 40.00, TO_DATE('1999-10-05', 'YYYY-MM-DD') , 300),
lb3_investments_type((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='GM'), 55.50, TO_DATE('2000-12-12', 'YYYY-MM-DD') , 500)
));

SELECT * FROM lb3_stocks_table;
SELECT * FROM lb3_clients_table;

--a
SELECT DISTINCT c.firstname, c.lastname, i.company.company AS STOCK_NAME, i.company.current_rate AS CURRENT_PRICE, i.company.last_dividend AS LAST_DIVIDEND, i.company.earnings_per_share AS EARNINGS_PER_SHARE
FROM lb3_clients_table c, TABLE (c.invesments) i
ORDER BY c.firstname;

--b  
SELECT c.firstname, c.lastname, i.company.company AS STOCK_NAME, SUM(i.qty) AS TOTAL_NO_OF_SHARES, ROUND(SUM(i.purchaseprice * i.qty)/SUM(i.qty), 2) AS AVERAGE_PRICE_PAID_BY_CLIENT
FROM lb3_clients_table c, TABLE (c.invesments) i
GROUP BY c.firstname, c.lastname, i.company.company
ORDER BY c.firstname;

--c 
SELECT i.company.company AS STOCK_NAME, c.firstname, SUM(i.qty) AS NO_OF_SHARES, i.company.current_rate
FROM lb3_clients_table c, TABLE (c.invesments) i, TABLE (i.company.exchanges_traded) e
WHERE e.COLUMN_VALUE='New York'
GROUP BY i.company.company, c.firstname,  i.company.current_rate;

--d
SELECT c.firstname, c.lastname, SUM(i.purchaseprice * i.qty) AS TOTAL_INVESMENTS
FROM lb3_clients_table c, TABLE (c.invesments) i
GROUP BY c.firstname, c.lastname;

--e
SELECT c.firstname, c.lastname, SUM((i.company.current_rate - i.purchaseprice) * i.qty) AS TOTAL_PROFIT
FROM lb3_clients_table c, TABLE (c.invesments) i
GROUP BY c.firstname, c.lastname;

--question 4
INSERT INTO TABLE (
    SELECT c.invesments
    FROM lb3_clients_table c
    WHERE c.firstname = 'John'
)
VALUES ((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='GM' ), 60.00, TO_DATE('2025-08-23','YYYY-MM-DD'), 500);

DELETE FROM TABLE (
    SELECT c.invesments 
    FROM lb3_clients_table c
    WHERE c.firstname = 'John'
)
WHERE company=(SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INFOSYS');

INSERT INTO TABLE (
    SELECT c.invesments
    FROM lb3_clients_table C
    WHERE c.firstname = 'Jill'
)
VALUES ((SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='INFOSYS' ), 45.00, TO_DATE('2025-08-23','YYYY-MM-DD'), 1000);
DELETE FROM TABLE (
    SELECT c.invesments 
    FROM lb3_clients_table c
    WHERE c.firstname = 'Jill'
)
WHERE company=(SELECT REF(s) FROM lb3_stocks_table s WHERE s.company='GM');
