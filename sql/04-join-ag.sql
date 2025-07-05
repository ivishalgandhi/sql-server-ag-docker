
-- Join the replicas to the availability group
ALTER AVAILABILITY GROUP MyTestAG JOIN;
GO

-- Grant connect on endpoint to the availability group
GRANT CONNECT ON ENDPOINT::AG_Endpoint TO [public];
GO
