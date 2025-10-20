CREATE SCHEMA banking_system;

CREATE TABLE banking_system.Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

CREATE TABLE banking_system.Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    branch_address VARCHAR(200) NOT NULL
);

CREATE TABLE banking_system.Employees (
    employee_id INT PRIMARY KEY,
    branch_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES banking_system.Branches(branch_id)
);

CREATE TABLE banking_system.Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    account_type VARCHAR(20) CHECK (account_type IN ('savings', 'checking')),
    balance DECIMAL(15, 2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES banking_system.Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES banking_system.Branches(branch_id)
);

CREATE TABLE banking_system.Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer')),
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES banking_system.Accounts(account_id)
);

CREATE TABLE banking_system.TransactionHistory (
    history_id INT PRIMARY KEY,
    transaction_id INT,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP DEFAULT '9999-12-31',
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (transaction_id) REFERENCES banking_system.Transactions(transaction_id)
);
