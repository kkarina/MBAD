UPDATE mbad.employee x
SET zone = t.zone
FROM (SELECT *
      FROM mbad.zone_office) t
WHERE substring(x.office FROM 2) =t.office;

UPDATE mbad.logs
SET "zone" = ' 3-Server'
WHERE "zone" = ' 3-Server Room';

SELECT *
FROM mbad.proxout_mc2

SELECT *
FROM mbad.logs
ORDER BY duration;

UPDATE mbad.logs
SET duration = 0
WHERE duration IS NULL;

DELETE FROM mbad.logs;
UPDATE mbad.logs
SET  zone ='3-Server' WHERE zone = ' 3-erver';
SELECT count(*)
FROM mbad.logs
WHERE duration IS NULL


DELETE FROM mbad.simple_motifs
WHERE numberofvisit = 1 AND avgduration != 0

SELECT count(*)
FROM mbad.simple_motifs