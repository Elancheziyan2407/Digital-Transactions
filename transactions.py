import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(
    r"D:\Elan\Project\Data Analysis\Digital Transactions\transactions.csv"
)

status_count = df["transaction_status"].value_counts()

plt.figure()
status_count.plot(kind="bar")
plt.title("Overall Success vs Failure Analysis")
plt.xlabel("Transaction Status")
plt.ylabel("Number of Transactions")
plt.show()
