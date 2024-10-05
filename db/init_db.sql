-- Create table users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,  -- Primary key
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address TEXT,
    email VARCHAR(255) UNIQUE NOT NULL,  -- Email must be unique
    age INT CHECK (age >= 18),  -- Age restriction
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table financial_statements
CREATE TABLE financial_statements (
    financial_statement_id SERIAL PRIMARY KEY,  -- Primary key
    label VARCHAR(100) NOT NULL,
    risk_level VARCHAR(50) CHECK (risk_level IN ('Low', 'Medium', 'High'))  -- Restriction for risk levels
);

-- Create table accounts
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,  -- Primary key
    user_id INT NOT NULL,  -- Foreign key to users
    status VARCHAR(50) NOT NULL CHECK (status IN ('Active', 'Inactive')),  -- Only valid statuses
    financial_statement_id INT REFERENCES financial_statements(financial_statement_id) ON DELETE SET NULL,  -- Relation to financial_statements
    net_value DECIMAL(15, 2) CHECK (net_value >= 0),  -- No negative values
    last_transaction TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create table transaction_types
CREATE TABLE transaction_types (
    transaction_type_id SERIAL PRIMARY KEY,  -- Primary key
    label VARCHAR(100) NOT NULL,
    financial_entry VARCHAR(50) CHECK (financial_entry IN ('Debit', 'Credit'))  -- Restriction for entry type
);

-- Create table transactions
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,  -- Primary key
    transaction_type_id INT REFERENCES transaction_types(transaction_type_id) ON DELETE CASCADE,  -- Relation to transaction_types
    cash DECIMAL(15, 2) NOT NULL CHECK (cash >= 0),  -- Cash cannot be negative
    source_account_id INT REFERENCES accounts(account_id) ON DELETE SET NULL,  -- Relation to accounts
    destination_account_id INT REFERENCES accounts(account_id) ON DELETE SET NULL,  -- Relation to accounts
    status VARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'Completed', 'Failed')),  -- Restriction for valid status
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),  -- Amount must be positive
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Transaction date
    CONSTRAINT fk_source_account FOREIGN KEY (source_account_id) REFERENCES accounts(account_id) ON DELETE SET NULL,
    CONSTRAINT fk_destination_account FOREIGN KEY (destination_account_id) REFERENCES accounts(account_id) ON DELETE SET NULL
);

-- Create indexes for performance improvements
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_transactions_source_account_id ON transactions(source_account_id);
CREATE INDEX idx_transactions_destination_account_id ON transactions(destination_account_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);
