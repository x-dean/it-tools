# Start from a lightweight Node.js image
FROM node:18

# Set environment variables
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=2048

# Install necessary dependencies (git)
RUN apt-get update && apt-get install -y git && apt-get clean

# Create a working directory
WORKDIR /app

# Clone the CyberChef repository
RUN git clone https://github.com/gchq/CyberChef.git /app

# Debug: Check if repo was cloned successfully
RUN ls /app || true

# Install global Grunt CLI
RUN npm install -g grunt-cli

# Run npm install with more logging and suppression of certain warnings
RUN npm install --legacy-peer-deps --no-audit --no-fund || true

# Debug: List installed packages
RUN npm list --depth=0 || true

# Check for specific missing dependencies
RUN npm ls grunt || true
RUN npm ls grunt-cli || true

# Manually execute necessary Grunt tasks
RUN ./node_modules/.bin/grunt exec:fixCryptoApiImports && \
    ./node_modules/.bin/grunt exec:fixSnackbarMarkup && \
    ./node_modules/.bin/grunt exec:fixJimpModule

# Build the production version of CyberChef
RUN npm run build:prod

# Expose a port for hosting
EXPOSE 8080

# Serve the app using a lightweight HTTP server
RUN npm install -g serve
CMD ["serve", "-s", "build"]