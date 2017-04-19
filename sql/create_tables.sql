create table zone_office (
zone char(20),
office char(4)
)
CREATE TABLE mbad.zone_id
(
  id   INTEGER,
  zone CHAR(15)
);

CREATE TABLE mbad.avgDuration(
  employee_id   CHAR(30),
  zone          CHAR(20),
  wd            CHAR(20),
  avgDuration   INT,
  numberofvisit INT,
  sko           INT,
  sko_by_avg    REAL,
  number_of_sample int
);

CREATE TABLE mbad.avgtime
(
  employee_id   CHAR(30),
  zone          CHAR(20),
  wd            CHAR(20),
  avgTime   INT,
  numberofvisit INT,
  sko           INT,
  sko_by_avg    REAL,
  number_of_sample int
);

create table logs
(employee_id char (30), "date" date, "time" int, duration int, zone char(30))

create table mbad.simple_motifs
( employee_id char(30),
  zone char(20),
  wd char(20),
  number_of_sample int,
  avgduration int,
  numberofvisit int,
  duration_sko int,
  duration_sko_by_avg real,
  avgtime int,
  time_sko int,
  time_sko_by_avg real
);

CREATE TABLE mbad.proxout
(
  employee_id      CHAR(30),
  zone             CHAR(15),
  wd               CHAR(20),
  duration         INT,
  time             INT,
  number_of_sample int
);

CREATE TABLE mbad.employee
(
  id         CHAR(30),
  department CHAR(50),
  office     char(10),
  zone       char (20)
);

CREATE TABLE mbad.sequences
(
  employee_id CHAR(30),
  Tstart      TIMESTAMP,
  Tend        TIMESTAMP,
  sequence    CHAR(255),
  duration    INTERVAL
);
--разбиение по длительности
CREATE OR REPLACE FUNCTION mbad.get_number_of_sample()
  RETURNS INT4
AS
$BODY$
DECLARE
BEGIN
  UPDATE mbad.proxout pr
  SET number_of_sample = a.new_number_of_sample FROM (SELECT
                                                        p.*,
                                                        z.sko_by_avg,
                                                        z.avgduration,
                                                        CASE
                                                        WHEN p.duration <= z.avgduration AND z.sko_by_avg >= 0.5
                                                          THEN p.number_of_sample * 10 + 1
                                                        WHEN p.duration > z.avgduration AND z.sko_by_avg >= 0.5
                                                          THEN p.number_of_sample * 10 + 2
                                                        WHEN z.sko_by_avg < 0.5
                                                          THEN p.number_of_sample
                                                        END AS new_number_of_sample

                                                      FROM mbad.proxout p LEFT JOIN (SELECT *
                                                                                     FROM mbad.avgduration
                                                                                    ) z
                                                          ON p.employee_id = z.employee_id
                                                             AND p.zone = z.zone
                                                             AND p.wd = z.wd
                                                             AND p.number_of_sample = z.number_of_sample) a
  WHERE pr.employee_id = a.employee_id
        AND pr.zone = a.zone
        AND pr.wd = a.wd
        AND pr.number_of_sample = a.number_of_sample
        AND pr.duration = a.duration
        AND pr.time = a.time;


  RETURN 1;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--разбиение по времени
CREATE OR REPLACE FUNCTION mbad.get_number_of_sample_by_time()
  RETURNS INT4
