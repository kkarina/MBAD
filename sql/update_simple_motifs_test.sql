--доверительный интервал
UPDATE mbad.simple_motifs_test
SET "cit" = 0.475 * time_sko / sqrt(numberofvisit);

UPDATE mbad.simple_motifs_test
SET "cid" = 0.475 * duration_sko / sqrt(numberofvisit);


--пришел на рабочее место
UPDATE simple_motifs_test
SET motif = 'пришел на рабочее место'
WHERE zone = office_zone
      AND avgduration > 60
      AND motif IS NULL;

--зашел в лифт
UPDATE mbad.simple_motifs_test
SET motif = 'зашел в лифт'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration > 2;

--вышел из лифта
UPDATE mbad.simple_motifs_test
SET motif = 'вышел из лифта'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration = 2;

--ушел с работы(последняя запись в логах)
UPDATE mbad.simple_motifs_test
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration = 0;

--ушел с работы
UPDATE mbad.simple_motifs_test
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration >= 28800;

--сквозные зоны
UPDATE mbad.simple_motifs_test
SET motif = 'прошел через ' || "zone"
WHERE "zone" != '1-4' AND "zone" != '2-4' AND "zone" != '3-4' AND avgduration > 0 AND avgduration < 130 and motif!='пришел на работу';

--зашел в гастроном
UPDATE mbad.simple_motifs_test
SET motif = 'зашел в гастроном'
WHERE "zone" = '1-2';
--пришел на работу
UPDATE mbad.simple_motifs_test sm
SET motif = 'пришел на работу'
FROM (
       SELECT
         employee_id,
         wd,
         min(avgtime) AS avgtime
       FROM mbad.simple_motifs_test
       WHERE "zone" = '1-1'
       GROUP BY employee_id, wd
     ) t
WHERE sm.zone = '1-1'
      AND sm.employee_id = t.employee_id
      AND sm.wd = t.wd
      AND sm.avgtime = t.avgtime;
--зашел к коллеге
UPDATE simple_motifs_test s
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
      AND avgduration > 59
      AND avgduration < 7200
      AND motif IS NULL
      AND s.zone!= s.office_zone;
--зашел в уборную
UPDATE simple_motifs_test
SET motif = 'зашел в уборную'
WHERE ("zone" = '3-2' OR "zone" = '2-7' OR "zone" = '1-1')
      AND avgduration >= 120
      AND avgduration <= 900
      AND motif IS NULL;

--митинг в зоне 1-6
update simple_motifs_test
set motif = 'митинг в 1-6'
where zone = '1-6' and avgduration > 2680
and (avgtime>8830 and avgtime<22000);
--серверная
update simple_motifs_test
set motif = 'зашел в серверную'
where zone = '3-Server';

--указание номера офиса сотрудника
UPDATE simple_motifs_test sm
SET office_zone = t.zone
FROM (SELECT
        "id",
        "zone"
      FROM employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');
--указание отдела сотрудника
UPDATE simple_motifs_test sm
SET department = t.department
FROM (SELECT
        "id",
        department
      FROM employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');

--совещание в 2-1
update mbad.simple_motifs_test
set motif = 'совещание в 2-1'
where zone = '2-1'
and motif is null
and avgduration > 1000
and avgduration < 7200

--дневной митинг в 2-6
update mbad.simple_motifs_test
set motif = 'дневной митинг в 2-6'
where "zone" = '2-6'
and avgduration > 2900
and avgtime >41800
and avgtime<45000
and motif is null;

--вечерний митинг в 2-6
update mbad.simple_motifs_test
set motif = 'вечерний митинг в 2-6'
where "zone" = '2-6'
and avgduration > 2900
and avgtime >72000
and avgtime<73500
and motif is null;

--совещание HR в 2-6
update mbad.simple_motifs_test
set motif = 'совещание в 2-6'
where "zone" = '2-6'
and avgduration > 5900
and avgtime >52000
and wd = 'Wednesday'
and motif is null;

--зашел в комнату отдыха
update mbad.simple_motifs_test
set motif = 'зашел в комнату отдыха'
where "zone" = '2-1'
and avgduration >=300
and avgduration <1000
and motif is null
--обнуление мотивов
UPDATE simple_motifs_test
SET motif = NULL

