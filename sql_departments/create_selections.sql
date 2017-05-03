UPDATE mbad.proxout
SET number_of_sample = 1;

alter table mbad.proxout
add column department char(30);

update mbad.proxout sm
SET department = t.department
FROM (SELECT
        "id",
        department
      FROM mbad.employee) t
WHERE t.id = substring(sm.employee_id FROM '[A-Za-z]+');

--удаление и вставка из avgduration_dep
DELETE FROM mbad.avgduration_dep;
INSERT INTO mbad.avgduration_dep (department, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)
  SELECT
    t.*,
    CASE WHEN avgduration != 0
      THEN round(sko / avgduration, 3)
    WHEN avgduration = 0
      THEN 0
    END AS sko_by_avg

  FROM
    (SELECT DISTINCT
       department,
       zone,
       wd,
       round(avg(duration)
             OVER (PARTITION BY department, zone, wd, number_of_sample
               ORDER BY NULL)) AS avgduration,
       count(zone)
       OVER (PARTITION BY department, zone, wd, number_of_sample
         ORDER BY NULL)        AS numberofvisit,
       round(stddev_pop(duration)
             OVER (PARTITION BY department, zone, wd, number_of_sample
               ORDER BY NULL)) AS sko,
       number_of_sample

     FROM mbad.proxout) t;


--удаление и вставка в avgtime_dep
DELETE FROM mbad.avgtime_dep;
INSERT INTO mbad.avgtime_dep (department, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)
  SELECT
    t.*,
    CASE WHEN avgtime != 0
      THEN round(sko / avgtime, 3)
    WHEN avgtime = 0
      THEN 0
    END AS sko_by_avg

  FROM
    (SELECT DISTINCT
       department,
       zone,
       wd,
       round(avg(time)
             OVER (PARTITION BY department, zone, wd, number_of_sample
               ORDER BY NULL)) AS avgtime,
       count(zone)
       OVER (PARTITION BY department, zone, wd, number_of_sample
         ORDER BY NULL)        AS numberofvisit,
       round(stddev_pop(time)
             OVER (PARTITION BY department, zone, wd, number_of_sample
               ORDER BY NULL)) AS sko,
       number_of_sample
     FROM mbad.proxout) t;


--разбиение по длительности
create or replace function mbad.get_number_of_sample_dep()
	returns integer as
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
                                                                                     FROM mbad.avgduration_dep
                                                                                    ) z
                                                          ON p.department = z.department
                                                             AND p.zone = z.zone
                                                             AND p.wd = z.wd
                                                             AND p.number_of_sample = z.number_of_sample) a
  WHERE pr.department = a.department
        AND pr.zone = a.zone
        AND pr.wd = a.wd
        AND pr.number_of_sample = a.number_of_sample
        AND pr.duration = a.duration
        AND pr.time = a.time;
  RETURN 1;
END;
$BODY$
language PLPGSQL;


--разбиние по времени


create or replace function mbad.get_number_of_sample_by_time_dep()
	returns integer as
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
                                                                                     FROM mbad.avgtime_dep
                                                                                    ) z
                                                          ON p.department = z.department
                                                             AND p.zone = z.zone
                                                             AND p.wd = z.wd
                                                             AND p.number_of_sample = z.number_of_sample) a
  WHERE pr.department = a.department
        AND pr.zone = a.zone
        AND pr.wd = a.wd
        AND pr.number_of_sample = a.number_of_sample
        AND pr.duration = a.duration
        AND pr.time = a.time;
  RETURN 1;
END;
$BODY$
language PLPGSQL;


-- объединение avgduration_dep и avgtime_dep
INSERT INTO mbad.simple_motifs_dep (department, zone, wd, number_of_sample, avgduration,
                                numberofvisit, duration_sko, avgtime, time_sko)
  SELECT
    d.department,
    d.zone,
    d.wd,
    d.number_of_sample,
    d.avgduration,
    d.numberofvisit,
    d.sko AS duration_sko,
    t.avgtime,
    t.sko AS time_sko
  FROM mbad.avgduration_dep d LEFT JOIN mbad.avgtime_dep t
      ON d.department = t.department
         AND d."zone" = t."zone"
         AND d.number_of_sample = t.number_of_sample
         AND d.wd = t.wd
         AND d.numberofvisit = t.numberofvisit;


insert into mbad.simple_motifs_dep_1v (department, zone, wd, number_of_sample, avgduration,
                                numberofvisit, duration_sko, avgtime, time_sko, work_place)
select department, zone, wd, number_of_sample, avgduration,
                                numberofvisit, duration_sko, avgtime, time_sko, work_place
from mbad.simple_motifs_dep
where numberofvisit = 1;

select count(*) from mbad.simple_motifs_dep


