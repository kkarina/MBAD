--обнуление мотивов
UPDATE simple_motifs
SET motif = NULL;

--доверительный интервал
UPDATE mbad.simple_motifs
SET "cid" =3 * duration_sko / sqrt(numberofvisit);

UPDATE mbad.simple_motifs
SET "cit" = 3 * time_sko / sqrt(numberofvisit);

--указание номера офиса сотрудника
UPDATE simple_motifs sm
SET office_zone = t.zone
FROM (SELECT
        "id",
        "zone"
      FROM employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');
--указание отдела сотрудника
UPDATE simple_motifs sm
SET department = t.department
FROM (SELECT
        "id",
        department
      FROM employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');

--пришел на рабочее место
UPDATE simple_motifs
SET motif = 'пришел на рабочее место'
WHERE zone = office_zone
      AND avgduration > 600
      AND motif IS NULL;

--зашел в лифт
UPDATE mbad.simple_motifs
SET motif = 'зашел в лифт'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration > 2;

--вышел из лифта
UPDATE mbad.simple_motifs
SET motif = 'вышел из лифта'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration = 2;

--ушел с работы(последняя запись в логах)
UPDATE mbad.simple_motifs
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration = 0;

--ушел с работы
UPDATE mbad.simple_motifs
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration >= 28800;

--сквозные зоны
UPDATE mbad.simple_motifs
SET motif = 'сквозная зона'
WHERE
  avgduration >= 0 AND avgduration <=100 AND motif IS NULL;

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
      AND avgduration > 60
      AND avgduration < 7200
      AND motif IS NULL
      AND s.zone != s.office_zone;

--зашел в уборную
UPDATE simple_motifs
SET motif = 'зашел в уборную'
WHERE ("zone" = '3-2' OR "zone" = '2-7' OR "zone" = '1-1')
      AND avgduration >= 90
      AND avgduration <= 900;

--митинг в зоне 1-6
UPDATE simple_motifs
SET motif = 'митинг в 1-6'
WHERE zone = '1-6' AND avgduration > 2680
      AND (avgtime > 8830 AND avgtime < 22000);

--серверная
UPDATE simple_motifs
SET motif = 'зашел в серверную'
WHERE zone = '3-Server';

--совещание в 2-1
UPDATE mbad.simple_motifs
SET motif = 'совещание в 2-1'
WHERE zone = '2-1'
      AND motif IS NULL
      AND avgduration > 1000
      AND avgduration < 7200;

--дневной митинг в 2-6
UPDATE mbad.simple_motifs
SET motif = 'дневной митинг в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 2900
      AND avgtime > 41800
      AND avgtime < 45000
      AND motif IS NULL;

--вечерний митинг в 2-6
UPDATE mbad.simple_motifs
SET motif = 'вечерний митинг в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 2900
      AND avgtime > 72000
      AND avgtime < 73500
      AND motif IS NULL;

--совещание HR в 2-6
UPDATE mbad.simple_motifs
SET motif = 'совещание в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 5900
      AND avgtime > 52000
      AND wd = 'Wednesday'
      AND motif IS NULL;

--зашел в комнату отдыха
UPDATE mbad.simple_motifs
SET motif = 'зашел в комнату отдыха'
WHERE "zone" = '2-1'
      AND avgduration >= 300
      AND avgduration < 1000
      AND motif IS NULL;

--Loading
UPDATE mbad.simple_motifs
SET motif = 'Loading'
WHERE zone = '1-3' AND avgduration > 19330 AND simple_motifs.motif IS NULL;

--null
UPDATE mbad.simple_motifs ss
    SET motif = '0'
    WHERE ss.motif is null;

--разброс прохождения сквозные зон
update mbad.simple_motifs set cid = 40
where motif = 'сквозная зона' or motif = 'пришел  на работу'


--разброс прихода на работу

select distinct motif
from mbad.simple_motifs


