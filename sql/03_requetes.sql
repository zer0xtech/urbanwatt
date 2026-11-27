-- Question 1
-- Tous les clients qui ont rechargé leur véhicule à la station ST-LIL
SELECT DISTINCT clients.id_client, clients.prenom, clients.nom
FROM clients
LEFT JOIN vehicules ON vehicules.id_client = clients.id_client
LEFT JOIN sessions_recharge ON sessions_recharge.id_vehicule = vehicules.id_vehicule
LEFT JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
LEFT JOIN stations ON stations.id_station = bornes.id_borne
WHERE stations.code_station = 'ST-LIL'
ORDER BY clients.nom, clients.prenom

-- Question 2
-- Liste toutes les bornes de la station ST-TOU avec leur informations (état, puissance kw, etc)
SELECT code_borne, puissance_kw, connecteur, etat
FROM bornes
LEFT JOIN stations ON stations.id_station = bornes.id_station
WHERE stations.code_station = 'ST-TOU'
ORDER BY puissance_kw DESC

-- Question 3
-- Affiche l'historique des sessions de charge du véhicule ESSAI-0001 avec les données qui correspondent
SELECT id_borne, debut_session, fin_session, energie_kwh, cout_eur, statut
FROM sessions_recharge
LEFT JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule 
WHERE vehicules.immatriculation = 'ESSAI-0001'
ORDER BY debut_session DESC 

-- Question 4
-- Affiche tous les clients qui n'ont jamais eu de sessions de charge annulées ou interrompues
SELECT clients.id_client, clients.nom, clients.prenom
FROM clients
WHERE clients.id_client NOT IN (
	SELECT vehicules.id_client
	FROM vehicules
	LEFT JOIN sessions_recharge ON sessions_recharge.id_vehicule = vehicules.id_vehicule
	WHERE sessions_recharge.statut IN ('annulee', 'interrompue')
)
ORDER BY clients.id_client

-- Question 5
-- Affiche toutes les sessions de charge terminées dans la station ST-LYO triées par énérgie 
SELECT sessions_recharge.id_session, sessions_recharge.statut, sessions_recharge.energie_kwh
FROM sessions_recharge
LEFT JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne 
LEFT JOIN stations ON stations.id_station = bornes.id_station
WHERE stations.code_station = 'ST-LYO' AND sessions_recharge.statut = 'terminee'
ORDER BY sessions_recharge.energie_kwh 

-- Question 6
-- Affiche toutes les sessions de recharge du client numéro 10 et avec quel véhicule, quelle station, quelle date, etc..
SELECT vehicules.immatriculation, sessions_recharge.debut_session, sessions_recharge.fin_session, sessions_recharge.id_vehicule
FROM sessions_recharge
LEFT JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule
LEFT JOIN clients ON clients.id_client = vehicules.id_client
WHERE clients.id_client = 10

-- Question 7
-- Affiche tous les incidents qui sont graves en indiquant quelle borne, quelle station, la date de signalement et l'état de résolution
SELECT bornes.code_borne, stations.code_station, incidents.gravite, incidents.date_signalement, incidents.statut
FROM incidents
LEFT JOIN bornes ON bornes.id_borne = incidents.id_borne
LEFT JOIN stations ON stations.id_station = bornes.id_station
WHERE incidents.gravite = 'haute'

-- Question 8
-- Affiche tous les incidents qui sont arrivées à la station ST-BOR par date décroissante
SELECT incidents.id_incident, incidents.description, incidents.date_signalement
FROM incidents
LEFT JOIN bornes ON bornes.id_borne = incidents.id_borne
LEFT JOIN stations ON stations.id_station = bornes.id_station
WHERE stations.code_station = 'ST-BOR'
ORDER BY incidents.date_signalement DESC

-- Question 9
-- Liste toutes les sessions de recharche qui ont été annulées ou interrompues à la station ST-NAN
SELECT sessions_recharge.id_session, sessions_recharge.statut, vehicules.immatriculation, sessions_recharge.debut_session
FROM sessions_recharge
LEFT JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule
LEFT JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
LEFT JOIN stations ON stations.id_station = bornes.id_station
WHERE stations.code_station = 'ST-NAN' AND sessions_recharge.statut IN ('annulee', 'interrompue') 

-- Question 10
-- Liste tous les clients qui ont réalisé une session de recharge de plus de 30kWh
SELECT DISTINCT clients.id_client, clients.nom, clients.prenom
FROM clients
LEFT JOIN vehicules ON vehicules.id_client = clients.id_client
LEFT JOIN sessions_recharge ON sessions_recharge.id_vehicule = vehicules.id_vehicule
WHERE sessions_recharge.energie_kwh > '30'

-- Question 11
-- Affiche le nombre de bornes disponibles, en maintenance et hors service pour chaque station
SELECT st.code_station, st.nom_station,
       COUNT(b.id_borne) FILTER (WHERE b.etat = 'disponible')   AS fonctionnel,
       COUNT(b.id_borne) FILTER (WHERE b.etat = 'maintenance')  AS en_maintenance,
       COUNT(b.id_borne) FILTER (WHERE b.etat = 'hors_service') AS hors_service
FROM stations st
LEFT JOIN bornes b ON b.id_station = st.id_station
GROUP BY st.id_station, st.code_station, st.nom_station
ORDER BY st.code_station;

