--INDEXX
CREATE INDEX idx_accounts_customer_id 
ON banking_system.Accounts (customer_id);

CREATE INDEX idx_transactions_transaction_date 
ON banking_system.Transactions (transaction_date);
