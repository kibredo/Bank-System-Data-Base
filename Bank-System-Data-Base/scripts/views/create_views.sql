-- VIEWS
--first_one
CREATE OR REPLACE VIEW banking_system.CustomerBalances AS
SELECT c.customer_id, c.first_name, c.last_name,
       COALESCE(SUM(a.balance), 0.00) AS total_balance
FROM banking_system.Customers c
  LEFT JOIN banking_system.Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY customer_id ASC;

--second one
CREATE OR REPLACE VIEW banking_system.LatestTransactions AS
SELECT t.transaction_id, c.first_name, c.last_name,
       t.transaction_type, t.amount
FROM banking_system.Transactions t
  LEFT JOIN banking_system.Accounts acc ON t.account_id = acc.account_id
  LEFT JOIN banking_system.Customers c ON acc.customer_id = c.customer_id
WHERE t.transaction_date >= CURRENT_TIMESTAMP - INTERVAL '100 days'
ORDER BY t.transaction_date ASC;
