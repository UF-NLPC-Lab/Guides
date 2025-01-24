#!./local_env/bin/python3
import psycopg2
conn = psycopg2.connect("dbname='conceptnet5' host='127.0.0.1'")
cursor = conn.cursor()
cursor.execute("SELECT COUNT(*) FROM relations;")
recs = cursor.fetchall()
print(f"There are {recs[0][0]} relations in ConceptNet5")
