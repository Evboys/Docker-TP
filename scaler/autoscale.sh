#!/bin/sh
# ============================================================
# Autoscaler basé sur le socket Docker pour le service 'backend'
# ============================================================

SERVICE="backend"
MIN_REPLICAS=1
MAX_REPLICAS=5
CPU_SCALE_UP=80           # Pourcentage CPU pour augmenter
CPU_SCALE_DOWN=10         # Pourcentage CPU pour réduire
SLEEP=10                  # Intervalle en secondes

echo "Démarrage de l'autoscaler pour le service : ${SERVICE}"

while true; do
  # Nombre actuel de réplicas du backend
  REPLICAS=$(docker ps --filter "name=cloud_backend" --filter "status=running" -q | wc -l)
  [ "$REPLICAS" -eq 0 ] && REPLICAS=1

  # Récupération de la consommation CPU cumulée
  TOTAL_CPU=$(docker stats --no-stream --format "{{.Name}} {{.CPUPerc}}" 2>/dev/null \
    | grep "cloud_backend" \
    | awk '{gsub(/%/,"",$2); sum+=$2} END {print int(sum)}')

  TOTAL_CPU=${TOTAL_CPU:-0}

  echo "$(date) - CPU=${TOTAL_CPU}% | replicas=${REPLICAS}"

  # Augmentation des réplicas si CPU > 80%
  if [ "$TOTAL_CPU" -gt "$CPU_SCALE_UP" ] && [ "$REPLICAS" -lt "$MAX_REPLICAS" ]; then
    NEW=$((REPLICAS + 1))
    echo "🔥 Scaling UP → $NEW réplicas"
    docker compose -f /src/docker-compose.yml up -d --scale ${SERVICE}=$NEW 2>/dev/null || true
  fi

  # Réduction des réplicas si CPU < 10%
  if [ "$TOTAL_CPU" -lt "$CPU_SCALE_DOWN" ] && [ "$REPLICAS" -gt "$MIN_REPLICAS" ]; then
    NEW=$((REPLICAS - 1))
    echo "⬇️ Scaling DOWN → $NEW réplicas"
    docker compose -f /src/docker-compose.yml up -d --scale ${SERVICE}=$NEW 2>/dev/null || true
  fi

  sleep $SLEEP
done