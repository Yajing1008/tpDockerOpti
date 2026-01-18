FROM node:latest

WORKDIR /app

# (1) Installer les dépendances système AVANT npm install
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential ca-certificates locales \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen \
 && rm -rf /var/lib/apt/lists/*

# (2) Copier uniquement les fichiers de dépendances pour profiter du cache Docker
COPY package*.json ./

# (3) Installer les dépendances
RUN npm install

# (4) Copier le reste du projet
COPY . .

EXPOSE 3000 4000 5000
ENV NODE_ENV=development

# (5) Build (si nécessaire pour ton projet)
RUN npm run build

CMD ["node", "server.js"]
