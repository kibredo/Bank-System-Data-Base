SELECT c.first_name, c.last_name
FROM banking_system.Customers c
WHERE EXISTS (
    SELECT 1 FROM banking_system.Accounts a
    JOIN banking_system.Transactions t ON a.account_id = t.account_id
    WHERE a.customer_id = c.customer_id
);
