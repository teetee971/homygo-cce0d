#!/bin/bash
echo "🔁 Déploiement multi-environnement HomyGo"
echo "→ Déploiement sur la version STAGING (homygo-staging)"
firebase use --add
firebase deploy --only hosting --project=homygo-staging
echo ""
echo "→ Déploiement sur la version PRODUCTION (homygo-cce0d)"
firebase deploy --only hosting --project=homygo-cce0d
echo "✅ Déploiement multi-environnement terminé"
