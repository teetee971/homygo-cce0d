# HomyGo

HomyGo est actuellement structuré dans ce dépôt comme un site statique/PWA déployé sur Firebase Hosting.

## Qualité et CI

Le workflow `.github/workflows/ci.yml` s'exécute sur les pushes, les pull requests, les groupes de merge et à la demande. Il vérifie :

- la cohérence des fichiers HTML et de leurs ressources locales ;
- l'absence de placeholders connus ;
- la validité de `firebase.json`, `.firebaserc` et du manifeste PWA ;
- les icônes PWA ;
- la syntaxe JavaScript ;
- la disponibilité de Firebase CLI.

## Déploiement

Le workflow `.github/workflows/firebase-hosting.yml` déploie automatiquement `public/` sur Firebase Hosting après une modification pertinente de `main`.

Authentification recommandée :

- secret GitHub `FIREBASE_SERVICE_ACCOUNT` contenant le JSON du compte de service Firebase.

Compatibilité conservée :

- secret `FIREBASE_TOKEN` comme solution de secours.

Projet Firebase : `homygo-cce0d`.

## Sécurité Firestore

Le dépôt ne contient actuellement aucun flux applicatif Firestore actif. Les règles `firestore.rules` sont donc fermées par défaut. Elles devront être remplacées par des règles par utilisateur et testées avant toute activation d'un stockage Firestore.

## PWA

Le manifeste et le Service Worker se trouvent dans `public/`. Le site peut être installé comme PWA sur les navigateurs compatibles.
