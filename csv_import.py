import csv
import MySQLdb as sql_db

gym_db = sql_db.connect(host='localhost', user='root', passwd='', db='gym', autocommit=True)
cursor = gym_db.cursor()

data = csv.reader(open('Database.csv'))
for row in data:
    row_type = row[0]
    row.pop(0)

    if row_type == 'ROOM':
        row = list(map(int, row)) # Converts all values to integers
        print("Imported a ROOM tuple with values:", row)
        cursor.execute('INSERT INTO ROOM ' \
        'VALUES(%s, %s);', row)

    if row_type == 'ATTENDS': # SQL Note: A MEMBER must be initialized with MemberID in order for this to work
        row = list(map(int, row)) # Converts all values to integers
        print("Imported an ATTENDS tuple with values:", row)
        cursor.execute('INSERT INTO ATTENDS ' \
        'VALUES(%s, %s);', row)
    
    if row_type == 'TRAINER_Certification':
        print("Imported a TRAINER_Certification tuple with values:", row)
        cursor.execute('INSERT INTO TRAINER_Certification ' \
        'VALUES(%s, %s);', row)

cursor.close()
print('Done')