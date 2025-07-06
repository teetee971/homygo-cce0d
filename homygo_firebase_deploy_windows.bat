@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo 🚀 SCRIPT DE DÉPLOIEMENT HOMYGO – Firebase + GitHub (Windows)

set /p PROJECT_ID=🛠️ Entrez le nom du projet Firebase (ex: homygo-cce0d) :
set /p PROJECT_DIR=📁 Entrez le nom du dossier local à créer (ex: HomyGO) :
set /p GITHUB_USER=👤 Entrez votre identifiant GitHub (ex: thierrynaud2009) :

REM Création du dossier et index.html
mkdir %USERPROFILE%\%PROJECT_DIR%\public
cd /d %USERPROFILE%\%PROJECT_DIR%
echo ^<!DOCTYPE html^>^<html^>^<head^>^<meta charset="UTF-8"^>^<title^>%PROJECT_ID%^</title^>^</head^>^<body^>^<h1^>Bienvenue sur %PROJECT_ID%^</h1^>^</body^>^</html^> > public\index.html

REM Création de firebase.json
echo { > firebase.json
echo   "hosting": { >> firebase.json
echo     "public": "public", >> firebase.json
echo     "cleanUrls": true, >> firebase.json
echo     "rewrites": [ >> firebase.json
echo       { >> firebase.json
echo         "source": "**", >> firebase.json
echo         "destination": "/index.html" >> firebase.json
echo       } >> firebase.json
echo     ] >> firebase.json
echo   } >> firebase.json
echo } >> firebase.json

REM .firebaserc
echo { > .firebaserc
echo   "projects": { >> .firebaserc
echo     "default": "%PROJECT_ID%" >> .firebaserc
echo   } >> .firebaserc
echo } >> .firebaserc

REM .gitignore
echo node_modules/> .gitignore
echo .firebase/>> .gitignore
echo .env>> .gitignore
echo public\*.tmp>> .gitignore

REM GitHub Actions
mkdir .github\workflows
(
echo name: 🚀 Deploy to Firebase Hosting
echo.
echo on:
echo ^  push:
echo ^    branches:
echo ^      - main
echo.
echo jobs:
echo ^  deploy:
echo ^    runs-on: ubuntu-latest
echo ^    steps:
echo ^      - uses: actions/checkout@v4
echo ^      - name: Install Firebase CLI
echo ^        run: npm install -g firebase-tools
echo ^      - name: Deploy to Firebase
echo ^        run: firebase deploy --token ${{ secrets.FIREBASE_TOKEN }}
) > .github\workflows\deploy.yml

REM Initialisation Git
git init
git remote add origin https://github.com/%GITHUB_USER%/%PROJECT_ID%.git
git add .
git commit -m "🚀 Initialisation de %PROJECT_ID% avec Firebase + GitHub CI"
git branch -M main
git push -u origin main

echo ✅ Projet %PROJECT_ID% prêt avec CI/CD Firebase Hosting
echo 👉 Ajoute ton secret FIREBASE_TOKEN ici :
echo 🔐 https://github.com/%GITHUB_USER%/%PROJECT_ID%/settings/secrets/actions

ENDLOCAL
