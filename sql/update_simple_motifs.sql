
--доверительный интервал
UPDATE mbad.simple_motifs
SET "cid" = 0.475 * duration_sko / sqrt(numberofvisit);
--пришел на рабочее место
UPDATE simple_motifs
SET motif = 'пришел на рабочее место'
WHERE zone = office_zone
      AND avgduration > 1800
      AND motif IS NULL;
--зашел в лифт
UPDATE mbad.simple_motifs
SET motif = 'зашел в лифт'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration > 2;
--вышел из лифта
UPDATE mbad.simple_motifs
SET motif = 'вышел из лифта'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration = 2;
--ушел с работы(последняя запись в логах
UPDATE mbad.simple_motifs
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration = 0;
--сквозные зоны
UPDATE mbad.simple_motifs
SET motif = 'прошел через ' || "zone"
WHERE ("zone" != '1-4' OR "zone" != '2-4' OR "zone" != '3-4') AND avgduration > 0 AND avgduration < 130;
--зашел в гастроном
UPDATE mbad.simple_motifs
SET motif = 'зашел в гастроном'
WHERE "zone" = '1-2';
--пришел на работу
UPDATE mbad.simple_motifs sm
SET motif = 'пришел на работу'
FROM (
       SELECT
         employee_id,
         wd,
         min(avgtime) AS avgtime
       FROM mbad.simple_motifs
       WHERE "zone" = '1-1'
       GROUP BY employee_id, wd
     ) t
WHERE sm.zone = '1-1'
      AND sm.employee_id = t.employee_id
      AND sm.wd = t.wd
      AND sm.avgtime = t.avgtime;
--зашел к коллеге
UPDATE simple_motifs s
SET motif = 'зашел к коллеге'
FROM (
       SELECT
         "id",
         zone,
         department
       FROM mbad.employee
     ) x
WHERE s.employee_id != x."id"
      AND s.department = x.department
      AND s.zone = x.zone
      AND avgduration > 130
      AND avgduration < 7200
      AND motif != 'пришел на рабочее место' OR motif IS NULL;

UPDATE simple_motifs
SET motif = 'зашел в уборную'
WHERE ("zone" = '3-2' OR "zone" = '2-7' OR "zone" = '1-1')
      AND avgduration >= 300
      AND avgduration <= 900
      AND motif IS NULL;
--указание номера офиса сотрудника
UPDATE simple_motifs sm
SET office_zone = t.zone
FROM (SELECT
        "id",
        "zone"
      FROM employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');

UPDATE simple_motifs
SET motif = NULL
WHERE motif = 'зашел к коллеге';
