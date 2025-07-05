@echo off

echo Copying MyTestDB.bak from sql1 to current directory...
docker cp sql1:/var/opt/mssql/data/MyTestDB.bak .

echo Copying MyTestDB.bak to sql2...
docker cp MyTestDB.bak sql2:/var/opt/mssql/data/MyTestDB.bak

echo Copying MyTestDB.bak to sql3...
docker cp MyTestDB.bak sql3:/var/opt/mssql/data/MyTestDB.bak

echo All files copied. You can now proceed with part2 of the setup.