FROM node:24-alpine

RUN apk update && \
    apk add --no-cache git ffmpeg wget curl bash openssl tzdata

LABEL version="2.3.1" description="Api to control whatsapp features through http requests." 
LABEL maintainer="Davidson Gomes" git="https://github.com/DavidsonGomes"
LABEL contact="contato@evolution-api.com"

WORKDIR /evolution

COPY ./package*.json ./
COPY ./tsconfig.json ./
COPY ./tsup.config.ts ./

RUN npm ci --silent

COPY ./src ./src
COPY ./public ./public
COPY ./prisma ./prisma
COPY ./manager ./manager
COPY ./.env.example ./.env
COPY ./runWithProvider.js ./
COPY ./render-setup.sh ./

# Set environment variables for Render
ENV DATABASE_PROVIDER=postgresql
ENV DATABASE_URL=${DATABASE_URL}
ENV TZ=America/Sao_Paulo
ENV DOCKER_ENV=true

# Make script executable
RUN chmod +x ./render-setup.sh

# Build and setup database
RUN npm run build
RUN ./render-setup.sh

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["npm", "run", "start:prod"]
