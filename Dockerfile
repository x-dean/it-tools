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

# Install dependencies
RUN npm install

# Build the production version of CyberChef
RUN npm run build:prod

# Expose a port for hosting (optional)
EXPOSE 8080

# Serve the app using a lightweight HTTP server
RUN npm install -g serve
CMD ["serve", "-s", "build"]