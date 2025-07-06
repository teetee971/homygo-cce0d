@echo off
echo 🔁 Déploiement multi-environnement HomyGo
echo → Déploiement STAGING
firebase use --add
firebase deploy --only hosting --project=homygo-staging
echo.
echo → Déploiement PRODUCTION
firebase deploy --only hosting --project=homygo-cce0d
echo ✅ Déploiement terminé
pause
