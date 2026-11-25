-- =====================================================================
-- SQL 101 – Module 02: Filtering
-- Topics: AND / OR / NOT, <>, IN, BETWEEN, LIKE (% and _), IS NULL
-- Database: payments_practice.db (SQLite, fictional data)
-- Author: Casey Deans
-- Checkpoint: passed 5/5 (Nov 24, 2026)
-- =====================================================================


-- ---------------------------------------------------------------------
-- PRACTICE QUERIES
-- ---------------------------------------------------------------------

-- Practice 1 (AND / OR): TEL or PPD debits over $1,500
-- Result: 4 rows
SELECT entry_id, merchant_id, entry_date, sec_code, entry_type, amount
FROM ach_entries
WHERE (sec_code = 'TEL' OR sec_code = 'PPD')
	AND entry_type = 'Debit'
	AND amount > 1500
ORDER BY amount DESC, entry_id;


-- Practice 2 (NOT / <>): ACH credits over $1,000 that are not WEB
-- Result: 2 rows (includes entry 3542, a TEL credit; TEL is debit-only per Nacha)
SELECT entry_id, merchant_id, entry_date, sec_code, entry_type, amount
FROM ach_entries
WHERE sec_code <> 'WEB'
	AND entry_type = 'Credit'
	AND amount > 1000
ORDER BY amount DESC, entry_id;


-- Practice 3 (IN): merchants with a Medium or High risk tier
-- Result: 8 rows
SELECT merchant_id, merchant_name, industry, status, risk_tier
FROM merchants
WHERE risk_tier IN ('Medium', 'High')
ORDER BY risk_tier, merchant_name;


-- Practice 4 (BETWEEN): Q2 2026 WEB debits over $500
-- Result: 42 rows
SELECT entry_id, merchant_id, entry_date, sec_code, entry_type, amount
FROM ach_entries
WHERE entry_date BETWEEN '2026-04-01' AND '2026-06-30'
	AND sec_code = 'WEB'
	AND entry_type = 'Debit'
	AND amount > 500
ORDER BY amount DESC, entry_id;


-- Practice 5 (LIKE with %): merchants with "Group" anywhere in the name
-- Result: 5 rows
SELECT merchant_id, merchant_name, industry, status
FROM merchants
WHERE merchant_name LIKE '%Group%'
ORDER BY merchant_name;


-- Practice 6 (LIKE with _): return codes R01 through R09
-- Result: 8 rows (there is no R06)
SELECT *
FROM return_codes
WHERE return_code LIKE 'R0_'
ORDER BY return_code, category;


-- Practice 7 (IS NULL): merchants with no risk tier
-- Result: 1 row (Lakeview Fitness Club)
SELECT merchant_id, merchant_name, industry, status, risk_tier
FROM merchants
WHERE risk_tier IS NULL
ORDER BY merchant_name;


-- Practice 8A (the NULL trap): merchants not rated Low, using <>
-- Result: 8 rows. Lakeview is missing because comparing NULL to 'Low'
-- gives UNKNOWN, and WHERE only keeps rows that are TRUE.
SELECT merchant_id, merchant_name, status, risk_tier
FROM merchants
WHERE risk_tier <> 'Low'
ORDER BY risk_tier, merchant_name;


-- Practice 8C: merchants not rated Low, including unrated merchants
-- Result: 9 rows
SELECT merchant_id, merchant_name, status, risk_tier
FROM merchants
WHERE risk_tier <> 'Low' OR risk_tier IS NULL
ORDER BY risk_tier, merchant_name;


-- ---------------------------------------------------------------------
-- CHECKPOINT (5/5)
-- ---------------------------------------------------------------------

-- C1: ACH credits, TEL or WEB, at least $500
-- Result: 27 rows
-- The query is returning all credit ach payments received for TEL or WEB
-- that are at least $500, organized in a descending amount order.
SELECT entry_id, merchant_id, entry_date, sec_code, entry_type, amount
FROM ach_entries
WHERE entry_type = 'Credit'
	AND sec_code IN ('TEL', 'WEB')
	AND amount >= 500
ORDER BY amount DESC, entry_id;


-- C2: active merchants not in Healthcare, Education, or Legal Services
-- Result: 16 rows
-- This query returned active merchants that are not in healthcare,
-- education, or legal services. ordered by industry then merchant name.
SELECT merchant_id, merchant_name, industry, risk_tier
FROM merchants
WHERE status = 'Active'
	AND industry <> 'Healthcare'
	AND industry <> 'Education'
	AND industry <> 'Legal Services'
ORDER BY industry, merchant_name;


-- C3: PPD debits in July 2026, $250 to $500 inclusive
-- Result: 71 rows
-- This query is returning all PPD debits for july 2026 that are between
-- $250 and $500 sorted by oldest entry date first.
SELECT entry_id, merchant_id, entry_date, amount
FROM ach_entries
WHERE entry_type = 'Debit'
	AND sec_code = 'PPD'
	AND entry_date LIKE '2026-07%'
	AND amount BETWEEN 250 AND 500
ORDER BY entry_date, entry_id;


-- C4: merchants whose name ends with "Clinic" or "Academy"
-- Result: 6 rows
-- This query returns all merchants whose name ends in either Clinic or
-- Academy, sorted by merchant name.
SELECT merchant_id, merchant_name, industry, status
FROM merchants
WHERE merchant_name LIKE '%Clinic'
	OR merchant_name LIKE '%Academy'
ORDER BY merchant_name, risk_tier;


-- C5: compliance review list – terminated or no risk tier
-- Result: 3 rows
-- This query returns merchants that have been terminated or do not have a
-- risk tier, sorted by merchant name.
SELECT merchant_id, merchant_name, status, risk_tier
FROM merchants
WHERE status = 'Terminated'
	OR risk_tier IS NULL
ORDER BY merchant_name, risk_tier;
