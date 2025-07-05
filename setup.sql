-- Create a database
CREATE DATABASE MyTestDB;
GO

-- Create endpoints for the availability group
CREATE ENDPOINT AG_Endpoint
    STATE=STARTED
    AS TCP (LISTENER_PORT=5022)
    FOR DATABASE_MIRRORING (ROLE=ALL, AUTHENTICATION=CERTIFICATE AG_Cert, ENCRYPTION=REQUIRED ALGORITHM AES);
GO

-- Create the availability group
CREATE AVAILABILITY GROUP MyTestAG
   FOR DATABASE MyTestDB
   REPLICA ON
      'sql1' WITH
         (ENDPOINT_URL = 'TCP://sql1:5022',
         AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
         FAILOVER_MODE = AUTOMATIC),
      'sql2' WITH
         (ENDPOINT_URL = 'TCP://sql2:5022',
         AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
         FAILOVER_MODE = AUTOMATIC),
      'sql3' WITH
         (ENDPOINT_URL = 'TCP://sql3:5022',
         AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
         FAILOVER_MODE = AUTOMATIC);
GO

-- Join the replicas to the availability group
ALTER AVAILABILITY GROUP MyTestAG JOIN;
GO

-- Create a test table and add some data
USE MyTestDB;
GO

CREATE TABLE TestTable (ID INT PRIMARY KEY, Data VARCHAR(100));
GO

INSERT INTO TestTable (ID, Data) VALUES (1, 'Hello from sql1');
GO
