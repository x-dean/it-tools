# Start from a lightweight Node.js image
FROM node:18

# Set environment variables
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=2048

# Install necessary dependencies
RUN apt-get update && apt-get install -y git && apt-get clean

# Create a working directory
WORKDIR /app

# Clone the CyberChef repository
RUN git clone https://github.com/gchq/CyberChef.git /app

# Install Grunt CLI globally
RUN npm install -g grunt-cli

# Install project dependencies (including local Grunt)
RUN npm install --legacy-peer-deps

# Debug: List installed packages
RUN npm list --depth=0 || true

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