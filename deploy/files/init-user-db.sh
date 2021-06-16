#!/bin/bash
set -e

# "CREATE DATABASE IF NOT EXISTS" hack (https://zaiste.net/databases/postgresql/howtos/create-database-if-not-exists/)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-_SQL_
SELECT 'CREATE DATABASE todos'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'todos')\gexec
_SQL_

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-_SQL_
    CREATE USER flask WITH PASSWORD '$POSTGRES_APP_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE todos TO flask ;
_SQL_
