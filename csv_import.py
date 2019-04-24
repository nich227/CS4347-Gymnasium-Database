import csv
import MySQLdb as sql_db

gym_db = sql_db.connect(host='localhost', user='root', passwd='kumar$123', db='gym', autocommit=True)
cursor = gym_db.cursor()

data = csv.reader(open('Database.csv'))
for row in data:
    row_type = row[0]
    row.pop(0)

    if row_type == 'MEMBER':
        print("Imported a MEMBER tuple with values:", row)
        cursor.execute('INSERT INTO MEMBER ' \
        'VALUES(%s, %s, %s, %s, %s, %s, %s, %s);', row)
    
    if row_type == 'ATTENDS':
        row = list(map(int, row)) # Converts all values to integers
        print("Imported an ATTENDS tuple with values:", row)
        cursor.execute('INSERT INTO ATTENDS ' \
        'VALUES(%s, %s);', row)
    
    if row_type == 'MEMBER_Waiver':
        print("Imported a MEMBER_Waiver tuple with values:", row)
        cursor.execute('INSERT INTO MEMBER_Waiver ' \
        'VALUES(%s, %s);', row)
    
    if row_type == 'TRAINER':
        print("Imported a TRAINER tuple with values:", row)
        cursor.execute('INSERT INTO TRAINER ' \
        'VALUES(%s, %s, %s, %s, %s);', row)
    
    if row_type == 'TRAINER_Certification':
        print("Imported a TRAINER_Certification tuple with values:", row)
        cursor.execute('INSERT INTO TRAINER_Certification ' \
        'VALUES(%s, %s);', row)
    
    if row_type == 'ROOM_CType':
        print("Imported a ROOM_CType tuple with values:", row)
        cursor.execute('INSERT INTO ROOM_CType ' \
        'VALUES(%s, %s);', row)

    if row_type == 'ROOM':
        row = list(map(int, row)) # Converts all values to integers
        print("Imported a ROOM tuple with values:", row)
        cursor.execute('INSERT INTO ROOM ' \
        'VALUES(%s, %s);', row)

    if row_type == 'CLASS':
        print("Imported a CLASS tuple with values:", row)
        cursor.execute('INSERT INTO CLASS ' \
        'VALUES(%s, %s, %s, %s, %s, %s, %s);', row)



cursor.close()
print('Done')