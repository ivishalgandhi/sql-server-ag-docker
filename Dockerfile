
FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Install SQL Server AlwaysOn Availability Group feature
RUN /opt/mssql/bin/mssql-conf set hadr.hadrenabled 1

# Add custom entrypoint script to set server name
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER mssql

ENTRYPOINT ["/entrypoint.sh"]
