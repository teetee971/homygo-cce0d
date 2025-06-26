#!/bin/bash
echo "🚀 Push automatique vers GitHub Pages"

# Se placer dans le dossier du projet
cd "$(dirname "$0")"

# Ajouter tous les fichiers
git add .

# Commit avec message horodaté
git commit -m "🔁 Push auto $(date '+%Y-%m-%d %H:%M:%S')"

# Push vers la branche main
git push -f origin main

echo "✅ Push terminé avec succès."
