#!/bin/bash

source ./Docker/scripts/env_functions.sh

echo "=== generate_database.sh starting ==="

# Always export env vars to ensure DATABASE_PROVIDER is available
export_env_vars

echo "DATABASE_PROVIDER after export_env_vars: '$DATABASE_PROVIDER'"

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" || "$DATABASE_PROVIDER" == "psql_bouncer" ]]; then
    export DATABASE_URL
    echo "Generating database for $DATABASE_PROVIDER"
    echo "Database URL: $DATABASE_URL"
    npm run db:generate
    if [ $? -ne 0 ]; then
        echo "Prisma generate failed"
        exit 1
    else
        echo "Prisma generate succeeded"
    fi
else
    echo "Error: Database provider $DATABASE_PROVIDER invalid."
    exit 1
fi