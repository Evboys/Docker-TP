# TP Docker Cloud - Architecture Virtualisée Intégrale

Ce projet implémente un cloud minimaliste constitué de 3 conteneurs customisés, construits de zéro sans dépendre directement d'images pré-construites applicatives d'un Registry public (utilisation de l'image de base OS minimaliste Alpine).

## 1. Justification des choix au Build (Dockerfiles)

### Image Front (Nginx)
- **Dépendances :** `alpine:3.19` (OS minimal < 5 Mo), `nginx` (serveur web léger).
- **Opérations OS :** Création du répertoire `/run/nginx` requis par Alpine pour stocker le PID du processus. Bascule sur l'utilisateur non-privilégié `nginx`.
- **Port ouvert :** `8080` (choisi au-dessus de 1024 pour permettre l'exécution en mode non-root).
- **Entrypoint :** `nginx -g "daemon off;"` pour forcer Nginx à s'exécuter au premier plan et recevoir directement les signaux de processus de Docker.

### Image Back (Node.js / Express)
- **Dépendances :** `alpine:3.19` (OS minimal < 5 Mo), `nodejs`, `npm`, `express`.
- **Opérations OS :** `adduser -D -u 1000 nodeuser` pour exécuter le runtime Node sous un compte sans privilèges d'administration.
- **Port ouvert :** `5000` (port d'écoute de l'API Node.js).
- **Entrypoint :** `ENTRYPOINT ["node", "server.js"]`. Le format JSON (Exec form) lance directement le binaire `node` avec le PID 1.
- **Gestion du SIGTERM :** Dans `server.js`, l'événement `process.on('SIGTERM', ...)` intercepte le signal envoyé par Docker à l'arrêt du conteneur et appelle `server.close()` pour achever proprement le traitement des requêtes en cours avant de quitter (`process.exit(0)`).

### Image Serveur de Jeu (Netcat / Bash)
- **Dépendances :** `netcat-openbsd` (sockets TCP), `bash`.
- **Opérations OS :** Création d'un script `server.sh` exécutable et ajout d'un utilisateur `gameuser`.
- **Port ouvert :** `7777` (port TCP dédié au serveur de jeu).
- **Entrypoint :** Script shell `/game/server.sh` avec gestion explicite via `trap` du signal `SIGTERM`.

---

## 2. Configuration au Run et Ressources (`docker-compose.yml`)

### Allocation des Ressources
Chaque conteneur dispose de restrictions strictes afin d'éviter la monopolisation de l'hôte :
- **Frontend :** Limit = 0.25 CPU / 128 Mo. *Justification : Rendu de fichiers statiques léger.*
- **Backend :** Limit = 0.50 CPU / 256 Mo. *Justification : Traitement des requêtes dynamiques Node.js.*
- **Game Server :** Limit = 1.00 CPU / 512 Mo. *Justification : Calcul de boucle de jeu temps réel.*

### Ordre de démarrage (Dépendances)
L'option `depends_on` couplée au `healthcheck` garantit que :
1. Le **Backend** démarré et valide son état de santé via le test du port 5000.
2. Le **Frontend** et le **Game Server** ne démarrent que lorsque l'API backend est prête à recevoir du trafic.

### Gestion des SIGTERM (Arrêt propre)
L'utilisation de `stop_signal: SIGTERM` combinée à la forme "Exec" des `ENTRYPOINT` ou l'usage de `trap` dans les scripts garantit la réception correcte du signal `SIGTERM` pour fermer les connexions réseau actives avant l'arrêt complet du conteneur.

---

## 3. Comparatif : Docker vs Virtualisation Historique (VMs)

| Critère | Virtualisation Classique (Type 2 / Hyperviseur) | Conteneurisation (Docker) |
| :--- | :--- | :--- |
| **Isolation** | Matérielle (OS complet embarqué par VM) | Isolation processus au niveau du Kernel hôte (cgroups/namespaces) |
| **Poids des images** | Plusieurs Gigaoctets (GB) | Quelques Mégaoctets (MB) |
| **Temps de démarrage**| Plusieurs minutes | Quelques millisecondes |
| **Consommation** | Empreinte mémoire et CPU élevée | Légère, partage des ressources de l'hôte |
