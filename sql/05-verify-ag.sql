
-- Verify the availability group status
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

-- Create a test table and add some data
USE MyTestDB;
GO

CREATE TABLE TestTable (ID INT PRIMARY KEY, Data VARCHAR(100));
GO

INSERT INTO TestTable (ID, Data) VALUES (1, 'Hello from sql1');
GO
