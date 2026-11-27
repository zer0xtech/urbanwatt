-- verif du nb de lignes
SELECT 'stations' AS table_nom, COUNT(*) AS nb_lignes FROM stations
UNION ALL
SELECT 'bornes', COUNT(*) FROM bornes
UNION ALL
SELECT 'clients', COUNT(*) FROM clients
UNION ALL
SELECT 'vehicules', COUNT(*) FROM vehicules
UNION ALL
SELECT 'sessions_recharge', COUNT(*) FROM sessions_recharge
UNION ALL
SELECT 'paiements', COUNT(*) FROM paiements
UNION ALL
SELECT 'incidents', COUNT(*) FROM incidents
UNION ALL
SELECT 'techniciens', COUNT(*) FROM techniciens
UNION ALL
SELECT 'interventions', COUNT(*) FROM interventions;

-- controle de la cohérence des références
SELECT bornes.*
FROM bornes
LEFT JOIN stations ON bornes.id_station = stations.id_station
WHERE stations.id_station IS NULL;

SELECT incidents.*
FROM incidents
LEFT JOIN bornes  ON incidents.id_borne = bornes.id_borne
WHERE bornes.id_borne IS NULL;

SELECT interventions.*
FROM interventions
LEFT JOIN incidents ON interventions.id_incident = incidents.id_incident
WHERE incidents.id_incident IS NULL;

SELECT interventions.*
FROM interventions
LEFT JOIN techniciens ON interventions.id_technicien = techniciens.id_technicien
WHERE interventions.id_technicien IS NULL;

SELECT paiements.*
FROM paiements
LEFT JOIN sessions_recharge ON paiements.id_session = sessions_recharge.id_session
WHERE paiements.id_session IS NULL;

SELECT sessions_recharge.*
FROM sessions_recharge
LEFT JOIN bornes ON sessions_recharge.id_borne = bornes.id_borne
WHERE sessions_recharge.id_borne IS NULL;

SELECT sessions_recharge.*
FROM sessions_recharge
LEFT JOIN vehicules ON sessions_recharge.id_vehicule = vehicules.id_vehicule
WHERE sessions_recharge.id_borne IS NULL;

SELECT vehicules.*
FROM vehicules
LEFT JOIN clients ON vehicules.id_client = clients.id_client
WHERE vehicules.id_client IS NULL;

-- validation de la présence des trois statuts de session
SELECT statut, COUNT(*) AS nb_sessions
FROM sessions_recharge
GROUP BY statut

-- création de 2 index
CREATE INDEX idx_bornes_id_station ON bornes(id_station);
CREATE INDEX idx_paiements_id_session ON paiements(id_session);
