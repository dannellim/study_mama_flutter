#!/bin/bash

# Welcome
echo 'Server start script initialized...'

# Set the port
PORT=4040

# Kill anything that is already running on that port
echo 'Cleaning port' $PORT '...'
fuser -k 4040/tcp

pwd

cd build/
pwd

# Change directories to the release folder
cd web/

# Start the server
echo 'Starting server on port' $PORT '...'
python3 -m http.server $PORT

# Exit
echo 'Server exited...'
