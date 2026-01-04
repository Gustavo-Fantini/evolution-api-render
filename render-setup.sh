#!/bin/bash

# Simple database setup for Render
echo "Setting up database for Render..."

# Set DATABASE_PROVIDER if not set
if [ -z "$DATABASE_PROVIDER" ]; then
    export DATABASE_PROVIDER=postgresql
fi

echo "DATABASE_PROVIDER: $DATABASE_PROVIDER"
echo "DATABASE_URL configured: ${DATABASE_URL:+yes}"

# Generate Prisma client
echo "Generating Prisma client..."
npx prisma generate --schema ./prisma/postgresql-schema.prisma

if [ $? -ne 0 ]; then
    echo "Prisma generate failed"
    exit 1
fi

echo "Prisma client generated successfully"

# Deploy migrations
echo "Deploying database migrations..."
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

if [ $? -ne 0 ]; then
    echo "Migration deploy failed"
    exit 1
fi

echo "Database migrations deployed successfully"
