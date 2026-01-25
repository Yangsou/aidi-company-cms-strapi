# Use the official Node.js runtime as the base image
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Create app user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S strapi -u 1001

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production && npm cache clean --force

# Copy built application from build stage
COPY --from=base /app/dist ./dist
COPY --from=base /app/public ./public
COPY --from=base /app/src ./src
COPY --from=base /app/config ./config
COPY --from=base /app/favicon.png ./
COPY --from=base /app/package.json ./

# Create uploads directory
RUN mkdir -p /app/public/uploads

# Change ownership to strapi user
RUN chown -R strapi:nodejs /app

# Entry script that replaces placeholders with env vars
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to strapi user
USER strapi

# Expose port
EXPOSE 1337

# Use our entrypoint (replace the one from Application base image)
ENTRYPOINT ["/entrypoint.sh"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start the application
CMD ["npm", "start"] 

