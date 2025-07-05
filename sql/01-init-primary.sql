-- Create a database
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MyTestDB')
BEGIN
    CREATE DATABASE MyTestDB;
    PRINT 'Database MyTestDB created.';
END
ELSE
BEGIN
    PRINT 'Database MyTestDB already exists.';
END
GO

USE MyTestDB;
GO

-- Set recovery model to FULL
ALTER DATABASE MyTestDB SET RECOVERY FULL;
GO

-- Take a full backup
BACKUP DATABASE MyTestDB TO DISK = '/var/opt/mssql/data/MyTestDB.bak'
WITH NOFORMAT, NOINIT,
NAME = 'MyTestDB-full',
SKIP, NOREWIND, NOUNLOAD,
STATS = 10;
GO

-- Create a master key
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name LIKE '##MS_DatabaseMasterKey##%')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'yourStrong(!)Password';
    PRINT 'Master Key created.';
END
ELSE
BEGIN
    PRINT 'Master Key already exists.';
END
GO

-- Open the master key
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'yourStrong(!)Password';
GO

-- Create a certificate for the availability group
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'AG_Cert')
BEGIN
    CREATE CERTIFICATE AG_Cert WITH SUBJECT = 'AG Certificate';
    PRINT 'Certificate AG_Cert created.';
END
ELSE
BEGIN
    PRINT 'Certificate AG_Cert already exists.';
END
GO

-- Separate batch for endpoint creation
USE master;
GO

-- Create endpoints for the availability group
IF NOT EXISTS (SELECT * FROM sys.endpoints WHERE name = 'AG_Endpoint')
BEGIN
    CREATE ENDPOINT AG_Endpoint
        STATE=STARTED
        AS TCP (LISTENER_PORT=5022)
        FOR DATABASE_MIRRORING (ROLE=ALL, AUTHENTICATION=CERTIFICATE AG_Cert, ENCRYPTION=REQUIRED ALGORITHM AES);
    PRINT 'Endpoint AG_Endpoint created.';
END
ELSE
BEGIN
    PRINT 'Endpoint AG_Endpoint already exists.';
END
GO

-- Grant connect on endpoint to public
GRANT CONNECT ON ENDPOINT::AG_Endpoint TO [public];
GO