# Dictionnaire de données – UrbanWatt

Légende : **PK** = clé primaire, **FK** = clé étrangère, **U** = unique, **NN** = obligatoire (NOT NULL).

## stations
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_station | INTEGER | PK | Identifiant de la station |
| code_station | VARCHAR(10) | U, NN | Code métier (ex. ST-LIL) |
| nom_station | VARCHAR(100) | NN | Nom de la station |
| ville | VARCHAR(60) | NN | Ville de la station |
| adresse | VARCHAR(150) | NN | Adresse postale |
| date_ouverture | DATE | | Date de mise en service |

## bornes
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_borne | INTEGER | PK | Identifiant de la borne |
| id_station | INTEGER | FK → stations, NN | Station où se trouve la borne |
| code_borne | VARCHAR(20) | U, NN | Code métier (ex. BR-LIL-01) |
| puissance_kw | NUMERIC(6,2) | NN, > 0 | Puissance de la borne en kW |
| connecteur | VARCHAR(20) | NN | Type de prise (Type2, CCS…) |
| etat | VARCHAR(20) | NN, CHECK | disponible / maintenance / hors_service |

## clients
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_client | INTEGER | PK | Identifiant du client |
| prenom | VARCHAR(50) | NN | Prénom |
| nom | VARCHAR(50) | NN | Nom |
| email | VARCHAR(150) | U, NN | Adresse email (fictive) |
| ville | VARCHAR(60) | | Ville du client |
| date_inscription | DATE | NN | Date d'inscription au service |

## vehicules
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_vehicule | INTEGER | PK | Identifiant du véhicule |
| id_client | INTEGER | FK → clients, NN | Propriétaire du véhicule |
| immatriculation | VARCHAR(20) | U, NN | Plaque (ex. ESSAI-0001) |
| marque | VARCHAR(50) | NN | Marque |
| modele | VARCHAR(50) | NN | Modèle |
| capacite_batterie_kwh | NUMERIC(6,2) | > 0 | Capacité de la batterie en kWh |

## sessions_recharge
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_session | INTEGER | PK | Identifiant de la session de recharge |
| id_borne | INTEGER | FK → bornes, NN | Borne utilisée |
| id_vehicule | INTEGER | FK → vehicules, NN | Véhicule rechargé |
| debut_session | TIMESTAMP | NN | Date et heure de début |
| fin_session | TIMESTAMP | ≥ début | Date et heure de fin (vide si annulée) |
| energie_kwh | NUMERIC(8,2) | ≥ 0 | Énergie délivrée en kWh (vide si annulée) |
| cout_eur | NUMERIC(10,2) | ≥ 0 | Prix de la recharge en € (vide si annulée) |
| statut | VARCHAR(20) | NN, CHECK | terminee / interrompue / annulee |

## paiements
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_paiement | INTEGER | PK | Identifiant du paiement |
| id_session | INTEGER | FK → sessions_recharge, U, NN | Session payée (1 paiement max par session) |
| date_paiement | TIMESTAMP | NN | Date et heure du paiement |
| montant_eur | NUMERIC(10,2) | NN, ≥ 0 | Montant payé en € |
| mode_paiement | VARCHAR(20) | NN | abonnement / carte / application |
| statut | VARCHAR(20) | NN, CHECK | accepte / en_attente / refuse |

## incidents
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_incident | INTEGER | PK | Identifiant de l'incident |
| id_borne | INTEGER | FK → bornes, NN | Borne concernée |
| date_signalement | TIMESTAMP | NN | Date et heure du signalement |
| date_resolution | TIMESTAMP | ≥ signalement | Date et heure de résolution (vide si ouvert) |
| categorie | VARCHAR(30) | NN | Type de panne (defaut_reseau, surchauffe…) |
| gravite | VARCHAR(10) | NN, CHECK | faible / moyenne / haute |
| statut | VARCHAR(10) | NN, CHECK | ouvert / resolu |
| description | TEXT | | Description libre |

## techniciens
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_technicien | INTEGER | PK | Identifiant du technicien |
| prenom | VARCHAR(50) | NN | Prénom |
| nom | VARCHAR(50) | NN | Nom |
| email | VARCHAR(150) | U, NN | Adresse email (fictive) |

## interventions
| Colonne | Type | Contraintes | Signification |
|---|---|---|---|
| id_intervention | INTEGER | PK | Identifiant de l'intervention |
| id_incident | INTEGER | FK → incidents, NN | Incident traité |
| id_technicien | INTEGER | FK → techniciens, NN | Technicien qui intervient |
| date_debut | TIMESTAMP | NN | Début de l'intervention |
| date_fin | TIMESTAMP | ≥ début | Fin de l'intervention (vide si en cours) |
| statut | VARCHAR(20) | NN, CHECK | terminee / en_cours |
| compte_rendu | TEXT | | Compte rendu du technicien |

## Choix des types
- **INTEGER** pour les identifiants : ce sont des numéros entiers fournis par les CSV.
- **NUMERIC** pour les montants, énergies et puissances : calcul exact au centime, sans les erreurs d'arrondi des nombres à virgule flottante.
- **DATE** quand il n'y a qu'un jour, **TIMESTAMP** quand l'heure compte (sessions, paiements, incidents, interventions).
- **VARCHAR(n)** pour les textes courts, **TEXT** pour les descriptions et comptes rendus de longueur libre.
