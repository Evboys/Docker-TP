FROM alpine:3.19

# Installation des dépendances OS requises
RUN apk add --no-cache nginx

# Création du dossier d'exécution Nginx et ajustement des permissions
RUN mkdir -p /run/nginx &&     chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

# Copie des fichiers de configuration et contenus applicatifs
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html

# Droits explicites sur l'application
RUN chown -R nginx:nginx /var/www/html

USER nginx
EXPOSE 8080

# Traitement propre des SIGTERM via Nginx en premier plan
ENTRYPOINT ["nginx", "-g", "daemon off;"]
