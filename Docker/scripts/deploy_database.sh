#!/bin/bash

source ./Docker/scripts/env_functions.sh

# Debug: Verificar variáveis de ambiente
echo "=== DEBUG: deploy_database.sh ==="
echo "DOCKER_ENV: $DOCKER_ENV"
echo "DATABASE_PROVIDER (antes): '$DATABASE_PROVIDER'"
echo "DATABASE_URL: '$DATABASE_URL'"
echo "Current directory: $(pwd)"
echo "Files in current directory:"
ls -la
echo "=== END DEBUG ==="

# Always export env vars to ensure DATABASE_PROVIDER is available
export_env_vars

# Debug: Verificar variáveis após export_env_vars
echo "=== DEBUG: após export_env_vars ==="
echo "DATABASE_PROVIDER (depois): '$DATABASE_PROVIDER'"
echo "DATABASE_URL (depois): '$DATABASE_URL'"
echo "=== END DEBUG ==="

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" || "$DATABASE_PROVIDER" == "psql_bouncer" ]]; then
    export DATABASE_URL
    echo "Deploying migrations for $DATABASE_PROVIDER"
    echo "Database URL: $DATABASE_URL"
    # rm -rf ./prisma/migrations
    # cp -r ./prisma/$DATABASE_PROVIDER-migrations ./prisma/migrations
    npm run db:deploy
    if [ $? -ne 0 ]; then
        echo "Migration failed"
        exit 1
    else
        echo "Migration succeeded"
    fi
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