AS
$BODY$
DECLARE
BEGIN
  UPDATE mbad.proxout pr
  SET number_of_sample = a.new_number_of_sample FROM (SELECT
                                                        p.*,
                                                        z.sko_by_avg,
                                                        z.avgTime,
                                                        CASE
                                                        WHEN p.time <= z.avgTime AND z.sko_by_avg >= 0.2
                                                          THEN p.number_of_sample * 10 + 1
                                                        WHEN p.time > z.avgTime AND z.sko_by_avg >= 0.2
                                                          THEN p.number_of_sample * 10 + 2
                                                        WHEN z.sko_by_avg < 0.2
                                                          THEN p.number_of_sample
                                                        END AS new_number_of_sample

                                                      FROM mbad.proxout p LEFT JOIN (SELECT *
                                                                                     FROM mbad.avgtime
                                                                                    ) z
                                                          ON p.employee_id = z.employee_id
                                                             AND p.zone = z.zone
                                                             AND p.wd = z.wd
                                                             AND p.number_of_sample = z.number_of_sample) a
  WHERE pr.employee_id = a.employee_id
        AND pr.zone = a.zone
        AND pr.wd = a.wd
        AND pr.number_of_sample = a.number_of_sample
        AND pr.duration = a.duration
        AND pr.time = a.time;


  RETURN 1;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;




--удаление и вставка в таблицу avgtime
DELETE FROM mbad.avgtime;
INSERT INTO mbad.avgtime (employee_id, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)
  SELECT
    t.*,
    CASE WHEN avgtime != 0
      THEN round(sko / avgtime, 3)
    WHEN avgtime = 0
      THEN 0
    END AS sko_by_avg

  FROM
    (SELECT DISTINCT
       employee_id,
       zone,
       wd,
       round(avg(time )
             OVER (PARTITION BY employee_id, zone, wd, number_of_sample
               ORDER BY NULL)) AS avgtime,
       count(zone)
       OVER (PARTITION BY employee_id, zone, wd, number_of_sample
         ORDER BY NULL)        AS numberofvisit,
       round(stddev_pop(time)
             OVER (PARTITION BY employee_id, zone, wd, number_of_sample
               ORDER BY NULL)) AS sko,
       number_of_sample

     FROM mbad.proxout) t;

--удаление и вставка в таблицу avgduration
DELETE FROM mbad.avgduration;
INSERT INTO mbad.avgduration (employee_id, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)
  SELECT
    t.*,
    CASE WHEN avgduration != 0
      THEN round(sko / avgduration, 3)
    WHEN avgduration = 0
      THEN 0
    END AS sko_by_avg

  FROM
    (SELECT DISTINCT
       employee_id,
       zone,
       wd,
       round(avg(duration)
             OVER (PARTITION BY employee_id, zone, wd, number_of_sample
               ORDER BY NULL)) AS avgduration,
       count(zone)
       OVER (PARTITION BY employee_id, zone, wd, number_of_sample
         ORDER BY NULL)        AS numberofvisit,
       round(stddev_pop(duration)
             OVER (PARTITION BY employee_id, zone, wd, number_of_sample
               ORDER BY NULL)) AS sko,
       number_of_sample

     FROM mbad.proxout) t;
--обновление proxout
update proxout set number_of_sample = 1

--объединение avgduration c avgtime
insert into mbad.simple_motifs (employee_id, zone, wd, number_of_sample, avgduration,
                               numberofvisit, duration_sko, duration_sko_by_avg,
                               avgtime, time_sko, time_sko_by_avg)
select d.employee_id, d.zone, d.wd, d.number_of_sample, d.avgduration, d.numberofvisit, d.sko as duration_sko,
       d.sko_by_avg as duration_sko_by_avg, t.avgtime, t.sko as time_sko, t.sko_by_avg as time_sko_by_avg
from avgduration d left join avgtime t
on d.employee_id = t.employee_id
and d."zone" = t."zone"
and d.number_of_sample = t.number_of_sample
and  d.wd = t.wd
and d.numberofvisit = t.numberofvisit;

update simple_motifs s set motif = 'пришел на рабочее место'
 from (select "zone", "id"
                from mbad.employee)t
where s.zone = t.zone and
      t.id = substring(s.employee_id from '[A-Za-z]+')
      and avgduration > 3600;


copy mbad.proxout_mc2( "timestamp", type, prox_id, floor, zone)
from 'c://proxOut-MC2.csv'
with DELIMITER   ','
CSV  HEADER;

count (8*) f