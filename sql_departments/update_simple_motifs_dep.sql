delete from simple_motifs_dep
where numberofvisit = 1;


--доверительный интервал
UPDATE mbad.simple_motifs_dep
SET "cid" = 3 * duration_sko / sqrt(numberofvisit);

UPDATE mbad.simple_motifs_dep
SET "cit" = 3 * time_sko / sqrt(numberofvisit);
--указание рабочего места
UPDATE simple_motifs_dep sm
SET work_place = true
FROM (SELECT
        department,
        "zone"
      FROM employee) t
WHERE t.department = sm.department and
t.zone = sm.zone;

update simple_motifs_dep
set work_place = false
where work_place is null;

--зашел в лифт
UPDATE mbad.simple_motifs_dep
SET motif = 'зашел в лифт'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration > 2;

--вышел из лифта
UPDATE mbad.simple_motifs_dep
SET motif = 'вышел из лифта'
WHERE (zone = '1-4' OR zone = '2-4' OR zone = '3-4') AND avgduration = 2;

--ушел с работы(последняя запись в логах)
UPDATE mbad.simple_motifs_dep
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration = 0;

--ушел с работы
UPDATE mbad.simple_motifs_dep
SET motif = 'ушел с работы'
WHERE zone = '1-1' AND avgduration >= 28800;

--сквозные зоны
UPDATE mbad.simple_motifs_dep
SET motif = 'сквозная зона'
WHERE
  avgduration >= 0 AND avgduration <=100 AND motif IS NULL;

--зашел в гастроном
UPDATE mbad.simple_motifs_dep
SET motif = 'зашел в гастроном'
WHERE "zone" = '1-2';

--пришел на работу
UPDATE mbad.simple_motifs_dep sm
SET motif = 'пришел на работу'
FROM (
       SELECT
         department,
         wd,
         min(avgtime)
       FROM mbad.simple_motifs_dep
       WHERE "zone" = '1-1'
       and avgtime =min(avgtime)
       GROUP BY department, wd
     ) t
WHERE sm.zone = '1-1'
      AND sm.department = t.department
      AND sm.wd = t.wd
      AND sm.avgtime = t.avgtime;

COMMIT;
--зашел в уборную
      UPDATE simple_motifs_dep
SET motif = 'зашел в уборную'
WHERE ("zone" = '3-2' OR "zone" = '2-7' OR "zone" = '1-1')
      AND avgduration >= 101
      AND avgduration <= 900;

--митинг в зоне 1-6
UPDATE simple_motifs_dep
SET motif = 'митинг в 1-6'
WHERE zone = '1-6' AND avgduration > 2680
      AND (avgtime > 8830 AND avgtime < 45000);

--серверная
UPDATE simple_motifs_dep
SET motif = 'зашел в серверную'
WHERE zone = '3-Server';

--совещание в 2-1
UPDATE mbad.simple_motifs_dep
SET motif = 'совещание в 2-1'
WHERE zone = '2-1'
      AND motif IS NULL
      AND avgduration > 1000
      AND avgduration < 7200;

--дневной митинг в 2-6
UPDATE mbad.simple_motifs_dep
SET motif = 'дневной митинг в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 2800
      AND avgtime > 41800
      AND avgtime < 45000
      AND motif IS NULL;

--вечерний митинг в 2-6
UPDATE mbad.simple_motifs_dep
SET motif = 'вечерний митинг в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 2000
      AND avgtime > 68000
      AND avgtime < 73500
      AND motif IS NULL;

--совещание HR в 2-6
UPDATE mbad.simple_motifs_dep
SET motif = 'совещание в 2-6'
WHERE "zone" = '2-6'
      AND avgduration > 5900
      AND avgtime > 52000
      AND wd = 'Wednesday'
      AND motif IS NULL;

--зашел в комнату отдыха
UPDATE mbad.simple_motifs_dep
SET motif = 'зашел в комнату отдыха'
WHERE "zone" = '2-1'
      AND avgduration >= 300
      AND avgduration < 1000
      AND motif IS NULL;

--Loading
UPDATE mbad.simple_motifs_dep
SET motif = 'Loading'
WHERE zone = '1-3' AND avgduration > 19330 AND motif IS NULL;


--рабочее место
update mbad.simple_motifs_dep
set motif = 'рабочее место'
where work_place = true and avgduration >600
and motif is null;

-- совещание в 3-2
update mbad.simple_motifs_dep
set motif = 'совещание в 3-2'
where zone = '3-2' and avgduration>20000
and motif is null;

--совещание в 3-1
update mbad.simple_motifs_dep
set motif = 'совещание в 3-2'
where zone = '3-1' and avgduration>3000
and motif is null;


--неизвестные мотивы
update mbad.simple_motifs_dep s
set motif = x.num
from (select 'мотив '||row_number() over ()  num, avgtime
        from mbad.simple_motifs_dep
        where motif is null
        )x
where s.motif is null
and s.avgtime = x.avgtime;
