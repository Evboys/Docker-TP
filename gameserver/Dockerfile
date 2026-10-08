FROM alpine:3.19

# bash = scripts ; socat = serveur TCP multi-connexions ; netcat-openbsd = healthcheck (nc -z)
RUN apk add --no-cache bash socat netcat-openbsd

# Utilisateur sans privilèges
RUN adduser -D -u 1000 gameuser

# Scripts du jeu
WORKDIR /game
COPY server.sh handler.sh ./
RUN chmod +x /game/server.sh /game/handler.sh

RUN mkdir -p /data && chown gameuser:gameuser /data

USER gameuser
EXPOSE 7777

ENTRYPOINT ["/game/server.sh"]