# Python Assignment 1 | Py Me Up, Charlie

## Before You Begin

1. Create a new GitHub repo called `python-challenge`. Then, clone it to your computer.

2. Inside your local git repository, create a directory for both of the  Python Challenges. Use folder names corresponding to the challenges: **PyBank** and  **PyPoll**.

3. Inside of each folder that you just created, add a new file called `main.py`. This will be the main script to run for each analysis.

4. Push the above changes to GitHub.

### PyBank

* Given a dataset ([budget_data.csv](https://ucb.bootcampcontent.com/UCB-Coding-Bootcamp/UCBBERK201902DATA3/blob/master/02-Homework/03-Python/Instructions/PyBank/Resources/budget_data.csv)) of two columns (`Date` and `Profit/Losses`), your task is to create a Python script that analyzes the records to calculate each of the following:

  * The total number of months included in the dataset

  * The net total amount of "Profit/Losses" over the entire period

  * The average of the changes in "Profit/Losses" over the entire period

  * The greatest increase in profits (date and amount) over the entire period

  * The greatest decrease in losses (date and amount) over the entire period

* As an example, your analysis should look similar to the one below:

  ```text
  Financial Analysis
  ----------------------------
  Total Months: 86
  Total: $38382578
  Average  Change: $-2315.12
  Greatest Increase in Profits: Feb-2012 ($1926159)
  Greatest Decrease in Profits: Sep-2013 ($-2196167)
  ```

* In addition, your final script should both print the analysis to the terminal and export a text file with the results.

#### End Result

In essence, you the end result is a script ('''main.py''') that you are able to run from the command line to produce a pre-defined output ('''output.txt''') in the working directory (the folder containing the dataset, script, and output).

![Run_Script](Images/Run_Script.png)
