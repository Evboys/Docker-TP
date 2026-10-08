#!/bin/sh
# Génère la conf finale depuis le template en injectant les variables d'environnement
envsubst '${BACKEND_HOST} ${BACKEND_PORT}' \
  < /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# exec : nginx devient PID 1 et reçoit SIGTERM
exec nginx -c /tmp/nginx.conf -g 'daemon off;'