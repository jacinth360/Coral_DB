#!/usr/bin/env python3

# import the pymysql module
import pymysql as ps
import sys
import cgi
import cgitb
import json

# Enable CGI traceback to debug potential errors
cgitb.enable()

# Connect to the MySQL database
try:
    connection = ps.connect(
        host='bioed.bu.edu',
        user='tfogler',
        password='beirut!renegade6',
        db="Team_9",
        port=4253
    )
except ps.Error as e:
    print("Error connecting to the database:", e)
    sys.exit(1)

# Create the cursor object
cursor = connection.cursor()

# Set content type to application/json
print("Content-type: application/json\n")

# Read in data from AJAX POST
form = cgi.FieldStorage()

# Get location and species values from the form
location = form.getvalue('location_color', '')
species = form.getvalue('species_color', '')

# Define query filters
filters = {'location': location, 'species': species}

# Define the SQL query
query = """
SELECT AVG(RED) as RED, AVG(GREEN) as GREEN, AVG(BLUE) as BLUE
FROM Observation o JOIN Coral c ON o.cid = c.cid
WHERE Location LIKE %(location)s AND Species LIKE %(species)s
group by color;
"""

# Execute the query
try:
    cursor.execute(query, filters)
except ps.Error as e:
    print("Error executing the query:", e)

# Fetch the results
results = cursor.fetchall()
print(json.dumps(results))

# Close cursor and connection
cursor.close()
connection.close()

