#!/usr/bin/env python3

# import the pymysql module
import pymysql as ps
import sys
import cgi
import cgitb
cgitb.enable()
import json

# get username from command line
username = 'tfogler'

# get password interactively
pswd = 'beirut!renegade6'

#connect python to mysql
try:
	connection = ps.connect(
		host='bioed.bu.edu',
		user=username,
		password=pswd,
		db="Team_9",
		port=4253	
	)
except ps.Error as e:
	print(e)

# create the cursor object
cursor = connection.cursor()

#next line is always required as first part of html output
print("Content-type: text/html\n")

# Part 2

# read in data from AJAX POST

# location = sys.argv[1]
# species = sys.argv[2]
form = cgi.FieldStorage()


filters = {'location': location, 'species': species}

# define query2
# Select the things from corals
query2 = """
SELECT c.cid, Individual, location, species, color, mapslink 
FROM Coral c join Observation o on c.cid = o.cid
WHERE location LIKE %s AND species LIKE %s;
"""

# execute the query
try:
    cursor.execute(query2, [location, species])
except ps.Error as e:
    print(e)

fields = " ".join([i[0] for i in cursor.description]) # get the field names
results = cursor.fetchall()

print(json.dumps(results))

# print(f"\n-- {query2}")
# print(f"\n--\n{fields}\n--")
# while row != None:
#     # print(" ".join([val or "" for val in row]))    #several values are returned per row
#     row = cursor.fetchone()

#close cursor and connection
cursor.close()
connection.close()



