CREATE DATABASE payment_analysis;
USE payment_analysis;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    merchant_id INT,
    transaction_date DATE,
    transaction_time TIME,
    payment_mode VARCHAR(20),
    bank_name VARCHAR(50),
    amount DECIMAL(10,2),
    transaction_status VARCHAR(10),
    failure_reason VARCHAR(50)
);


1.Success vs Failure Count:
SELECT transaction_status, COUNT(*) AS total
FROM transactions
GROUP BY transaction_status;


2.Failure Rate by Payment Mode:
SELECT 
    payment_mode,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_txn,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) AS failure_rate
FROM transactions
GROUP BY payment_mode;


3.Peak Transaction Hours:
SELECT 
    HOUR(transaction_time) AS hour,
    COUNT(*) AS transactions
FROM transactions
GROUP BY hour
ORDER BY transactions DESC;

4.Failure Reason Distribution:
SELECT 
    failure_reason,
    COUNT(*) AS failure_count
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY failure_reason;


Data Cleaning:

1.Remove nulls:
DELETE FROM transactions
WHERE transaction_id IS NULL;

2.Standardize values:
UPDATE transactions
SET payment_mode = UPPER(payment_mode);

3.Check duplicates:
SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


Core Analysis
1.Overall Success vs Failure Rate
SELECT 
  transaction_status,
  COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_status;

2.Failure Rate by Payment Mode
SELECT 
  payment_mode,
  COUNT(*) AS total_txn,
  SUM(CASE WHEN transaction_status='Failed' THEN 1 ELSE 0 END) AS failed_txn,
  ROUND(
    SUM(CASE WHEN transaction_status='Failed' THEN 1 ELSE 0 END)*100.0 / COUNT(*),2
  ) AS failure_rate
FROM transactions
GROUP BY payment_mode;

3.Bank-wise Failure Analysis
SELECT 
  bank_name,
  COUNT(*) AS total_txn,
  SUM(CASE WHEN transaction_status='Failed' THEN 1 ELSE 0 END) AS failed_txn
FROM transactions
GROUP BY bank_name
ORDER BY failed_txn DESC;

4.Peak Transaction Hours
SELECT 
  HOUR(transaction_time) AS txn_hour,
  COUNT(*) AS total_txn
FROM transactions
GROUP BY txn_hour
ORDER BY total_txn DESC;

5.Failure Reason Distribution
SELECT 
  failure_reason,
  COUNT(*) AS failures
FROM transactions
WHERE transaction_status='Failed'
GROUP BY failure_reason
ORDER BY failures DESC;


6.Success vs Failure Count:
SELECT transaction_status, COUNT(*) AS total
FROM transactions
GROUP BY transaction_status;

7.Failure Rate by Payment Mode:
SELECT 
    payment_mode,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_txn,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) AS failure_rate
FROM transactions
GROUP BY payment_mode;

8.Bank-wise Failure Analysis:
SELECT 
    bank_name,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_txn
FROM transactions
GROUP BY bank_name
ORDER BY failed_txn DESC;

9.Peak Transaction Hours:
SELECT 
    HOUR(transaction_time) AS hour,
    COUNT(*) AS transactions
FROM transactions
GROUP BY hour
ORDER BY transactions DESC;

10.Failure Reason Distribution:
SELECT 
    failure_reason,
    COUNT(*) AS failure_count
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY failure_reason;

Join Querires:

1.User-wise Transaction Failure Analysis:
SELECT 
    u.user_name,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN t.transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_txn
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.user_name;

2.Merchant-wise Failure Rate
SELECT 
    m.merchant_name,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN t.transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_txn,
    ROUND(
      SUM(CASE WHEN t.transaction_status='Failed' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) AS failure_rate
FROM transactions t
JOIN merchants m
ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name;

3.City-wise Payment Failure Analysis:
SELECT 
    u.city,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN t.transaction_status='Failed' THEN 1 ELSE 0 END) AS failed_txn
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.city;

4.Merchant Category vs Payment Mode:
SELECT 
    m.category,
    t.payment_mode,
    COUNT(*) AS total_txn
FROM transactions t
JOIN merchants m
ON t.merchant_id = m.merchant_id
GROUP BY m.category, t.payment_mode;
