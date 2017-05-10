--вставка в zone_office
INSERT INTO mbad.zone_office ("zone", office)
VALUES
  ('1-1', '1070'),
  ('1-1', '1090'),
  ('1-1', '1100'),
  ('1-1', '1040'),
  ('1-7', '1010'),
  ('1-8', '1020'),
  ('2-1', '2120'),
  ('2-1', '2125'),
  ('2-1', '2130'),
  ('2-1', '2135'),
  ('2-1', '2140'),
  ('2-1', '2525'),
  ('2-1', '2530'),
  ('2-1', '2535'),
  ('2-1', '2540'),
  ('2-1', '2545'),
  ('2-1', '2550'),
  ('2-1', '2555'),
  ('2-1', '2560'),
  ('2-1', '2575'),
  ('2-2', '2100'),
  ('2-2', '2110'),
  ('2-2', '2470'),
  ('2-2', '2460'),
  ('2-2', '2450'),
  ('2-2', '2440'),
  ('2-2', '2430'),
  ('2-2', '2420'),
  ('2-2', '2410'),
  ('2-2', '2400'),
  ('2-2', '2520'),
  ('2-2', '2515'),
  ('2-2', '2510'),
  ('2-2', '2505'),
  ('2-2', '2380'),
  ('2-2', '2375'),
  ('2-2', '2370'),
  ('2-2', '2705'),
  ('2-3', '2170'),
  ('2-5', '2500'),
  ('2-6', '2250'),
  ('2-6', '2260'),
  ('2-6', '2270'),
  ('2-6', '2300'),
  ('2-6', '2310'),
  ('2-6', '2320'),
  ('2-6', '2340'),
  ('2-6', '2345'),
  ('2-6', '2350'),
  ('2-6', '2355'),
  ('2-6', '2360'),
  ('2-6', '2655'),
  ('2-6', '2660'),
  ('2-6', '2680'),
  ('2-6', '2675'),
  ('2-6', '2665'),
  ('2-6', '2670'),
  ('2-7', '2145'),
  ('2-7', '2150'),
  ('2-7', '2155'),
  ('2-7', '2160'),
  ('2-7', '2165'),
  ('2-7', '2175'),
  ('2-7', '2200'),
  ('2-7', '2210'),
  ('2-7', '2220'),
  ('2-7', '2230'),
  ('2-7', '2240'),
  ('2-7', '2565'),
  ('2-7', '2570'),
  ('2-7', '2580'),
  ('2-7', '2585'),
  ('2-7', '2595'),
  ('2-7', '2590'),
  ('2-7', '2600'),
  ('2-7', '2605'),
  ('2-7', '2610'),
  ('2-7', '2615'),
  ('2-7', '2620'),
  ('2-7', '2625'),
  ('2-7', '2630'),
  ('2-7', '2635'),
  ('2-7', '2640'),
  ('2-7', '2645'),
  ('2-7', '2650'),
  ('3-1', '3110'),
  ('3-1', '3120'),
  ('3-1', '3500'),
  ('3-1', '3515'),
  ('3-1', '3450'),
  ('3-1', '3320'),
  ('3-2', '3130'),
  ('3-2', '3140'),
  ('3-2', '3150'),
  ('3-2', '3160'),
  ('3-2', '3505'),
  ('3-2', '3510'),
  ('3-2', '3520'),
  ('3-2', '3525'),
  ('3-2', '3530'),
  ('3-2', '3535'),
  ('3-2', '3540'),
  ('3-2', '3545'),
  ('3-2', '3550'),
  ('3-2', '3555'),
  ('3-2', '3600'),
  ('3-2', '3340'),
  ('3-2', '3350'),
  ('3-2', '3360'),
  ('3-2', '3370'),
  ('3-3', '3200'),
  ('3-3', '3210'),
  ('3-3', '3220'),
  ('3-3', '3230'),
  ('3-3', '3300'),
  ('3-3', '3310'),
  ('3-3', '3400'),
  ('3-3', '3410'),
  ('3-3', '3420'),
  ('3-3', '3430'),
  ('3-3', '3460'),
  ('3-6', '3100'),
  ('1-1', '1110'),
  ('1-1', '1000'),
  ('3-6', '3000'),
  ('3-3', '3300');
--конец
--копировать таблицу simple_motifs
INSERT INTO simple_motifs_test
(employee_id, zone, wd, number_of_sample,
 avgduration, numberofvisit, duration_sko,
 avgtime, time_sko, motif,
 "cid", cit, department, office_zone)
  SELECT
    employee_id,
    zone,
    wd,
    number_of_sample,
    avgduration,
    numberofvisit,
    duration_sko,
    avgtime,
    time_sko,
    motif,
    "cid",
    cit,
    department,
    office_zone
  FROM mbad.simple_motifs;
--конец
--вставка в logs
INSERT INTO mbad.logs (employee_id, ZONE, DATE, TIME, duration)
  SELECT
    prox_id,
    "floor" || '-' || substring("zone" FROM 2)  AS "zone",
    ("timestamp") :: DATE                       AS "date",
    date_part('hour', "timestamp") * 3600 + date_part('minute', "timestamp")*60 + date_part('second', "timestamp")
                                                AS "time",
    round(extract(EPOCH FROM t.next_time -
                             t.timestamp)) AS duration
  FROM
    (
      SELECT
        p.*,
        LEAD("timestamp")
        OVER (PARTITION BY prox_id
          ORDER BY "timestamp") next_time
      FROM mbad.proxout_mc2 p
    ) t;
--конец вставки в logs
UPDATE mbad.logs
SET duration = 0
WHERE duration IS NULL;
--объединение avgduration c avgtime
INSERT INTO mbad.simple_motifs (employee_id, zone, wd, number_of_sample, avgduration,
                                numberofvisit, duration_sko, avgtime, time_sko)
  SELECT
    d.employee_id,
    d.zone,
    d.wd,
    d.number_of_sample,
    d.avgduration,
    d.numberofvisit,
    d.sko AS duration_sko,
    t.avgtime,
    t.sko AS time_sko
  FROM mbad.avgduration d LEFT JOIN mbad.avgtime t
      ON d.employee_id = t.employee_id
         AND d."zone" = t."zone"
         AND d.number_of_sample = t.number_of_sample
         AND d.wd = t.wd
         AND d.numberofvisit = t.numberofvisit;

DELETE FROM mbad.simple_motifs
WHERE numberofvisit = 1 AND (avgduration != 0 AND simple_motifs.zone != '1-1');

--импорт в proxout_mc2
COPY mbad.proxout_mc2 ("timestamp", type, prox_id, floor, zone)
FROM 'c://proxOut-MC2.csv'
WITH DELIMITER ','
CSV HEADER;


COPY mbad.employee (id, department, office)
FROM 'c://EmployeeList.csv'
WITH DELIMITER ','
CSV HEADER;

select distinct motif
from mbad.simple_motifs_dep;

INSERT into mbad.proxout (employee_id, zone, wd, duration, time, department)
    SELECT employee_id, zone, wd, duration, time, department
FROM mbad.logs;
commit;
DELETE from mbad.proxout

