# AIDI CMS Strapi Makefile
# Common commands for development and deployment

.PHONY: help install dev build start clean seed upgrade upgrade-dry logs console deploy env-setup docker-build docker-run docker-stop backup restore restore-file health d s b c db-reset docker-up docker-down docker-dev-up docker-dev-down seed-docker-dev seed-docker-prod first-run-dev first-run-prod

# Default target
help:
	@echo "AIDI CMS Strapi - Available Commands:"
	@echo ""
	@echo "Development:"
	@echo "  make install    - Install dependencies"
	@echo "  make dev        - Start development server"
	@echo "  make build      - Build for production"
	@echo "  make start      - Start production server"
	@echo "  make clean      - Clean build artifacts"
	@echo ""
	@echo "Docker Compose:"
	@echo "  make docker-up        - Start production Docker Compose (docker-compose.yml)"
	@echo "  make docker-down      - Stop production Docker Compose"
	@echo "  make docker-dev-up    - Start development Docker Compose (docker-compose.dev.yml)"
	@echo "  make docker-dev-down  - Stop development Docker Compose"
	@echo ""
	@echo "Database:"
	@echo "  make seed             - Run database seeding (local)"
	@echo "  make seed-docker-dev  - Run database seeding (development container)"
	@echo "  make seed-docker-prod - Run database seeding (production container)"
	@echo "  make db-reset         - Reset database (SQLite only)"
	@echo ""
	@echo "Setup:"
	@echo "  make first-run-dev    - First time setup with seed data (development)"
	@echo "  make first-run-prod   - First time setup with seed data (production)"
	@echo ""
	@echo "Maintenance:"
	@echo "  make upgrade    - Upgrade Strapi to latest version"
	@echo "  make upgrade-dry - Dry run of upgrade"
	@echo "  make logs       - Show application logs"
	@echo ""
	@echo "Utilities:"
	@echo "  make console    - Open Strapi console"
	@echo "  make deploy     - Deploy application"

# Development commands
install:
	@echo "Installing dependencies..."
	npm install

dev:
	@echo "Starting development server..."
	npm run dev

build:
	@echo "Building for production..."
	npm run build

start:
	@echo "Starting production server..."
	npm run start

clean:
	@echo "Cleaning build artifacts..."
	rm -rf .tmp
	rm -rf build
	rm -rf dist
	@echo "Clean complete!"

# Database commands
seed:
	@echo "Running database seeding (local)..."
	npm run seed:example

db-reset:
	@echo "Resetting SQLite database..."
	rm -f .tmp/data.db
	@echo "Database reset complete!"

# Maintenance commands
upgrade:
	@echo "Upgrading Strapi to latest version..."
	npm run upgrade

upgrade-dry:
	@echo "Running upgrade dry run..."
	npm run upgrade:dry

logs:
	@echo "Showing application logs..."
	tail -f .tmp/logs/*.log

# Utility commands
console:
	@echo "Opening Strapi console..."
	npm run console

deploy:
	@echo "Deploying application..."
	npm run deploy

# Environment setup
env-setup:
	@echo "Setting up environment variables..."
	@if [ ! -f .env ]; then \
		echo "Creating .env file from env.example..."; \
		cp env.example .env 2>/dev/null || echo "No env.example found, creating basic .env..."; \
		echo "Basic .env file created. Please review and update as needed."; \
	else \
		echo ".env file already exists."; \
	fi

# Docker commands
docker-build:
	@echo "Building Docker image..."
	docker build -t aidi-cms-strapi .

docker-run:
	@echo "Running Docker container..."
	docker run -p 1337:1337 aidi-cms-strapi

docker-stop:
	@echo "Stopping Docker containers..."
	docker stop $$(docker ps -q --filter ancestor=aidi-cms-strapi)

# Docker Compose commands
docker-up:
	@echo "Starting production Docker Compose..."
	docker compose up -d

docker-down:
	@echo "Stopping production Docker Compose..."
	docker compose down

docker-dev-up:
	@echo "Starting development Docker Compose..."
	docker compose -f docker-compose.dev.yml up -d

docker-dev-down:
	@echo "Stopping development Docker Compose..."
	docker compose -f docker-compose.dev.yml down

# Seed data in Docker containers
seed-docker-dev:
	@echo "Running seed data in development container..."
	@docker compose -f docker-compose.dev.yml exec strapi npm run seed:example || \
		echo "Container not ready. Please ensure containers are running with 'make docker-dev-up'"

seed-docker-prod:
	@echo "Running seed data in production container..."
	@docker compose exec strapi npm run seed:example || \
		echo "Container not ready. Please ensure containers are running with 'make docker-up'"

# First time setup with seed data
first-run-dev:
	@echo "Setting up development environment with seed data..."
	make docker-dev-up
	@echo "Waiting for containers to be ready..."
	@sleep 30
	make seed-docker-dev
	@echo "Development environment ready! Access at http://localhost:1338/admin"

first-run-prod:
	@echo "Setting up production environment with seed data..."
	make docker-up
	@echo "Waiting for containers to be ready..."
	@sleep 30
	make seed-docker-prod
	@echo "Production environment ready! Access at http://localhost:1337/admin"

# Backup and restore
backup:
	@echo "Creating backup..."
	@mkdir -p backups
	tar -czf backups/backup-$$(date +%Y%m%d-%H%M%S).tar.gz data/ config/ src/ package.json

restore:
	@echo "Available backups:"
	@ls -la backups/
	@echo "To restore, use: make restore-file file=backup-filename.tar.gz"

restore-file:
	@if [ -z "$(file)" ]; then \
		echo "Please specify backup file: make restore-file file=backup-filename.tar.gz"; \
		exit 1; \
	fi
	@echo "Restoring from $(file)..."
	tar -xzf backups/$(file)
	@echo "Restore complete!"

# Health check
health:
	@echo "Checking application health..."
	@curl -f http://localhost:1337/_health || echo "Application is not running or health check failed"

# Development shortcuts
d: dev
s: start
b: build
c: clean

# Fix lock file issues
fix-lock:
	@echo "Fixing package-lock.json..."
	rm -f package-lock.json
	npm install
	@echo "Lock file fixed!"

# Open browser
open-dev:
	@echo "Opening development admin panel..."
	open http://localhost:1338/admin

open-prod:
	@echo "Opening production admin panel..."
	open http://localhost:1337/admin
