#!/bin/bash
echo "🔁 Déploiement HomyGo en cours..."
firebase deploy --only hosting
echo "✅ Déploiement terminé. Vérifiez sur https://homygo-cce0d.web.app"
