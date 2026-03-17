-- CREATE REJECTED TABLE
DROP TABLE IF EXISTS lending_club_rejected;
CREATE TABLE lending_club_rejected
(
	amount_requested TEXT,
	application_date TEXT,
	loan_title TEXT,
	risk_score TEXT,
	debt_to_income_ratio TEXT,
	zip_code TEXT,
	state TEXT,
	employment_length TEXT,
	policy_code TEXT
);

-- LOAD DATA
COPY lending_club_rejected FROM 'C:\Program Files\PostgreSQL\18\rejected_data.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- CHANGE THE DATATYPES OF COLUMNS.
ALTER TABLE lending_club_rejected
ALTER COLUMN amount_requested TYPE INT USING amount_requested::INT,
ALTER COLUMN application_date TYPE DATE USING application_date::DATE,
ALTER COLUMN risk_score TYPE INT USING risk_score::INT,
ALTER COLUMN policy_code TYPE INT USING policy_code::INT;

SELECT * FROM lending_club_rejected LIMIT 100

-- CHECK FOR NULL ROWS
SELECT * FROM lending_club_rejected
WHERE amount_requested IS NULL
	AND application_date IS NULL
    AND employment_length IS NULL;

-- Count nulls in each column
SELECT
    SUM(CASE WHEN amount_requested IS NULL THEN 1 ELSE 0 END) AS null_amount_requested,
    SUM(CASE WHEN application_date IS NULL THEN 1 ELSE 0 END) AS null_application_date,
    SUM(CASE WHEN loan_title IS NULL THEN 1 ELSE 0 END) AS null_loan_title,
    SUM(CASE WHEN risk_score IS NULL THEN 1 ELSE 0 END) AS null_risk_score,
    SUM(CASE WHEN debt_to_income_ratio IS NULL THEN 1 ELSE 0 END) AS null_dti,
    SUM(CASE WHEN zip_code IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN employment_length IS NULL THEN 1 ELSE 0 END) AS null_emp_length,
    SUM(CASE WHEN policy_code IS NULL THEN 1 ELSE 0 END) AS null_policy_code
FROM lending_club_rejected;

-- Duplicate rows across all columns
SELECT amount_requested, application_date, loan_title, risk_score,
       debt_to_income_ratio, zip_code, state, employment_length, policy_code,
       COUNT(*) AS dup_count
FROM lending_club_rejected
GROUP BY amount_requested, application_date, loan_title, risk_score,
         debt_to_income_ratio, zip_code, state, employment_length, policy_code
HAVING COUNT(*) > 1;

-- Delete duplicates but keep one copy
DELETE FROM lending_club_rejected a
USING lending_club_rejected b
WHERE a.ctid < b.ctid
  AND a.amount_requested = b.amount_requested
  AND a.application_date = b.application_date
  AND a.loan_title = b.loan_title
  AND a.risk_score = b.risk_score
  AND a.debt_to_income_ratio = b.debt_to_income_ratio
  AND a.zip_code = b.zip_code
  AND a.state = b.state
  AND a.employment_length = b.employment_length
  AND a.policy_code = b.policy_code;

-- Convert debt_to_income_ratio (strip % then cast)
UPDATE lending_club_rejected
SET debt_to_income_ratio = REPLACE(debt_to_income_ratio, '%', ''),
	debt_to_income_ratio = REPLACE(debt_to_income_ratio, '_', ''),
	loan_title = LOWER(loan_title),
	loan_title = REPLACE(loan_title, '_', ' ');

-- CHANGE THE DATATYPES OF COLUMNS.
ALTER TABLE lending_club_rejected
ALTER COLUMN debt_to_income_ratio TYPE NUMERIC
USING NULLIF(debt_to_income_ratio, '')::NUMERIC;

-- Monthly rejected applications.
SELECT 
	DATE_TRUNC('month', application_date::DATE) AS month,
	COUNT(*) AS rejected_count
FROM lending_club_rejected
GROUP BY month
ORDER BY month;

-- Top 10 loan titles in rejected dataset
SELECT 
	loan_title, 
	COUNT(*) AS rejected_count
FROM lending_club_rejected
GROUP BY loan_title
ORDER BY rejected_count DESC
LIMIT 10;

-- Average risk score of rejected applications
SELECT 
	ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM lending_club_rejected
WHERE risk_score IS NOT NULL;

-- Average DTI among rejected applicants
SELECT 
	ROUND(AVG(debt_to_income_ratio), 2) AS avg_dti
FROM lending_club_rejected
WHERE debt_to_income_ratio IS NOT NULL;

-- Rejections by state
SELECT 
	state,
	COUNT(*) AS rejected_count
FROM lending_club_rejected
WHERE state IS NOT NULL
GROUP BY state
ORDER BY rejected_count DESC;

-- Rejections by ZIP code
SELECT 
	zip_code, 
	COUNT(*) AS rejected_count
FROM lending_club_rejected
WHERE zip_code IS NOT NULL
GROUP BY zip_code
ORDER BY rejected_count DESC
LIMIT 10;

-- Distribution of employment length in rejected dataset
SELECT 
	employment_length, 
	COUNT(*) AS rejected_count
FROM lending_club_rejected
GROUP BY employment_length
ORDER BY rejected_count DESC;

-- Average loan amount requested by employment length
SELECT 
	employment_length,
    ROUND(AVG(amount_requested), 2) AS avg_amount_requested,
    COUNT(*) AS total_apps
FROM lending_club_rejected
WHERE amount_requested::TEXT ~ '^[0-9]+(\.[0-9]+)?$'
GROUP BY employment_length
ORDER BY avg_amount_requested DESC;

-- Find unusually high loan requests (top 1%)
SELECT * FROM lending_club_rejected
WHERE amount_requested > 
(
	SELECT PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY amount_requested)
    FROM lending_club_rejected
    WHERE amount_requested::TEXT ~ '^[0-9]+(\.[0-9]+)?$'
);

-- Median risk_score per state using window functions
SELECT 
	state,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY risk_score) AS median_risk_score,
    COUNT(*) AS total_apps
FROM lending_club_rejected
WHERE risk_score IS NOT NULL
GROUP BY state
ORDER BY median_risk_score DESC;

-- Loan titles with highest average debt-to-income ratio
SELECT 
	loan_title,
    ROUND(AVG(debt_to_income_ratio), 2) AS avg_dti
FROM lending_club_rejected
WHERE debt_to_income_ratio IS NOT NULL
GROUP BY loan_title
HAVING COUNT(*) > 50
ORDER BY avg_dti DESC
LIMIT 10;

-- Rolling 3-month average of rejected applications
SELECT 
	DATE_TRUNC('month', application_date) AS month,
    COUNT(*) AS rejected_count,
    ROUND(AVG(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', application_date) 
	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_avg
FROM lending_club_rejected
WHERE application_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- END.