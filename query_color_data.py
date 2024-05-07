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
SELECT RED, GREEN, BLUE
FROM Observation o JOIN Coral c ON o.cid = c.cid
WHERE Location LIKE %(location)s AND Species LIKE %(species)s
"""

# Execute the query
try:
    cursor.execute(query, filters)
except ps.Error as e:
    print("Error executing the query:", e)

# Fetch the results
results = cursor.fetchall()

# Calculate the sum of RED, GREEN, and BLUE
total_red = sum(row[0] for row in results)
total_green = sum(row[1] for row in results)
total_blue = sum(row[2] for row in results)

# Count the number of rows fetched
num_rows = len(results)

# Calculate the average values
average_red = total_red / num_rows
average_green = total_green / num_rows
average_blue = total_blue / num_rows

# Construct a dictionary with the average values
average_values = {'average_red': average_red, 'average_green': average_green, 'average_blue': average_blue}

# Print the JSON-formatted average values
print(json.dumps(average_values))


# Close cursor and connection
cursor.close()
connection.close()


