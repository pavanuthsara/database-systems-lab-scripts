-- 1.a
ALTER TYPE lb3_stocks
ADD MEMBER FUNCTION yieldOfStocks RETURN FLOAT CASCADE;

-- to check the stock type
DESC lb3_stocks;

SELECT s.company, ROUND(s.yieldOfStocks(),2)
FROM lb3_stocks_table s;

-- 1.b
ALTER TYPE lb3_stocks
ADD MEMBER FUNCTION priceInUsd(usdRate FLOAT) 
RETURN FLOAT 
CASCADE;

-- DROP the member type because it caused issues (use this if need)
ALTER TYPE lb3_stocks
DROP MEMBER FUNCTION priceInUsd(usdRate FLOAT) RETURN FLOAT
CASCADE;

-- 1.c
ALTER TYPE lb3_stocks
ADD MEMBER FUNCTION countOfExchanges
RETURN INTEGER
CASCADE;

CREATE OR REPLACE TYPE BODY lb3_stocks AS
    MEMBER FUNCTION yieldOfStocks RETURN FLOAT IS
    BEGIN
        RETURN (SELF.last_dividend / SELF.current_rate) * 100 ;
    END yieldOfStocks;

    MEMBER FUNCTION priceInUsd(usdRate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN SELF.current_rate * usdRate;
    END priceInUsd;

    MEMBER FUNCTION countOfExchanges RETURN INTEGER IS
    BEGIN
        RETURN SELF.exchanges_traded.COUNT;
    END countOfExchanges;

END;
/

-- 1.d 
DESC lb3_clients_type;

ALTER TYPE lb3_clients_type
ADD MEMBER FUNCTION calculateTotalPurchase
RETURN FLOAT
CASCADE;
        
       
DESC  lb3_clients_type;
-- 1.e
ALTER TYPE lb3_clients_type
ADD MEMBER FUNCTION calculateTotalProfit 
RETURN FLOAT
CASCADE;  

CREATE OR REPLACE TYPE BODY lb3_clients_type AS 
    MEMBER FUNCTION calculateTotalPurchase RETURN FLOAT IS
        total FLOAT := 0;
    BEGIN
        SELECT SUM(purchaseprice * qty) INTO total
        FROM TABLE(invesments);
        RETURN total;
    END calculateTotalPurchase;
    
    MEMBER FUNCTION calculateTotalProfit RETURN FLOAT IS
        totlaProfit FLOAT := 0;
        BEGIN
            SELECT SUM((i.company.current_rate - i.purchaseprice)* i.qty) INTO totlaProfit
            FROM TABLE(invesments) i;
            
            RETURN totlaProfit;
        END calculateTotalProfit;
END;
/
             
-- question 2
-- 2.a
SELECT s.company, e.COLUMN_VALUE AS TRADED, ROUND(s.yieldOfStocks(), 2) AS STOCK_YIELD, s.priceInUsd(0.74) AS USD_PRICE
FROM lb3_stocks_table s, TABLE(s.exchanges_traded) e;

-- 2.b
SELECT s.company, s.current_rate, s.countOfExchanges()
FROM lb3_stocks_table s
WHERE s.countOfExchanges()>1;
        
-- 2.c
SELECT c.firstname, i.company.company, ROUND(i.company.yieldOfStocks(),2) AS current_yield, i.company.current_rate AS current_price, (i.company.current_rate - i.purchaseprice) AS EARNINGS_PER_SHARE
FROM lb3_clients_table c, TABLE(c.invesments) i;

-- 2.d
SELECT c.firstname, c.calculateTotalPurchase() AS total_purchase
FROM lb3_clients_table c;

-- 2.e
SELECT c.firstname, c.calculateTotalProfit() AS TOTAL_PROFIT
FROM lb3_clients_table c;

--test
SELECT c.firstname,  sum((i.company.current_rate-i.purchaseprice)*  i.qty)
from lb3_clients_table c, table(c.invesments) i
group by c.firstname;        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        





