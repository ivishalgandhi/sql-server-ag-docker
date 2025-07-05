#!/bin/bash
set -e

# Configuration
PRIMARY_REPLICA="sql1"
SECONDARY_REPLICAS=("sql2" "sql3")
DATABASE_NAME="MyTestDB"
AG_NAME="MyTestAG"
SA_PASSWORD="yourStrong(!)Password"

# Function to wait for SQL Server to be ready
wait_for_sql() {
  local replica=$1
  echo "Waiting for SQL Server on $replica to be ready..."
  until /opt/mssql-tools/bin/sqlcmd -S $replica -U sa -P "$SA_PASSWORD" -Q "SELECT 1" &> /dev/null; do
    echo "SQL Server on $replica is not yet ready. Waiting..."
    sleep 5
  done
  echo "SQL Server on $replica is ready."
}

# Function to execute a SQL script on a given replica
execute_sql() {
  local replica=$1
  local script=$2
  echo "Executing $script on $replica..."
  /opt/mssql-tools/bin/sqlcmd -S $replica -U sa -P "$SA_PASSWORD" -i "/sql/$script"
  echo "Finished $script on $replica."
}

# Main execution logic
case "$1" in
  "part1")
    # Wait for all SQL Servers to be ready
    wait_for_sql $PRIMARY_REPLICA
    for replica in "${SECONDARY_REPLICAS[@]}"; do
      wait_for_sql $replica
    done

    # 0. Cleanup previous setup
    echo "Cleaning up previous setup on all replicas..."
    execute_sql $PRIMARY_REPLICA "00-cleanup.sql"
    for replica in "${SECONDARY_REPLICAS[@]}"; do
      execute_sql $replica "00-cleanup.sql"
    done

    # 1. Initialize the primary replica
    echo "Initializing primary replica ($PRIMARY_REPLICA)..."
    execute_sql $PRIMARY_REPLICA "01-init-primary.sql"
    ;;
  "part2")
    # 2. Initialize the secondary replicas
    for replica in "${SECONDARY_REPLICAS[@]}"; do
      echo "Initializing secondary replica ($replica)..."
      execute_sql $replica "02-init-secondaries.sql"
    done

    # 3. Create the availability group on the primary replica
    echo "Creating availability group ($AG_NAME) on primary replica ($PRIMARY_REPLICA)..."
    execute_sql $PRIMARY_REPLICA "03-create-ag.sql"

    # Add a delay before joining replicas
    echo "Waiting for 10 seconds before joining replicas..."
    sleep 10

    # 4. Join the secondary replicas to the availability group
    for replica in "${SECONDARY_REPLICAS[@]}"; do
      echo "Joining secondary replica ($replica) to availability group ($AG_NAME)..."
      execute_sql $replica "04-join-ag.sql"
    done

    # 5. Verify the availability group status
    echo "Verifying availability group status..."
    execute_sql $PRIMARY_REPLICA "05-verify-ag.sql"
    ;;
  *)
    echo "Usage: $0 {part1|part2}"
    exit 1
    ;;
esac