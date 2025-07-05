
-- Remove database from availability group if it's part of one
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'MyTestDB' AND replica_id IS NOT NULL)
BEGIN
    ALTER DATABASE MyTestDB SET HADR OFF;
END
GO

-- Drop Availability Group
IF EXISTS (SELECT * FROM sys.availability_groups WHERE name = 'MyTestAG')
BEGIN
    DROP AVAILABILITY GROUP MyTestAG;
END
GO

-- Drop Database
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'MyTestDB')
BEGIN
    DROP DATABASE MyTestDB;
END
GO

-- Drop Endpoints
IF EXISTS (SELECT * FROM sys.endpoints WHERE name = 'AG_Endpoint')
BEGIN
    DROP ENDPOINT AG_Endpoint;
END
GO

-- Drop Certificates
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'AG_Cert')
BEGIN
    DROP CERTIFICATE AG_Cert;
END
GO

-- Drop Master Key
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name LIKE '##MS_DatabaseMasterKey##%')
BEGIN
    DROP MASTER KEY;
END
GO
