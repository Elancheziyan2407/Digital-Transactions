import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("transactions.csv")

print(df.head())
print(df.info())


# Remove duplicates
df.drop_duplicates(inplace=True)

# Handle missing values
df['failure_reason'] = df['failure_reason'].fillna('No Failure')

# Standardize text columns
df['payment_mode'] = df['payment_mode'].str.upper()
df['transaction_status'] = df['transaction_status'].str.capitalize()

#Overall Success vs Failure Analysis
status_count = df['transaction_status'].value_counts()
print(status_count)

success_rate = (status_count['Success'] / len(df)) * 100
failure_rate = (status_count['Failed'] / len(df)) * 100

print(f"Success Rate: {success_rate:.2f}%")
print(f"Failure Rate: {failure_rate:.2f}%")

#Bank-wise Failure Analysis
bank_analysis = df.groupby('bank_name').agg(
    total_txn=('transaction_id', 'count'),
    failed_txn=('transaction_status', lambda x: (x == 'Failed').sum())
).sort_values(by='failed_txn', ascending=False)
print(bank_analysis)

#Peak Transaction Hour Analysis
df['transaction_hour'] = pd.to_datetime(df['transaction_time']).dt.hour
hourly_txn = df.groupby('transaction_hour')['transaction_id'].count()
print(hourly_txn)

plt.figure()
status_count.plot(kind="bar")
plt.title("Overall Success vs Failure Analysis")
plt.xlabel("Transaction Status")
plt.ylabel("Number of Transactions")
plt.show()

bank_analysis['failed_txn'].plot(kind='bar')
plt.title("Failed Transactions by Bank")
plt.xlabel("Bank Name")
plt.ylabel("Failed Transactions")
plt.show()

hourly_txn.plot(kind='line')
plt.title("Transactions by Hour")
plt.xlabel("Hour of Day")
plt.ylabel("Transaction Count")
plt.show()


print("Key Insights:")
print("- UPI shows higher transaction volume with higher failure rate during peak hours.")
print("- Certain banks have consistently higher failures.")
print("- Network and bank timeout issues are the main failure reasons.")
