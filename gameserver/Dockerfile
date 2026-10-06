FROM alpine:3.19

# Installation de Netcat (nc) et Bash pour écouter sur un port TCP
RUN apk add --no-cache netcat-openbsd bash

WORKDIR /game
COPY server.sh /game/server.sh
RUN chmod +x /game/server.sh

# Création d'un utilisateur dédié
RUN adduser -D -u 1001 gameuser
USER gameuser

EXPOSE 7777

# Utilisation de exec dans un script shell pour intercepter SIGTERM
ENTRYPOINT ["/game/server.sh"]
