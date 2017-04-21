--копировать таблицу simple_motifs
insert into simple_motifs_test
( employee_id,  zone,  wd,  number_of_sample,
  avgduration,  numberofvisit,  duration_sko,
  avgtime,time_sko, motif,
  "cid",  cit, department)
  select employee_id ,
  zone ,
  wd ,
  number_of_sample ,
  avgduration ,
  numberofvisit,
  duration_sko ,
  avgtime,
  time_sko ,
  motif,
   "cid",
   cit,
   department
   from mbad.simple_motifs

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

--вставка в logs
insert into mbad.logs (employee_id, zone, date, time, duration)
select prox_id,
	   "floor"||'-'||substring ("zone" from 2) as "zone",
       ("timestamp")::date as "date",
       date_part  ('hour',"timestamp")*3600+date_part  ('minute', "timestamp")*60+date_part ('second', "timestamp") as "time",
       extract(epoch from t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by prox_id ORDER BY "timestamp") next_time
from mbad.proxout_mc2 p
)t
--конец вставки в logs

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


--импорт в proxout_mc2
copy mbad.proxout_mc2( "timestamp", type, prox_id, floor, zone)
from 'c://proxOut-MC2.csv'
with DELIMITER   ','
CSV  HEADER;


--доверительный интервал
update mbad.simple_motifs
set "cit" = 0.475 * time_sko/ sqrt (numberofvisit)
--пришел на рабочее место
update simple_motifs_test set motif = 'пришел на рабочее место'
where zone =  office_zone
      and avgduration > 1800
      and motif is null;
--зашел в лифт
update mbad.simple_motifs
set motif = 'зашел в лифт'
where (zone = '1-4' or zone = '2-4' or zone = '3-4') and avgduration >2;
--вышел из лифта
update mbad.simple_motifs
set motif = 'вышел из лифта'
where (zone = '1-4' or zone = '2-4' or zone = '3-4') and avgduration =2;
--ушел с работы(последняя запись в логах
update mbad.simple_motifs
set motif = 'ушел с работы'
where zone = '1-1' and avgduration = 0
--сквозные зоны
update mbad.simple_motifs
set motif = 'прошел через '||"zone"
where ("zone"!= '1-4' or "zone" != '2-4' or "zone" != '3-4') and avgduration>0 and avgduration < 130
--зашел в гастроном
update mbad.simple_motifs
set motif = 'зашел в гастроном'
where "zone" = '1-2'
--пришел на работу
update mbad.simple_motifs sm
set motif = 'пришел на работу'
from (
        select employee_id, wd, min(avgtime) as avgtime
        from mbad.simple_motifs
        where "zone" = '1-1'
        group by employee_id, wd
     )t
where sm.zone = '1-1'
      and sm.employee_id = t.employee_id
      and sm.wd = t.wd
      and sm.avgtime = t.avgtime
--зашел к коллеге
update simple_motifs_test s set motif = 'зашел к коллеге'
from (
        select "id", zone, department
        from mbad.employee
     )x
where s.employee_id!=x."id"
  and s.department = x.department
  and s.zone = x.zone
    and avgduration > 130
    and avgduration < 7200
    and motif!='пришел на рабочее место' or motif is null

update simple_motifs_test
    set motif = 'зашел в уборную'
    where ("zone" = '3-2' or "zone"= '2-7' or "zone"= '1-1')
    and avgduration >=300
    and avgduration <=900
    and motif is null

select * from simple_motifs_test
where zone = '1-5' or zone = '1-6' or "zone" = '1-3'
or zone  = '2-1' or "zone" = '2-6' or zone = '3-2'


--указание номера офиса сотрудника
update simple_motifs_test sm
set  office_zone = t.zone
from (select "id", "zone"
        from employee)t
      where t.id =   substring(sm.employee_id from '[A-Za-z]+')

delete from simple_motifs_test
where motif = 'зашел к коллеге'

rollback