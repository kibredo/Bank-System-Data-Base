import pandas as pd
import matplotlib.pyplot as plt
import psycopg2

DB_CONFIG = {
    'dbname': 'station',
    'user': 'subject',
    'password': '#AreWeThatWeExpected486',
    'host': 'localhost',
    'port': '5432'
}

def fetch_query(query):
    conn = psycopg2.connect(**DB_CONFIG)
    df = pd.read_sql(query, conn)
    conn.close()
    return df

query4 = """
SELECT b.branch_name, COUNT(a.account_id) AS account_count
FROM banking_system.Branches b
JOIN banking_system.Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name
HAVING COUNT(a.account_id) > 1;
"""
query5 = """
SELECT c.first_name, c.last_name, a.balance
FROM banking_system.Customers c
JOIN banking_system.Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 1000;
"""
query10 = """
SELECT a.account_type, COUNT(t.transaction_id) AS transaction_count
FROM banking_system.Accounts a
JOIN banking_system.Transactions t ON a.account_id = t.account_id
GROUP BY a.account_type;
"""

df4 = fetch_query(query4)
df5 = fetch_query(query5)
df10 = fetch_query(query10)


# first graphic
plt.figure(figsize=(10, 6))
plt.bar(df4['branch_name'], df4['account_count'], color='skyblue')
plt.title('Number of Accounts per Branch')
plt.xlabel('Branch Name')
plt.ylabel('Account Count')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('accounts_per_branch.png')
plt.close()

# second one
plt.figure(figsize=(8, 6))
plt.pie(df10['transaction_count'], labels=df10['account_type'], autopct='%1.1f%%', colors=['lightgreen', 'lightcoral'])
plt.title('Transaction Count by Account Type')
plt.savefig('transactions_by_account_type.png')
plt.close()

# third one
plt.figure(figsize=(10, 6))
plt.hist(df5['balance'], bins=10, color='purple', edgecolor='black')
plt.title('Distribution of Customer Balances (>1000)')
plt.xlabel('Balance')
plt.ylabel('Frequency')
plt.grid(True, alpha=0.3)
plt.savefig('customer_balances_histogram.png')
plt.close()

