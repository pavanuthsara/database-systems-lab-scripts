CREATE TABLE lb1_client (
    clon CHAR(3) PRIMARY KEY,
    name VARCHAR2(12),
    address VARCHAR2(30)
)
/

INSERT INTO lb1_client VALUES('c01', 'John Smith', '3 East Av Bentley WA 6102');
INSERT INTO lb1_client VALUES('c02', 'Jill Brody', '42 Bent St Perth WA 6001');

SELECT * FROM lb1_client;

CREATE TABLE lb1_stock (
    company CHAR(7) PRIMARY KEY,
    price NUMBER(6,2),
    dividend NUMBER(4,2),
    eps NUMBER(4,2)
)
/

INSERT INTO lb1_stock VALUES('BHP', 10.50, 1.50, 3.20);
INSERT INTO lb1_stock VALUES('IBM', 70.00, 4.25, 10.00);
INSERT INTO lb1_stock VALUES('INTEL', 76.50, 5.00, 12.40);
INSERT INTO lb1_stock VALUES('FORD', 40.00, 2.00, 8.50);
INSERT INTO lb1_stock VALUES('GM', 60.00, 2.50, 9.20);
INSERT INTO lb1_stock VALUES('INFOSYS', 45.00, 3.00, 7.80);

SELECT * FROM lb1_stock;

CREATE TABLE lb1_trading(
    company CHAR(7),
    exchange VARCHAR2(12),
    
    PRIMARY KEY(company, exchange),
    CONSTRAINT fk_lb1_trading FOREIGN KEY (company) REFERENCES lb1_stock(company)
)
/

INSERT INTO lb1_trading VALUES ('BHP', 'Sydney');
INSERT INTO lb1_trading VALUES ('BHP', 'New York');
INSERT INTO lb1_trading VALUES ('IBM', 'New York');
INSERT INTO lb1_trading VALUES ('IBM', 'London');
INSERT INTO lb1_trading VALUES ('IBM', 'Tokyo');
INSERT INTO lb1_trading VALUES ('INTEL', 'New York');
INSERT INTO lb1_trading VALUES ('INTEL', 'London');
INSERT INTO lb1_trading VALUES ('FORD', 'New York');
INSERT INTO lb1_trading VALUES ('GM', 'New York');
INSERT INTO lb1_trading VALUES ('INFOSYS', 'New York');

SELECT * FROM lb1_trading;


CREATE TABLE lb1_purchase(
    clno CHAR(3),
    company CHAR(7),
    pdate DATE,
    qty NUMBER(6),
    price NUMBER(6,2),
    
    PRIMARY KEY(clno, company, pdate),
    CONSTRAINT fk_lb1_purchase1 FOREIGN KEY (clno) REFERENCES lb1_client(clon),
    CONSTRAINT fk_lb2_purchase2 FOREIGN KEY (company) REFERENCES lb1_stock(company)
)
/

INSERT INTO lb1_purchase VALUES ('c01', 'BHP', TO_DATE('2001-10-02', 'YYYY-MM-DD'), 1000, 12.00);
INSERT INTO lb1_purchase VALUES ('c01', 'BHP', TO_DATE('2002-06-08', 'YYYY-MM-DD'), 2000, 10.50);
INSERT INTO lb1_purchase VALUES ('c01', 'IBM', TO_DATE('2000-02-12', 'YYYY-MM-DD'), 500, 58.00);
INSERT INTO lb1_purchase VALUES ('c01', 'IBM', TO_DATE('2001-04-10', 'YYYY-MM-DD'), 1200, 65.00);
INSERT INTO lb1_purchase VALUES ('c01', 'INFOSYS', TO_DATE('2001-08-11', 'YYYY-MM-DD'), 1000, 64.00);
INSERT INTO lb1_purchase VALUES ('c02', 'INTEL', TO_DATE('2000-01-30', 'YYYY-MM-DD'), 300, 35.00);
INSERT INTO lb1_purchase VALUES ('c02', 'INTEL', TO_DATE('2001-01-30', 'YYYY-MM-DD'), 400, 54.00);
INSERT INTO lb1_purchase VALUES ('c02', 'INTEL', TO_DATE('2001-10-02', 'YYYY-MM-DD'), 200, 60.00);
INSERT INTO lb1_purchase VALUES ('c02', 'FORD', TO_DATE('1999-10-05', 'YYYY-MM-DD'), 300, 40.00);
INSERT INTO lb1_purchase VALUES ('c02', 'GM', TO_DATE('2000-12-12', 'YYYY-MM-DD'), 500, 55.50);

SELECT * FROM lb1_purchase;

--a
SELECT DISTINCT c.name AS client_name, s.company AS stock_name, s.price AS current_price, s.dividend AS last_dividend, s.eps 
FROM lb1_purchase p, lb1_client c, lb1_stock s
WHERE c.clon=p.clno AND p.company=s.company;

--b
SELECT c.name, p.company, SUM(p.qty) AS total_shares , ROUND(SUM(p.qty * p.price)/SUM(p.qty), 2) AS average_purchase_price
FROM lb1_client c
INNER JOIN lb1_purchase p ON c.clon=p.clno
GROUP BY c.name, c.clon, p.company;

--c
SELECT  t.company, c.name, SUM(p.qty) AS shares_held, SUM(p.qty*p.price) AS current_value
FROM lb1_purchase p
INNER JOIN lb1_trading t ON t.company=p.company
INNER JOIN lb1_client c ON c.clon=p.clno
WHERE t.exchange = 'New York'
GROUP BY c.name, c.clon, t.company;

--d
SELECT c.name, SUM(p.qty*p.price) AS total_purchase_value
FROM lb1_purchase p
INNER JOIN lb1_client c ON c.clon = p.clno
GROUP BY c.name, c.clon;

--e
SELECT c.name, SUM((s.price-p.price)*p.qty) AS book_profit
FROM lb1_purchase p
INNER JOIN lb1_client c ON c.clon = p.clno
INNER JOIN lb1_stock s ON s.company = p.company
GROUP BY c.clon, c.name;





