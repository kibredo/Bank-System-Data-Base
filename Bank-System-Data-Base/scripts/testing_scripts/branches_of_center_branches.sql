SELECT t.transaction_id, t.amount
FROM banking_system.Transactions t
WHERE t.account_id IN (
    SELECT account_id FROM banking_system.Accounts WHERE branch_id < 5
);
