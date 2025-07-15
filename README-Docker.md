# Docker Setup for AIDI CMS Strapi

This document provides instructions for running the AIDI CMS Strapi application using Docker.

## Prerequisites

- Docker and Docker Compose installed on your system
- At least 2GB of available RAM
- Ports 1337, 1338, 5434, and 5435 available

## Quick Start

### Production Environment

1. **Generate secure keys** (replace the placeholder keys in `docker-compose.yml`):
   ```bash
   # Generate APP_KEYS (comma-separated)
   openssl rand -base64 32
   
   # Generate other secrets
   openssl rand -base64 32
   ```

2. **Start the application**:
   ```bash
   docker-compose up -d
   ```

3. **Access the application**:
   - Strapi Admin Panel: http://localhost:1337/admin
   - API: http://localhost:1337/api

### Development Environment

1. **Start development environment**:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Access the development application**:
   - Strapi Admin Panel: http://localhost:1338/admin
   - API: http://localhost:1338/api

## Configuration

### Environment Variables

Create a `.env` file based on `env.example` with your configuration:

```bash
# Copy the example file
cp env.example .env

# Edit the .env file with your settings
nano .env
```

Key environment variables:

- `DATABASE_CLIENT`: Database type (postgres)
- `DATABASE_HOST`: Database host (postgres container)
- `DATABASE_PORT`: Database port (5432)
- `DATABASE_NAME`: Database name (aidi-cms)
- `DATABASE_USERNAME`: Database username (aidi-admin)
- `DATABASE_PASSWORD`: Database password
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password
- `NODE_ENV`: Environment (production/development)
- `HOST`: Application host (0.0.0.0)
- `PORT`: Application port (1337)

### Security Keys

For production, replace the placeholder keys in `docker-compose.yml`:

- `APP_KEYS`: Comma-separated list of application keys
- `API_TOKEN_SALT`: Salt for API tokens
- `ADMIN_JWT_SECRET`: JWT secret for admin panel
- `JWT_SECRET`: JWT secret for API
- `TRANSFER_TOKEN_SALT`: Salt for transfer tokens

## Useful Commands

### Production

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f strapi

# Stop services
docker-compose down

# Rebuild and start
docker-compose up -d --build

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v
```

### Development

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f strapi

# Stop development environment
docker-compose -f docker-compose.dev.yml down

# Rebuild development environment
docker-compose -f docker-compose.dev.yml up -d --build
```

### Database Operations

```bash
# Access PostgreSQL shell
docker-compose exec postgres psql -U strapi -d strapi

# Backup database
docker-compose exec postgres pg_dump -U strapi strapi > backup.sql

# Restore database
docker-compose exec -T postgres psql -U strapi -d strapi < backup.sql
```

## Troubleshooting

### Common Issues

1. **Port already in use**:
   - Change the port mappings in docker-compose files
   - Check if other services are using the ports

2. **Database connection issues**:
   - Ensure PostgreSQL container is healthy
   - Check database credentials in environment variables

3. **Permission issues**:
   - Ensure the uploads directory has proper permissions
   - Check file ownership in the container

4. **Memory issues**:
   - Increase Docker memory allocation
   - Check container resource usage: `docker stats`

### Health Checks

Both containers include health checks:
- PostgreSQL: Checks if database is ready to accept connections
- Strapi: Checks if the application is responding on the health endpoint

### Logs

View detailed logs for troubleshooting:
```bash
# Strapi logs
docker-compose logs strapi

# PostgreSQL logs
docker-compose logs postgres

# Follow logs in real-time
docker-compose logs -f
```

## Data Persistence

- **Database**: PostgreSQL data is persisted in a Docker volume
- **Uploads**: File uploads are mounted to `./public/uploads`
- **Configuration**: Config files are mounted for easy updates

## Security Notes

- Change default passwords in production
- Use strong, unique keys for all secrets
- Consider using Docker secrets for sensitive data
- Regularly update base images and dependencies
- Use HTTPS in production environments 