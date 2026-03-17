-- CREATE ACCEPTED TABLE
DROP TABLE IF EXISTS lending_club_selected;
CREATE TABLE lending_club_selected 
(
    annual_inc        FLOAT,
    emp_length        VARCHAR(50),
    home_ownership    VARCHAR(50),
    addr_state        CHAR(2),
    loan_amnt         FLOAT,
    term              VARCHAR(50),
    int_rate          FLOAT,
    installment       FLOAT,
    purpose           VARCHAR(70),
    issue_d           TEXT,
    fico_range_low    FLOAT,
    fico_range_high   FLOAT,
    open_acc          FLOAT,
    revol_bal         FLOAT,
    revol_util        FLOAT,
    total_acc         FLOAT,
    dti               FLOAT,
    loan_status       VARCHAR(70),
    last_pymnt_d      TEXT,
    last_pymnt_amnt   FLOAT,
    recoveries        FLOAT
);


-- CHANGE THE DATATYPES OF COLUMNS.
ALTER TABLE lending_club_selected
ALTER COLUMN int_rate TYPE NUMERIC USING int_rate::NUMERIC,
ALTER COLUMN installment TYPE NUMERIC USING installment::NUMERIC,
ALTER COLUMN annual_inc TYPE NUMERIC USING annual_inc::NUMERIC,
ALTER COLUMN loan_amnt TYPE NUMERIC USING loan_amnt::NUMERIC,
ALTER COLUMN issue_d TYPE DATE USING TO_DATE(issue_d, 'Mon-YYYY'),
ALTER COLUMN fico_range_low TYPE INT USING fico_range_low::INT,
ALTER COLUMN fico_range_high TYPE INT USING fico_range_high::INT,
ALTER COLUMN open_acc TYPE INT USING open_acc::INT,
ALTER COLUMN revol_bal TYPE NUMERIC USING revol_bal::NUMERIC,
ALTER COLUMN revol_util TYPE NUMERIC USING revol_util::NUMERIC,
ALTER COLUMN total_acc TYPE INT USING total_acc::INT,
ALTER COLUMN dti TYPE NUMERIC USING dti::NUMERIC,
ALTER COLUMN last_pymnt_d TYPE DATE USING TO_DATE(last_pymnt_d, 'Mon-YYYY'),
ALTER COLUMN last_pymnt_amnt TYPE NUMERIC USING last_pymnt_amnt::NUMERIC,
ALTER COLUMN recoveries TYPE NUMERIC USING recoveries::NUMERIC;


-- CHECK FOR NULL VALUES 
-- DELETE ROWS WHERE CRITICAL PREDICTORS ARE MISSING
SELECT * FROM lending_club_selected
WHERE annual_inc IS NULL
   OR loan_amnt IS NULL
   OR fico_range_low IS NULL
   OR fico_range_high IS NULL;

DELETE FROM lending_club_selected
WHERE annual_inc IS NULL
   OR loan_amnt IS NULL
   OR fico_range_low IS NULL
   OR fico_range_high IS NULL;

-- Add a binary default flag column
ALTER TABLE lending_club_selected
ADD COLUMN default_flag INT;

-- Populate the flag
-- 1 = Charged Off, 0 = Fully Paid
UPDATE lending_club_selected
SET default_flag = CASE
    WHEN loan_status = 'Charged Off' THEN 1
    WHEN loan_status = 'Fully Paid' THEN 0
    ELSE NULL  
END;

-- CHECK FOR DUPLICATE VALUES
SELECT annual_inc, emp_length, home_ownership, addr_state, loan_amnt, term, int_rate,
           installment, purpose, issue_d, fico_range_low, fico_range_high, open_acc, 
		   revol_bal, revol_util, COUNT(*)
FROM lending_club_selected
GROUP BY annual_inc, emp_length, home_ownership, addr_state, loan_amnt, term, int_rate,
             installment, purpose, issue_d, fico_range_low, fico_range_high, open_acc,
			  revol_bal, revol_util
HAVING COUNT(*) > 1;

-- Count of accepted loans
SELECT COUNT(*) AS total_accepted_loans FROM lending_club_selected;

-- Average loan amount and income
SELECT 
	ROUND(AVG(loan_amnt), 2) AS avg_loan_amnt, 
	ROUND(AVG(annual_inc), 2) AS avg_annual_inc
FROM lending_club_selected;

-- Default rate overall
SELECT 
	ROUND(AVG(default_flag), 2) AS default_rate 
FROM lending_club_selected;

-- Default rate by loan purpose
SELECT 
	purpose, 
	ROUND(AVG(default_flag), 2) AS default_rate
FROM lending_club_selected
GROUP BY purpose
ORDER BY default_rate DESC;

-- Average FICO by default status
SELECT 
	default_flag, 
	ROUND(AVG((fico_range_low + fico_range_high)/2), 2) AS avg_fico
FROM lending_club_selected
GROUP BY default_flag;

-- Default rate by state
SELECT 
	addr_state, 
	COUNT(*) AS total_loans,
    ROUND(AVG(default_flag), 2) AS default_rate
FROM lending_club_selected
GROUP BY addr_state
ORDER BY default_rate DESC;

-- END.