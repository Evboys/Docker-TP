#!/bin/bash

# Trap du signal SIGTERM pour arrêt propre du container
trap 'echo "Signal SIGTERM reçu, arrêt du serveur de jeu..."; exit 0' SIGTERM

echo "Game Server démarré sur le port 7777..."

while true; do
  # Écoute les requêtes entrantes
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nGame Server Active" | nc -l -p 7777 &
  wait $!
done
