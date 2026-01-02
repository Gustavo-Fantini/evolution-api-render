#!/bin/bash

# Build script for Render deployment
set -e

echo "🔨 Building Evolution API for Render..."

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --only=production

# Generate Prisma client
echo "🗄️ Generating Prisma client..."
npx prisma generate

# Build the application
echo "🏗️ Building application..."
npm run build

# Run database migrations (if needed)
echo "🔄 Running database migrations..."
npx prisma migrate deploy || echo "No migrations to deploy"

echo "✅ Build completed successfully!"
