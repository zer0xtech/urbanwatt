# README - Projet URBANWATT

**URBANWATT** est une plateforme centralisée permettant de piloter un réseau de stations de recharge pour véhicules électriques (gestion des bornes, clients, sessions, paiements et incidents)[cite: 1, 2, 3].

## Arborescence du dépôt
* **`app/`** : Code source applicatif (API et interface web minimaliste)[cite: 12, 18].
* **`docs/`** : Modélisation (MCD/MLD), règles de gestion et documentation des tests[cite: 8, 18].
* **`infra/`** : Configuration (ex: Docker) et variables d'environnement (`.env.example`)[cite: 13, 18].
* **`sauvegardes/`** : Procédures et preuves de sauvegarde/restauration de la base[cite: 13, 18].
* **`sql/`** : Scripts de création (`01_schema.sql`), de vérification (`02_verifications.sql`) et requêtes d'analyse (`03_requetes.sql`)[cite: 9, 10, 11, 18].

## Démarrage rapide
1. **Configuration** : Cloner le dépôt et configurer les variables dans un fichier `.env` basé sur `infra/.env.example`[cite: 7, 13].
2. **Base de données (PostgreSQL)** :
   * Créer la base `urbanwatt`[cite: 9].
   * Exécuter `sql/01_schema.sql` pour initialiser la structure[cite: 9].
   * Importer les 9 fichiers CSV fournis en respectant l'ordre des clés étrangères[cite: 4, 9].
   * Lancer `sql/02_verifications.sql` pour valider l'import[cite: 10].
3. **Portail Web** : Démarrer l'application depuis le dossier `app/` pour visualiser les stations et les bornes[cite: 12, 18].