update mbad.logs_motif l
set duration = x.duration
from (
    select t.*, (next_time - "time") as duration
        from
            (select *,
                LEAD("time") OVER(partition by employee_id ORDER BY "date", "time") next_time
                from mbad.logs_motif
            )t)x
where l.employee_id = x.employee_id and
l.zone = x.zone and
l.date = x.date and
l.wd = x.wd and
l.time = x.time;

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





