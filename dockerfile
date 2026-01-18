# =========================
# Stage 1: builder
# =========================
FROM node:latest AS builder
WORKDIR /app

# System dependencies required for native npm modules
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install all dependencies (including dev)
COPY package*.json ./
RUN npm install

# Copy application source
COPY server.js ./server.js


# =========================
# Stage 2: runtime
# =========================
FROM node:latest AS runtime
WORKDIR /app

ENV NODE_ENV=production

# Install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy application code from builder
COPY --from=builder /app/server.js ./server.js

EXPOSE 3000
CMD ["node", "server.js"]
