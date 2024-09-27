# Stage 1: Build Environment
FROM node:18 AS build

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy only package.json and package-lock.json first for caching layer
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy all source code after installing dependencies
COPY . .

# Run build (if your app requires it, like for React/TypeScript)
RUN npm run build

# Stage 2: Production Environment
FROM node:18-slim AS production

# Set environment variables for production
ENV NODE_ENV=production

# Create a non-root user for better security
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set working directory
WORKDIR /usr/src/app

# Copy dependencies and built files from the build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

# Change ownership of the working directory to the non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Switch to non-root user
USER appuser

# Expose the application port (change this if your app runs on a different port)
EXPOSE 3000

# Define the start command
CMD ["npm", "start"]