-- Question 12
-- Affiche toutes les sessions de recharge à la borne ST-LIL dont l'énergie délivrée a été maximale.
SELECT sessions_recharge.id_session, bornes.code_borne, sessions_recharge.debut_session, sessions_recharge.energie_kwh
FROM sessions_recharge
JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
JOIN stations ON stations.id_station = bornes.id_station
WHERE stations.code_station = 'ST-LIL'AND sessions_recharge.statut = 'terminee'AND sessions_recharge.energie_kwh = (
      SELECT MAX(s2.energie_kwh)
      FROM sessions_recharge s2
      JOIN bornes b2    ON b2.id_borne = s2.id_borne
      JOIN stations st2 ON st2.id_station = b2.id_station
      WHERE st2.code_station = 'ST-LIL'
        AND s2.statut = 'terminee'
  ); 

-- Question 13
-- Liste tous les véhicules qui ont réalisé une session de charge avec le statut 'terminee' dans chaque station
SELECT stations.code_station, stations.nom_station,
       COUNT(DISTINCT sessions_recharge.id_vehicule) AS nb_vehicules
FROM stations
LEFT JOIN bornes ON bornes.id_station = stations.id_station
LEFT JOIN sessions_recharge s ON sessions_recharge.id_borne = bornes.id_borne AND sessions_recharge.statut = 'terminee'
GROUP BY stations.id_station, stations.code_station, stations.nom_station
ORDER BY nb_vehicules DESC, stations.code_station; 

-- Question 14
-- Calcule l'énergie moyenne délivrée en moyenne par véhicule sur les sessions de recharge terminées
SELECT v.id_vehicule, v.immatriculation,
       COUNT(s.id_session)          AS nb_sessions_terminees,
       ROUND(AVG(s.energie_kwh), 2) AS energie_moyenne_kwh
FROM vehicules v
LEFT JOIN sessions_recharge s ON s.id_vehicule = v.id_vehicule AND s.statut = 'terminee'
GROUP BY v.id_vehicule, v.immatriculation
ORDER BY v.id_vehicule; 

-- Question 15
-- Affiche pour chaque station, la plus grosse dépense d'énergie délivrée en une session terminée avec la borne ou a eu lieu la charge
WITH max_station AS (
    SELECT bornes.id_station, MAX(sessions_recharge.energie_kwh) AS energie_max
    FROM sessions_recharge
    JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
    WHERE sessions_recharge.statut = 'terminee'
    GROUP BY bornes.id_station
)
SELECT DISTINCT stations.code_station, stations.nom_station, bornes.code_borne, max_station.energie_max
FROM max_station
JOIN stations ON stations.id_station = max_station.id_station
JOIN bornes ON bornes.id_station = max_station.id_station
JOIN sessions_recharge ON sessions_recharge.id_borne = bornes.id_borne
WHERE sessions_recharge.statut = 'terminee'
  AND sessions_recharge.energie_kwh = max_station.energie_max
ORDER BY stations.code_station, bornes.code_borne;

-- Question 16
-- Affiche toutes les sessions de charge de la voiture ESSAI0007 en indiquant dans quelle borne, quelle ville et à quelle date elles ont eu lieu
SELECT stations.ville, stations.nom_station, bornes.code_borne, sessions_recharge.debut_session, sessions_recharge.statut
FROM sessions_recharge
JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule
JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
JOIN stations ON stations.id_station = bornes.id_station
WHERE vehicules.immatriculation = 'ESSAI-0007'
ORDER BY sessions_recharge.debut_session;


-- Question 17
-- Affiche tous les clients et véhicules qui ont utilisé au moins une fois la borne 'BR-NAN-01'
SELECT DISTINCT clients.id_client, clients.nom, clients.prenom, vehicules.immatriculation, vehicules.marque, vehicules.modele
FROM sessions_recharge
JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule
JOIN clients ON clients.id_client = vehicules.id_client
WHERE bornes.code_borne = 'BR-NAN-01'
ORDER BY clients.nom, clients.prenom, vehicules.immatriculation; 

-- Question 18
-- Affiche toutes les bornes qui ont déjà eu au moins 2 incidents avec le nombre d'incidents et à quelle date les incidents ont eu lieu  
SELECT bornes.code_borne, stations.nom_station, COUNT(*) AS nb_incidents, MAX(incidents.date_signalement) AS dernier_incident
FROM incidents
JOIN bornes ON bornes.id_borne = incidents.id_borne
JOIN stations ON stations.id_station = bornes.id_station
GROUP BY bornes.id_borne, bornes.code_borne, stations.nom_station
HAVING COUNT(*) >= 2
ORDER BY nb_incidents DESC, bornes.code_borne;

-- Question 19
-- Affiche tous les clients qui ont complété au moins une sessions de recharge dans chacune des stations du réseau.
SELECT c.id_client, c.nom, c.prenom
FROM clients c
JOIN vehicules v         ON v.id_client = c.id_client
JOIN sessions_recharge s ON s.id_vehicule = v.id_vehicule
JOIN bornes b            ON b.id_borne = s.id_borne
WHERE s.statut = 'terminee'
GROUP BY c.id_client, c.nom, c.prenom
HAVING COUNT(DISTINCT b.id_station) = (SELECT COUNT(*) FROM stations)
ORDER BY c.id_client

-- Question 24
-- Liste les 10 sessions de recharge ayant donné lieu aux montants de paiement accepté les plus élevés, avec client, véhicule et stations
SELECT sessions_recharge.id_session, paiements.montant_eur, clients.nom, clients.prenom, vehicules.immatriculation, stations.nom_station
FROM paiements
JOIN sessions_recharge ON sessions_recharge.id_session = paiements.id_session
JOIN vehicules ON vehicules.id_vehicule = sessions_recharge.id_vehicule
JOIN clients ON clients.id_client = vehicules.id_client
JOIN bornes ON bornes.id_borne = sessions_recharge.id_borne
JOIN stations ON stations.id_station = bornes.id_station
WHERE paiements.statut = 'accepte'
ORDER BY paiements.montant_eur DESC, sessions_recharge.id_session
LIMIT 10

