#!/bin/bash
# Wait for SQL Server to be ready
until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "yourStrong(!)Password" -Q "SELECT 1" &> /dev/null; do
  echo "Waiting for SQL Server to be ready..."
  sleep 5
done

# Run the setup script
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "yourStrong(!)Password" -i /usr/src/app/setup.sql
