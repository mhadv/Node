# Stage 1: Build Environment
FROM node:18 AS build

# Set environment variables for security
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV

# Set working directory inside container
WORKDIR /usr/src/app

# Install dependencies separately for caching
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Run build (e.g., if using a React front-end or compiling TypeScript)
RUN npm run build

# Stage 2: Production Environment
FROM node:18-slim AS production

# Set environment variables for production
ENV NODE_ENV=production

# Use a non-root user for security
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set working directory
WORKDIR /usr/src/app

# Copy dependencies and built files from build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

# Change ownership of the working directory to non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 3000

# Set start command
CMD ["npm", "start"]
