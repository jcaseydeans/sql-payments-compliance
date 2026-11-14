-- =====================================================================
-- SQL 101 - Module 01: First Queries
-- Topics: SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT
-- Database: payments_practice.db (fictional payments data, SQLite)
-- Author: Casey Deans
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Exploring the tables
-- ---------------------------------------------------------------------

-- 1a. Preview every column in the merchants table
SELECT *
FROM merchants;

-- 1b. Preview the first 5 ACH entries (LIMIT keeps big tables manageable)
SELECT *
FROM ach_entries
LIMIT 5;


-- ---------------------------------------------------------------------
-- 2. Choosing columns and filtering rows (SELECT, WHERE)
-- ---------------------------------------------------------------------

-- 2a. Risk tier, name, and status for every merchant
SELECT risk_tier, merchant_name, status
FROM merchants;

-- 2b. Active merchants only
SELECT merchant_name, industry, status
FROM merchants
WHERE status = 'Active';

-- 2c. Merchants that are NOT active (e.g., terminated)
SELECT merchant_name, status, risk_tier
FROM merchants
WHERE status <> 'Active';

-- 2d. Healthcare merchants, sorted by state, then name
SELECT merchant_name, state
FROM merchants
WHERE industry = 'Healthcare'
ORDER BY state, merchant_name;

-- 2e. All ACH activity for merchant 12, newest first
SELECT entry_id, entry_date, sec_code, entry_type, amount
FROM ach_entries
WHERE merchant_id = 12
ORDER BY entry_date DESC;


-- ---------------------------------------------------------------------
-- 3. Sorting (ORDER BY)
-- ---------------------------------------------------------------------

-- 3a. Merchants by onboarding date, oldest first
SELECT merchant_name, onboard_date, status
FROM merchants
ORDER BY onboard_date;

-- 3b. Merchants by onboarding date, newest first
SELECT merchant_name, onboard_date, status
FROM merchants
ORDER BY onboard_date DESC;

-- 3c. Active merchants grouped by risk tier, then alphabetical
SELECT risk_tier, merchant_name, status
FROM merchants
WHERE status = 'Active'
ORDER BY risk_tier, merchant_name;


-- ---------------------------------------------------------------------
-- 4. Top-N lists (ORDER BY + LIMIT)
-- ---------------------------------------------------------------------

-- 4a. The 5 longest-standing merchants
SELECT merchant_name, onboard_date, status
FROM merchants
ORDER BY onboard_date
LIMIT 5;

-- 4b. The 5 smallest ACH debits
SELECT *
FROM ach_entries
WHERE entry_type = 'Debit'
ORDER BY amount
LIMIT 5;

-- 4c. The 5 largest ACH debits
SELECT *
FROM ach_entries
WHERE entry_type = 'Debit'
ORDER BY amount DESC
LIMIT 5;

-- 4d. The 10 largest ACH debits, showing only the key columns
SELECT entry_id, merchant_id, entry_date, sec_code, amount
FROM ach_entries
WHERE entry_type = 'Debit'
ORDER BY amount DESC
LIMIT 10;

-- 4e. The 5 largest ACH credits
SELECT entry_id, merchant_id, sec_code, amount
FROM ach_entries
WHERE entry_type = 'Credit'
ORDER BY amount DESC
LIMIT 5;


-- ---------------------------------------------------------------------
-- 5. Unique values (DISTINCT)
-- ---------------------------------------------------------------------

-- 5a. Which entry types exist (Debit / Credit)
SELECT DISTINCT entry_type
FROM ach_entries;

-- 5b. Every SEC code and entry type combination in use
SELECT DISTINCT sec_code, entry_type
FROM ach_entries
ORDER BY sec_code, entry_type;

-- 5c. Industries served, alphabetical
SELECT DISTINCT industry
FROM merchants
ORDER BY industry;

-- 5d. States where merchants are located, alphabetical
SELECT DISTINCT state
FROM merchants
ORDER BY state;
