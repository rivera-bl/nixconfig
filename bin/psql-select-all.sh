#!/bin/sh

# IMPORTANT: export PGPASSWORD with the database password

# psql -h $DNS -p $PORT -U $USER -d $DATABASE
COMMAND=$@

psql -h dependency-track.c0ho0l0mevjf.us-east-1.rds.amazonaws.com -p 5432 -U deptrack -d deptrack -t -c "SELECT 'SELECT * FROM ' || tablename || ';' FROM pg_tables WHERE schemaname = 'public';" > /tmp/tables.sql
$COMMAND -t -c "SELECT 'SELECT COUNT(*) FROM ' || tablename || ';' FROM pg_tables WHERE schemaname = 'public';" > /tmp/select-tables-deptrack.sql

# lee el archivo select.sql y ejecuta cada una de las lineas
while read line; do
  echo "$line"
  $COMMAND -c "$line"
done < /tmp/select-tables-deptrack.sql
