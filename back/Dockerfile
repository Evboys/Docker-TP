FROM alpine:3.19

# Installation de Node.js et npm sur la base OS Alpine
RUN apk add --no-cache nodejs npm

# Création d'un utilisateur non-root pour la sécurité
RUN adduser -D -u 1000 nodeuser

WORKDIR /app

# Copie des définitions de dépendances et installation
COPY package.json /app/package.json
RUN npm install --only=production --no-audit

# Copie du code applicatif
COPY server.js /app/server.js
RUN chown -R nodeuser:nodeuser /app

USER nodeuser
EXPOSE 5000

# Utilisation d'un tableau d'arguments pour démarrer directement Node (PID 1)
ENTRYPOINT ["node", "server.js"]
