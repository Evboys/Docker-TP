#!/bin/bash

# Lance socat : il écoute sur le port et crée un handler.sh PAR connexion.
PORT=${GAMESERVER_PORT:-7777}

echo "Game Server démarré sur le port $PORT..."
socat TCP-LISTEN:$PORT,fork,reuseaddr EXEC:/game/handler.sh &
SOCAT_PID=$!

# Arrêt propre sur SIGTERM/SIGINT
trap 'echo "SIGTERM reçu. Arrêt du serveur de jeu..."; kill $SOCAT_PID; exit 0' SIGTERM SIGINT

wait $SOCAT_PID