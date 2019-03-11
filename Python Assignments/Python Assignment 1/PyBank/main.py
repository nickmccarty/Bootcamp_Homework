import pandas as pd

df = pd.read_csv("budget_data.txt",
                 index_col = "Date")

df['shifted_pnl'] = df['Profit/Losses'].shift(1)
df['pnl_diff'] = df['Profit/Losses'] - df['shifted_pnl']

average = df['pnl_diff'].mean()

cache = []

cache.append('Financial Analysis')

cache.append('----------------------------')

cache.append('Total Months: {:,}'.format(len(df.index)))

cache.append('Total: ${:,}'.format(df['Profit/Losses'].sum()))

cache.append('Average Monthly Change: -${:,}'.format(abs(round(average, 2))))

cache.append('Greatest Increase in Profits (MoM): {}  ${:,}'.format(df[df["pnl_diff"] == df["pnl_diff"].max()].index[0],
                                                            int(df['pnl_diff'].max())))

cache.append('Greatest Decrease in Profits (MoM): {} -${:,}'.format(df[df["pnl_diff"] == df["pnl_diff"].min()].index[0],
                                                             int(abs(df['pnl_diff'].min()))))

with open('output.txt', 'w') as output:
    for line in cache:
        output.write("%s\n" % line)