#!/bin/bash

echo "🚀 SCRIPT DE DÉPLOIEMENT HOMYGO – Firebase + GitHub"

# 👉 1. Infos projet
echo "🛠️ Entrez le nom du projet Firebase (ex: homygo-cce0d) :"
read PROJECT_ID

echo "📁 Entrez le nom du dossier local à créer (ex: HomyGO) :"
read PROJECT_DIR

echo "👤 Entrez votre identifiant GitHub (ex: thierrynaud2009) :"
read GITHUB_USER

# 👉 2. Création arborescence + HTML
mkdir -p "$HOME/$PROJECT_DIR/public"
cd "$HOME/$PROJECT_DIR"

echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>'$PROJECT_ID'</title></head><body><h1>Bienvenue sur '$PROJECT_ID'</h1></body></html>' > public/index.html

# 👉 3. Fichier firebase.json
cat <<EOF > firebase.json
{
  "hosting": {
    "public": "public",
    "cleanUrls": true,
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF

# 👉 4. Fichier .firebaserc
cat <<EOF > .firebaserc
{
  "projects": {
    "default": "$PROJECT_ID"
  }
}
EOF

# 👉 5. .gitignore
echo -e "node_modules/\n.firebase/\n.env\n.DS_Store\npublic/*.tmp" > .gitignore

# 👉 6. GitHub Actions CI/CD
mkdir -p .github/workflows
cat <<EOF > .github/workflows/deploy.yml
name: Deploy to Firebase Hosting

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g firebase-tools
      - run: firebase deploy --token \${{ secrets.FIREBASE_TOKEN }}
EOF

# 👉 7. Initialisation Git
git init
git remote add origin https://github.com/$GITHUB_USER/$PROJECT_ID.git
git add .
git commit -m "🚀 Initialisation du projet $PROJECT_ID avec pipeline Firebase"
git branch -M main
git push -u origin main

# 👉 8. Instructions utilisateur
echo "✅ Projet $PROJECT_ID prêt avec pipeline CI/CD Firebase Hosting 🎉"
echo "👉 Ajoute ton secret FIREBASE_TOKEN ici :"
echo "   🔐 https://github.com/$GITHUB_USER/$PROJECT_ID/settings/secrets/actions"
