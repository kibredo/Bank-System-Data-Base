SELECT b.branch_name, COUNT(a.account_id) AS account_count
FROM banking_system.Branches b
JOIN banking_system.Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name
HAVING COUNT(a.account_id) > 1;
