#!/bin/bash
# Exécuté par socat à chaque connexion.

read -r cmd                      # lit la commande envoyée (une ligne)
echo "Hello World ! (commande reçue : $cmd)"