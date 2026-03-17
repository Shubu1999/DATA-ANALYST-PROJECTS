-- CREATE TABLE FOR AML TRANSACTIONS.
DROP TABLE IF EXISTS aml_data;

CREATE TABLE aml_data
(
	time TIME,
	date DATE,
	sender_account BIGINT,
	receiver_account BIGINT,
	amount NUMERIC(18,2),
	payment_currency VARCHAR(20),
	received_currency VARCHAR(20),
	sender_bank_location VARCHAR(20),
	receiver_bank_location VARCHAR(20),
	payment_type VARCHAR(20),
	is_laundering BOOLEAN,
	laundering_type VARCHAR(50)
);

SELECT * FROM aml_data LIMIT 100;

-- CHECK FOR NULL VALUES.
SELECT COUNT(*) AS null_values 
FROM aml_data 
WHERE time IS NULL
AND date IS NULL
AND sender_account IS NULL
AND receiver_account IS NULL
AND amount IS NULL
AND payment_currency IS NULL 
AND received_currency IS NULL
AND sender_bank_location IS NULL
AND receiver_bank_location IS NULL
AND payment_type IS NULL
AND is_laundering IS NULL
AND laundering_type IS NULL;

-- CHECK FOR DUPLICATE VALUES
SELECT sender_account, receiver_account, amount, date, time, COUNT(*)
FROM aml_data
GROUP BY sender_account, receiver_account, amount, date, time
HAVING COUNT(*) > 1;

-- CHECK FOR OUTLIERS
SELECT amount 
FROM aml_data 
ORDER BY amount  
LIMIT 50;

SELECT amount 
FROM aml_data 
ORDER BY amount DESC
LIMIT 50;


--DESCRIPTIVE STATISTICS
--1. What is the total number of transactions in the dataset?
SELECT COUNT(*) AS total_transactions FROM aml_data;

--2. What is the average, minimum, and maximum transaction amount?
SELECT 
	ROUND(AVG(amount),2) AS avg_amount,
	MIN(amount) AS min_amount,
	MAX(amount) AS max_amount
FROM aml_data;
	
--3. How are transactions distributed across different payment types?
SELECT 	
	payment_type,
	COUNT(payment_type) AS tansactions
FROM aml_data
GROUP BY payment_type;

--4. Which currencies are most frequently used for payments and receipts?
-- For payment currency
SELECT
	payment_currency,
	COUNT(payment_currency)
FROM aml_data
GROUP BY payment_currency
ORDER BY 2 DESC;
-- For recieved currency
SELECT
	received_currency,
	COUNT(received_currency)
FROM aml_data
GROUP BY received_currency
ORDER BY 2 DESC;

--5. What is the monthly transaction volume trend?
SELECT 
	TO_CHAR(date, 'Mon') AS month,
	COUNT(*) AS monthly_transactions_count,
	SUM(amount) AS monthly_transactions_amount
FROM aml_data 
GROUP BY month
ORDER BY monthly_transactions_count DESC;


--AML RULE-BASED MONITORING
--1. How many transactions exceed a regulatory threshold (e.g., > average amount)?
SELECT
	COUNT(*) AS transactions_exceeding_avg_amt
FROM aml_data
WHERE amount > (SELECT AVG(amount) FROM aml_data);

--2. Which accounts have multiple small deposits just below the average (structuring)?
SELECT
	sender_account,
	COUNT(*) AS transaction_count,
	SUM(amount) AS total_amount
FROM aml_data
WHERE amount < (SELECT AVG(amount) FROM aml_data)
GROUP BY sender_account
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;

--3. Which transactions involve high‑risk payment types (e.g., cash)?
SELECT * FROM aml_data
WHERE payment_type = 'Cash Deposit';

--4. How many transactions are flagged as laundering?
SELECT COUNT(*) FROM aml_data
WHERE is_laundering = true;


-- GEOGRAPHIC RISK ANALYSIS
--1. Which sender bank locations generate the highest transaction volume?
SELECT 	
	sender_bank_location,
	COUNT(*) AS total_transactions
FROM aml_data
GROUP BY sender_bank_location
ORDER BY COUNT(*) DESC;

--2. Which receiver bank locations are most common?
SELECT 	
	receiver_bank_location,
	COUNT(*) AS total_transactions
FROM aml_data
GROUP BY receiver_bank_location
ORDER BY COUNT(*) DESC;

--3. Are there patterns of cross‑border transfers between specific countries?
SELECT 
	sender_bank_location,
	receiver_bank_location,
	COUNT(*) AS total_transactions,
	SUM(amount) AS total_amount
FROM aml_data 
WHERE payment_type = 'Cross-border'
GROUP BY sender_bank_location, receiver_bank_location
ORDER BY total_transactions DESC;

--FEATURE ENGINEERING AND RISK SCORING
--1. What is the transaction frequency per account over a given period?
SELECT 
	sender_account,
	COUNT(*) AS txn_count
FROM aml_data
WHERE date BETWEEN '2023-05-01' AND '2023-05-31'
GROUP BY sender_account
ORDER BY txn_count DESC;

--2. Which accounts have the highest transaction amounts?
SELECT 
	sender_account, 
	SUM(amount) AS total_sent
FROM aml_data
GROUP BY sender_account
ORDER BY total_sent DESC;

--3. Which accounts are both high‑frequency and high‑value senders?
SELECT 
	sender_account,
    COUNT(*) AS txn_count,
    SUM(amount) AS total_sent
FROM aml_data
GROUP BY sender_account
HAVING COUNT(*) > 50 AND SUM(amount) > 500000
ORDER BY total_sent DESC;

-- END.