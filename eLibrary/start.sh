#!/bin/bash
cd "$(dirname "$0")"
export PGDATA=data/pgdata
export PGPORT=5412
export PATH="$PWD/postgresql/bin:$PWD/jre/bin:$PATH"

if [ ! -d "$PGDATA" ]; then
    echo "Initializing PostgreSQL..."
    initdb -D "$PGDATA" -U postgres -A trust -E UTF8
    pg_ctl -D "$PGDATA" -l logfile start
    createdb -U postgres elibrary
    psql -U postgres -d elibrary -f data/elibrary.sql
else
    echo "Starting PostgreSQL..."
    pg_ctl -D "$PGDATA" -l logfile start
fi

echo "Starting eLibrary..."
java -jar e-Library.jar
