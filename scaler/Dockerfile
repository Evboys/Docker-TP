FROM alpine:3.19

# Installation des dépendances CLI Docker pour que le script puisse interagir avec l'hôte
RUN apk add --no-cache docker-cli bash curl

WORKDIR /
COPY autoscale.sh /autoscale.sh
RUN chmod +x /autoscale.sh

CMD ["/autoscale.sh"]