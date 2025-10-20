SELECT t.transaction_id, t.amount, t.transaction_date,
       SUM(t.amount) OVER (PARTITION BY t.account_id ORDER BY t.transaction_date) AS running_total
FROM banking_system.Transactions t;
