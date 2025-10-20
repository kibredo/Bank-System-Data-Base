SELECT a.account_type, COUNT(t.transaction_id) AS transaction_count
FROM banking_system.Accounts a
JOIN banking_system.Transactions t ON a.account_id = t.account_id
GROUP BY a.account_type;
