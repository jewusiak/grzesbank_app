#!/bin/bash

# Set the port
PORT=8080

# Stop any program currently running on the set port
echo 'preparing port' $PORT '...'
fuser -k 8080/tcp

# switch directories
cd app/

# Start the server
echo 'Server starting on port' $PORT '...'
python3 -m http.server $PORT
