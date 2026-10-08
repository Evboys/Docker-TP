FROM alpine:3.19

# Installation des dépendances OS requises
RUN apk add --no-cache nginx gettext

# Création du dossier d'exécution Nginx et ajustement des permissions
RUN mkdir -p /run/nginx && chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

# Copie des fichiers de configuration et contenus applicatifs
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh
COPY index.html /var/www/html/index.html

RUN chmod +x /entrypoint.sh && chown -R nginx:nginx /var/www/html

USER nginx
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]