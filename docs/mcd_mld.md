# MCD et MLD – UrbanWatt

## MCD (entités, associations, cardinalités)

| Association | Côté 1 | Côté 2 | Justification |
|---|---|---|---|
| Regrouper | STATION (1,N) | BORNE (1,1) | Une station regroupe plusieurs bornes ; une borne est dans une seule station. |
| Posséder | CLIENT (0,N) | VEHICULE (1,1) | Un client peut avoir plusieurs véhicules ; un véhicule a un seul propriétaire. |
| Effectuer | VEHICULE (0,N) | SESSION (1,1) | Un véhicule fait plusieurs recharges ; une session concerne un seul véhicule. |
| Accueillir | BORNE (0,N) | SESSION (1,1) | Une borne accueille plusieurs recharges ; une session a lieu sur une seule borne. |
| Donner lieu | SESSION (0,1) | PAIEMENT (1,1) | Une session a au plus un paiement (une session annulée n'en a pas) ; un paiement concerne une seule session. |
| Subir | BORNE (0,N) | INCIDENT (1,1) | Une borne peut avoir plusieurs incidents ; un incident concerne une seule borne. |
| Faire l'objet | INCIDENT (0,N) | INTERVENTION (1,1) | Un incident peut avoir 0 à N interventions ; une intervention traite un seul incident. |
| Réaliser | TECHNICIEN (0,N) | INTERVENTION (1,1) | Un technicien réalise plusieurs interventions ; une intervention a un seul technicien. |

## MLD (passage au relationnel)

Toutes les associations sont de type 1,N (ou 0,1 pour le paiement) : la clé primaire du côté « 1 » devient une clé étrangère du côté « N ». Aucune table d'association n'est donc nécessaire.

Notation : **clé primaire** soulignée (ici en gras), clé étrangère précédée de #.

- stations (**id_station**, code_station, nom_station, ville, adresse, date_ouverture)
- bornes (**id_borne**, #id_station, code_borne, puissance_kw, connecteur, etat)
- clients (**id_client**, prenom, nom, email, ville, date_inscription)
- vehicules (**id_vehicule**, #id_client, immatriculation, marque, modele, capacite_batterie_kwh)
- sessions_recharge (**id_session**, #id_borne, #id_vehicule, debut_session, fin_session, energie_kwh, cout_eur, statut)
- paiements (**id_paiement**, #id_session, date_paiement, montant_eur, mode_paiement, statut) — id_session est aussi UNIQUE (cardinalité 0,1)
- incidents (**id_incident**, #id_borne, date_signalement, date_resolution, categorie, gravite, statut, description)
- techniciens (**id_technicien**, prenom, nom, email)
- interventions (**id_intervention**, #id_incident, #id_technicien, date_debut, date_fin, statut, compte_rendu)

Le schéma graphique du MLD est dans `mld.png`.

## Normalisation

- **1FN** : chaque colonne contient une seule valeur (pas de liste dans une cellule).
- **2FN** : chaque table a une clé primaire simple (un seul identifiant), donc aucune colonne ne dépend d'une partie seulement de la clé.
- **3FN** : aucune colonne ne dépend d'une autre colonne qui n'est pas la clé. Par exemple, la ville d'une borne n'est pas recopiée dans `bornes` : on la retrouve par la station. Le client d'une session n'est pas stocké dans `sessions_recharge` : on le retrouve par le véhicule.
- `cout_eur` (prix de la recharge) et `montant_eur` (montant du paiement) ne sont pas un doublon : ce sont deux informations différentes. Un paiement peut être refusé ou en attente alors que la recharge a bien un coût.
