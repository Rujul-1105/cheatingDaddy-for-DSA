# Use official Node.js image with Debian for Electron compatibility
FROM node:20-bullseye

# Install system dependencies for Electron and X11
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgtk-3-0 libnss3 libxss1 libasound2 libxtst6 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 \
    libgbm1 libpango-1.0-0 libatk-bridge2.0-0 libgtk-3-0 libxkbcommon0 \
    xvfb xauth x11-apps dumb-init && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install --production

# Copy the rest of the app
COPY . .

# Create a non-root user and use it
RUN useradd --user-group --create-home --shell /bin/false appuser
USER appuser

# Expose display environment variable for Electron
ENV DISPLAY=:99

# Start Xvfb and the Electron app
CMD ["dumb-init", "bash", "-c", "Xvfb :99 -screen 0 1920x1080x24 & npm start"] 