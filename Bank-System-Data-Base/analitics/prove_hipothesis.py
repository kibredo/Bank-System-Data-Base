import pandas as pd
import psycopg2
from scipy import stats

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

query1 = """
SELECT t.transaction_id, t.amount
FROM banking_system.Transactions t
WHERE t.account_id IN (
    SELECT account_id FROM banking_system.Accounts WHERE branch_id < 5
);
"""
query6 = """
SELECT t.transaction_id, t.amount, t.transaction_date,
       SUM(t.amount) OVER (PARTITION BY t.account_id ORDER BY t.transaction_date) AS running_total
FROM banking_system.Transactions t;
"""
query5 = """
SELECT c.customer_id, a.account_id, a.balance
FROM banking_system.Customers c
JOIN banking_system.Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 1000;
"""

df1 = fetch_query(query1)
df6 = fetch_query(query6)
df5 = fetch_query(query5)

# First one: Средняя сумма транзакций в филиалах с branch_id < 5 больше 1000
t_stat, p_value = stats.ttest_1samp(df1['amount'], 1000, alternative='greater')
if p_value < 0.05:
    print("Гипотеза 1: Средняя сумма транзакций больше 1000 —> True")
else:
    print("Гипотеза 1: Средняя сумма транзакций больше 1000 —> False")

# Second one: Средняя сумма по всем счетам > 2000
t_stat, p_value = stats.ttest_1samp(df6['running_total'], 2000, alternative='greater')
if p_value < 0.05:
    print("Гипотеза 2: Средняя накопительная сумма больше 2000 —> True")
else:
    print("Гипотеза 2: Средняя накопительная сумма больше 2000 —> False")

# Third one: Средний баланс на счетах клиентов > 2000
t_stat, p_value = stats.ttest_1samp(df5['balance'], 2000, alternative='greater')
if p_value < 0.05:
    print("Гипотеза 3: Средний баланс на счетах больше 2000 —> True")
else:
    print("Гипотеза 3: Средний баланс на счетах больше 2000 —> False")
