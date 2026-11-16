# README - Projet URBANWATT

**URBANWATT** est une plateforme centralisée permettant de piloter un réseau de stations de recharge pour véhicules électriques (gestion des bornes, clients, sessions, paiements et incidents).

## Arborescence du dépôt
* **`app/`** : Code source applicatif (API et interface web minimaliste).
* **`docs/`** : Modélisation (MCD/MLD), règles de gestion et documentation des tests.
* **`infra/`** : Configuration (ex: Docker) et variables d'environnement (`.env.example`).
* **`sauvegardes/`** : Procédures et preuves de sauvegarde/restauration de la base.
* **`sql/`** : Scripts de création (`01_schema.sql`), de vérification (`02_verifications.sql`) et requêtes d'analyse (`03_requetes.sql`).

## Démarrage rapide
1. **Configuration** : Cloner le dépôt et configurer les variables dans un fichier `.env` basé sur `infra/.env.example`.
2. **Base de données (PostgreSQL)** :
   * Créer la base `urbanwatt`.
   * Exécuter `sql/01_schema.sql` pour initialiser la structure.
   * Importer les 9 fichiers CSV fournis en respectant l'ordre des clés étrangères.
   * Lancer `sql/02_verifications.sql` pour valider l'import.
3. **Portail Web** : Démarrer l'application depuis le dossier `app/` pour visualiser les stations et les bornes.
