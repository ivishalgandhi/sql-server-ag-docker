# SQL Server 2022 Availability Group on Docker

This project sets up a SQL Server 2022 Always On Availability Group using Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Setup

1.  **Start the containers:**

    Navigate to the `sql-containers` directory and run:

    ```bash
    docker compose up --build -d
    ```

    This will:
    - Build a custom SQL Server image with HADR enabled.
    - Start three SQL Server instances (`sql1`, `sql2`, `sql3`) with fixed IP addresses.
    - Start a `sql-setup` container that will remain running.

2.  **Run Part 1 of the setup script:**

    Execute the first part of the setup script on the `sql-setup` container:

    ```bash
    docker exec sql-setup /sql/setup-ag.sh part1
    ```

    This will clean up previous setups and initialize the primary replica (`sql1`). Check the logs of `sql-setup` to ensure `part1` completes successfully.

3.  **Manually copy database backup:**

    After `part1` has finished, you need to manually copy the database backup from `sql1` to `sql2` and `sql3`. This is crucial for the secondary replicas to join the Availability Group.

    ```bash
    docker cp sql1:/var/opt/mssql/data/MyTestDB.bak .  # Copies to your host machine
    docker cp MyTestDB.bak sql2:/var/opt/mssql/data/MyTestDB.bak
    docker cp MyTestDB.bak sql3:/var/opt/mssql/data/MyTestDB.bak
    ```

4.  **Continue with the setup (Part 2):**

    After successfully copying the files, you need to instruct the `sql-setup` container to run the second part of the setup script:

    ```bash
    docker exec sql-setup /sql/setup-ag.sh part2
    ```

    This will initialize the secondary replicas, create the Availability Group, join the secondary replicas, and verify the setup.

5.  **Verify the setup:**

    You can check the logs of the `sql-setup` container to see the progress:

    ```bash
    docker logs sql-setup
    ```

    Once the setup is complete, you can connect to any of the SQL Server instances and query the `sys.dm_hadr_availability_replica_states` DMV to check the status of the availability group.

    ```sql
    SELECT
        ag.name AS ag_name,
        ar.replica_server_name,
        ar.availability_mode_desc,
        ar.failover_mode_desc,
        drs.synchronization_health_desc,
        drs.database_state_desc
    FROM
        sys.availability_groups ag
    JOIN
        sys.availability_replicas ar ON ag.group_id = ar.group_id
    JOIN
        sys.dm_hadr_database_replica_states drs ON ar.replica_id = drs.replica_id
    GO
    ```

## Important Notes

-   **SA Password:** The `SA_PASSWORD` is set to `yourStrong(!)Password` in `docker-compose.yml` and used in the SQL scripts. **Change this to a strong, secure password for production environments.**
-   **Certificates:** The setup uses self-signed certificates for the Availability Group. For production, you should use certificates issued by a trusted Certificate Authority.