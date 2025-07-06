Instructions pour GitHub Auto Deploy Firebase (HomyGO)

1. Crée un dépôt GitHub (ou utilise ton repo actuel)
2. Ajoute ce dossier .github/workflows/firebase-hosting.yml à la racine
3. Dans GitHub > Settings > Secrets > Actions :
   ➤ Crée un secret nommé FIREBASE_TOKEN
   ➤ Colle-y la clé obtenue avec `firebase login:ci`
4. Pousse sur la branche `main` → auto-deploy Firebase Hosting activé !