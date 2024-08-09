# Start from the base image
FROM node:20-alpine

# Install necessary packages
RUN apk add --update libc6-compat python3 make g++ git
RUN apk add --no-cache build-base cairo-dev pango-dev

# Install Chromium
RUN apk add --no-cache chromium

# Install PNPM globally
RUN npm install -g pnpm

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV NODE_OPTIONS=--max-old-space-size=8192

# Set working directory
WORKDIR /usr/src

# Clone your forked repository
RUN git clone https://github.com/aarons3737/flowise.git .

# Add the upstream repository and fetch the latest changes
RUN git remote add upstream https://github.com/FlowiseAI/flowise.git \
    && git fetch upstream \
    && git merge upstream/main

# Install dependencies
RUN pnpm install

# Build the application
RUN pnpm build

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD [ "pnpm", "start" ]
