#!/bin/sh
set -e

cp ./env.example ./.env
# Update DB connection settings in .env
sed -i "s|__DATABASE_HOST__|${AZURE_POSTGRESQL_HOST}|g" ./.env
sed -i "s|__DATABASE_NAME__|${AZURE_POSTGRESQL_DATABASE}|g" ./.env
sed -i "s|__DATABASE_PORT__|${AZURE_POSTGRESQL_PORT}|g" ./.env
sed -i "s|__DATABASE_USERNAME__|${AZURE_POSTGRESQL_USERNAME}|g" ./.env
sed -i "s|__DATABASE_PASSWORD__|${AZURE_POSTGRESQL_PASSWORD}|g" ./.env

# Update JWT Token settings in .env    

sed -i "s|__CWEB_APP_KEYS__|${CWEB_APP_KEYS}|g" ./.env
sed -i "s|__CWEB_API_TOKEN_SALT__|${CWEB_API_TOKEN_SALT}|g" ./.env
sed -i "s|__CWEB_ADMIN_JWT_SECRET__|${CWEB_ADMIN_JWT_SECRET}|g" ./.env
sed -i "s|__CWEB_JWT_SECRET__|${CWEB_JWT_SECRET}|g" ./.env
sed -i "s|__CWEB_TRANSFER_TOKEN_SALT__|${CWEB_TRANSFER_TOKEN_SALT}|g" ./.env
sed -i "s|__CWEB_ENCRYPTION_KEY__|${CWEB_ENCRYPTION_KEY}|g" ./.env

# Update Email settings in .env

sed -i "s|__INIT_ADMIN_USERNAME__|${INIT_ADMIN_USERNAME}|g" ./.env
sed -i "s|__INIT_ADMIN_PASSWORD__|${INIT_ADMIN_PASSWORD}|g" ./.env

exec "$@"
