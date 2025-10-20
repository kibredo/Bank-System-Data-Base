SELECT c.first_name, c.last_name, a.account_id
FROM banking_system.Customers c
LEFT JOIN banking_system.Accounts a ON c.customer_id = a.customer_id;
