#!/bin/bash

# Get container hostname (container name)
CONTAINER_NAME=$(hostname)

# Start SQL Server
/opt/mssql/bin/sqlservr &
PID=$!

# Wait for SQL Server to start up
echo "Waiting for SQL Server to start..."
sleep 30

# Set server name to match container name
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "IF SERVERPROPERTY('ServerName') != '$CONTAINER_NAME' EXEC sp_dropserver @@SERVERNAME; EXEC sp_addserver '$CONTAINER_NAME', local"

# Keep container running
wait $PID
