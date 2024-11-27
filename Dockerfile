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

# Temporarily disable postinstall scripts and install dependencies
RUN npm_config_ignore_scripts=true npm install --legacy-peer-deps

# Manually execute necessary Grunt tasks
RUN npx grunt exec:fixCryptoApiImports && \
    npx grunt exec:fixSnackbarMarkup && \
    npx grunt exec:fixJimpModule

# Build the production version of CyberChef
RUN npm run build:prod

# Expose a port for hosting
EXPOSE 8080

# Serve the app using a lightweight HTTP server
RUN npm install -g serve
CMD ["serve", "-s", "build"]
