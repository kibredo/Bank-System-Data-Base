import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

NUM_BRANCHES = 12
NUM_EMPLOYEES_PER_BRANCH = 10
NUM_CUSTOMERS = 52
NUM_ACCOUNTS_PER_CUSTOMER = 3
NUM_TRANSACTIONS_PER_ACCOUNT = 2

fake = Faker('ru_RU')

DB_CONFIG = {
    'dbname': 'station',
    'user': 'subject',
    'password': '#AreWeThatWeExpected486',
    'host': 'localhost',
    'port': '5432'
}

conn = psycopg2.connect(**DB_CONFIG)
cursor = conn.cursor()

cursor.execute("DELETE FROM banking_system.TransactionHistory;")
cursor.execute("DELETE FROM banking_system.Transactions;")
cursor.execute("DELETE FROM banking_system.Accounts;")
cursor.execute("DELETE FROM banking_system.Customers;")
cursor.execute("DELETE FROM banking_system.Employees;")
cursor.execute("DELETE FROM banking_system.Branches;")
conn.commit()

branches = [
    ("Центральный", "Москва, ул. Ленина, 1"),
    ("Северный", "Санкт-Петербург, пр. Невский, 10"),
    ("Южный", "Ростов-на-Дону, ул. Садовая, 5"),
    ("Западный", "Калининград, ул. Морская, 3"),
    ("Восточный", "Владивосток, ул. Океанская, 7")
]
for i in range(1, NUM_BRANCHES + 1):
    name = branches[i-1][0] if i <= len(branches) else fake.company()
    address = branches[i-1][1] if i <= len(branches) else fake.address()
    cursor.execute(
        "INSERT INTO banking_system.Branches (branch_id, branch_name, branch_address) VALUES (%s, %s, %s);",
        (i, name, address)
    )

employee_positions = ["Менеджер", "Кассир"]
employee_id = 1
for branch_id in range(1, NUM_BRANCHES + 1):
    for _ in range(NUM_EMPLOYEES_PER_BRANCH):
        first_name = fake.first_name()
        last_name = fake.last_name()
        position = random.choice(employee_positions)
        cursor.execute(
            "INSERT INTO banking_system.Employees (employee_id, branch_id, first_name, last_name, position) VALUES (%s, %s, %s, %s, %s);",
            (employee_id, branch_id, first_name, last_name, position)
        )
        employee_id += 1

customers = []
for customer_id in range(1, NUM_CUSTOMERS + 1):
    first_name = fake.first_name()
    last_name = fake.last_name()
    email = fake.email()
    phone = fake.phone_number()[:15]
    cursor.execute(
        "INSERT INTO banking_system.Customers (customer_id, first_name, last_name, email, phone) VALUES (%s, %s, %s, %s, %s);",
        (customer_id, first_name, last_name, email, phone)
    )
    customers.append(customer_id)

account_types = ["savings", "checking"]
account_id = 1
for customer_id in customers:
    for _ in range(NUM_ACCOUNTS_PER_CUSTOMER):
        branch_id = random.randint(1, NUM_BRANCHES)
        account_type = random.choice(account_types)
        balance = random.randint(1000, 10000)
        cursor.execute(
            "INSERT INTO banking_system.Accounts (account_id, customer_id, branch_id, account_type, balance) VALUES (%s, %s, %s, %s, %s);",
            (account_id, customer_id, branch_id, account_type, balance)
        )
        account_id += 1

transaction_types = ["deposit", "withdrawal", "transfer"]
transaction_id = 1
history_id = 1
start_date = datetime(2024, 5, 19, 20, 44)
for account_id in range(1, account_id):
    for _ in range(NUM_TRANSACTIONS_PER_ACCOUNT):
        amount = random.randint(100, 2000)
        days_offset = random.randint(0, 365)
        transaction_date = start_date - timedelta(days=days_offset)
        transaction_type = random.choice(transaction_types)
        cursor.execute(
            "INSERT INTO banking_system.Transactions (transaction_id, account_id, transaction_type, amount, transaction_date) VALUES (%s, %s, %s, %s, %s);",
            (transaction_id, account_id, transaction_type, amount, transaction_date)
        )
        cursor.execute(
            "INSERT INTO banking_system.TransactionHistory (history_id, transaction_id, amount, transaction_date, start_date, end_date, is_active) VALUES (%s, %s, %s, %s, %s, %s, %s);",
            (history_id, transaction_id, amount, transaction_date, start_date, datetime(9999, 12, 31), True)
        )
        transaction_id += 1
        history_id += 1

conn.commit()
cursor.close()
conn.close()

print("done")
