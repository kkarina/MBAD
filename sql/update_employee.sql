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
SET  zone = trim(zone);



DELETE FROM mbad.simple_motifs
WHERE numberofvisit = 1 AND avgduration != 0

SELECT count(*)
FROM mbad.simple_motifs;

update mbad.simple_motifs
set "zone" = trim(zone);

update logs
set employee_id = trim(employee_id);

UPDATE logs SET duration = 0
WHERE duration is NULL ;

alter TABLE mbad.logs
    ADD COLUMN wd CHAR(20);


alter table mbad.logs
add column department char(30)

UPDATE logs set wd = to_char("date", 'Day');

update mbad.logs sm
SET department = t.department
FROM (SELECT
        "id",
        department
      FROM mbad.employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');
