-- CREATE TABLE TRANSACTIONS.
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    step INT,
    type VARCHAR(20),
    amount DECIMAL(12,2),
    nameOrg VARCHAR(50),
    oldbalanceOrg DECIMAL(12,2),
    newbalanceOrg DECIMAL(12,2),
    nameDest VARCHAR(50),
    oldbalanceDest DECIMAL(12,2),
    newbalanceDest DECIMAL(12,2),
    isFraud INT,
	isFlaggedFraud INT
);

-- LOAD CSV INTO THIS TABLE.

-- CHECK THE DATA.
SELECT * FROM transactions LIMIT 50;
SELECT COUNT(*) FROM transactions;

-- CHECK FOR NULL VALUES.
SELECT
	SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END) AS missing_step,
	SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS missing_type,
	SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS missing_amount,
	SUM(CASE WHEN nameOrg IS NULL THEN 1 ELSE 0 END) AS missing_nameOrg,
    SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS missing_oldbalanceOrg,
    SUM(CASE WHEN newbalanceOrg IS NULL THEN 1 ELSE 0 END) AS missing_newbalanceOrg,
	SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END) AS missing_nameDest,
	SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS missing_oldbalanceDest,
	SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END) AS missing_newbalanceDest,
	SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END) AS missing_isFraud,
	SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END) AS missing_isFlaggedFraud
FROM transactions;

-- FEATURE ENGINEERING : ADD NEW COLUMNS
ALTER TABLE transactions ADD balanceDiffOrg DECIMAL(12,2);
ALTER TABLE transactions ADD balanceDiffDest DECIMAL(12,2);
ALTER TABLE transactions ADD hourOfDay INT;

-- POPULATE ENGINEERED FEATURES
UPDATE transactions
SET balanceDiffOrg = oldbalanceOrg - newbalanceOrg,
	balanceDiffDest = newbalanceDest - oldbalanceDest,
 	hourOfDay = step % 24;

SELECT * FROM transactions LIMIT 100;

-- QUERIES
-- 1. Fraud rate by transaction type
SELECT type,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS fraud_cases,
	   ROUND(SUM(isFraud)*100.0/COUNT(*),2) AS fraud_rate_percent
FROM transactions
GROUP BY type
ORDER BY fraud_cases DESC;

-- 2. Fraud by hour of day
SELECT hourOfDay,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS fraud_cases,
       ROUND(SUM(isFraud)*100.0/COUNT(*),2) AS fraud_rate_percent
FROM transactions
GROUP BY hourOfDay
ORDER BY hourOfDay;

-- 3. Fraud by transaction amount buckets
SELECT CASE 
           WHEN amount < 1000 THEN 'Small'
           WHEN amount BETWEEN 1000 AND 10000 THEN 'Medium'
           ELSE 'Large'
       END AS amount_bucket,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS fraud_cases,
       ROUND(SUM(isFraud)*100.0/COUNT(*),2) AS fraud_rate_percent
FROM transactions
GROUP BY amount_bucket
ORDER BY fraud_rate_percent DESC;

-- 4. Top 10 customers with most fraudulent transactions
SELECT 
	nameOrg, 
	COUNT(*) AS fraud_cases
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrg
ORDER BY fraud_cases DESC
LIMIT 10;

-- 5. Top 10 recipients flagged in fraud cases
SELECT 
	nameDest, 
	COUNT(*) AS fraud_cases
FROM transactions
WHERE isFraud = 1
GROUP BY nameDest
ORDER BY fraud_cases DESC
LIMIT 10;

-- 6. -- Overall fraud KPIs
SELECT 
	COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_cases,
    ROUND(SUM(isFraud)*100.0/COUNT(*),2) AS fraud_rate_percent,
	ROUND(AVG(amount),2) AS avg_transaction_amount,
    ROUND(AVG(CASE WHEN isFraud=1 THEN amount END),2) AS avg_fraud_amount
FROM transactions;

--- END.

