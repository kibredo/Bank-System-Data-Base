SELECT c.first_name, c.last_name, a.balance
FROM banking_system.Customers c
JOIN banking_system.Accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC
LIMIT 5;
