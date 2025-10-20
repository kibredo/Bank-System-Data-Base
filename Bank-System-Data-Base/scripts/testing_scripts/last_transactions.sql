SELECT t.transaction_id, t.amount, t.transaction_date
FROM banking_system.Transactions t
ORDER BY t.transaction_date DESC
LIMIT 5 OFFSET 4;
