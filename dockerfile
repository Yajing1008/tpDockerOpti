# =========================
# Stage 1: builder (Debian)
# =========================
FROM node:latest AS builder
WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

COPY server.js ./server.js


# =========================
# Stage 2: runtime (Alpine)
# =========================
FROM node:alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production

# Install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy the server file
COPY --from=builder /app/server.js ./server.js

EXPOSE 3000
CMD ["node", "server.js"]
