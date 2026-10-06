const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

app.get('/api', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Backend Node.js Operational'
  });
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend Node.js démarré sur le port ${PORT}`);
});

// Interception et gestion propre du signal SIGTERM
process.on('SIGTERM', () => {
  console.log('Signal SIGTERM reçu : Fermeture propre du serveur Node.js...');
  server.close(() => {
    console.log('Serveur HTTP fermé.');
    process.exit(0);
  });
});
