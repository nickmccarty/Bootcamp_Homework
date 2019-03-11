import pandas as pd
import operator

df = pd.read_csv('election_data.csv',
                 index_col = 'Voter ID')

total_votes = len(df.index)

khan_votes    = round(((len(df[df['Candidate'].str.contains('Khan')])/len(df.index)) * 100), 1)
correy_votes  = round(((len(df[df['Candidate'].str.contains('Correy')])/len(df.index)) * 100), 1)
li_votes      = round(((len(df[df['Candidate'].str.contains('Li')])/len(df.index)) * 100), 1)
otooley_votes = round(((len(df[df['Candidate'].str.contains("O'Tooley")])/len(df.index)) * 100), 1)

candidates = df.Candidate.unique()

vote_breakdown = {'Khan' : khan_votes,
                  'Correy' : correy_votes,
                  'Li' : li_votes,
                  "O'Tooley" : otooley_votes}

cache = []

cache.append('Election Results')
cache.append('----------------------------')
cache.append('Total Votes: {:,}'.format(len(df.index)))
cache.append('----------------------------')

for candidate in candidates:
    cache.append("{}: {}% ({:,})".format(
        candidate, vote_breakdown[candidate], len(df[df['Candidate'].str.contains(candidate)])))
    
cache.append('----------------------------')

cache.append('Winner: ' + max(vote_breakdown.items(), key=operator.itemgetter(1))[0])

with open('output.txt', 'w') as output:
    for line in cache:
        output.write("%s\n" % line)