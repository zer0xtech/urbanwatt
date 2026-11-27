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

## Documentation
| Fichier | Contenu |
|---|---|
| `docs/mcd_mld.md` + `docs/mld.png` | Modèle conceptuel et logique, cardinalités, normalisation |
| `docs/dictionnaire_donnees.md` | Toutes les colonnes, types et contraintes |
| `docs/regles_gestion.md` | Les règles métier et leur mise en œuvre |

## Répartition des tâches

| Tâche | Responsable
|---|---|
| Analyse du besoin, règles de gestion | Abdou
| MCD / MLD, dictionnaire de données | Abdou
| Script de création (`01_schema.sql`) | Maxime
| Import des CSV + vérifications | Maxime
| Index + rôle applicatif | Abdou
| Requêtes SQL (Q01 à Q25) | Maxime & Abdou
| Dépôt GitHub | Maxime & Abdou
| Portail web : API + page (`app/`) | Maxime
| Sauvegarde / restauration (pg_dump) | Maxime
| Relecture croisée + préparation de l'oral | Maxime & Abdou
