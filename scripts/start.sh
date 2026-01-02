#!/bin/bash

# Start script for Render deployment
set -e

echo "🚀 Starting Evolution API..."

# Wait for database to be ready
echo "⏳ Waiting for database..."
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function checkDb() {
  try {
    await prisma.$queryRaw\`SELECT 1\`;
    console.log('✅ Database is ready');
    await prisma.$disconnect();
  } catch (error) {
    console.log('❌ Database not ready, retrying...');
    setTimeout(checkDb, 2000);
  }
}
checkDb();
"

# Start the application
echo "🌟 Starting application..."
exec node dist/main.js
