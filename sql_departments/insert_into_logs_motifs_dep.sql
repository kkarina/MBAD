insert into mbad.logs_motif
 (employee_id ,
  zone ,
  "date" ,
  wd ,
  "time" ,
  duration ,
  department ,
  motif )
select trim(t.employee_id), trim(t.zone), t.date, trim(t.wd),  t.time, t.duration, trim(t.department), trim(sm.motif)
from
(select distinct l.*, p.number_of_sample
from mbad.logs l left join mbad.proxout p
on l.employee_id = p.employee_id and
   l.department  = p.department and
   l.wd = p.wd and
   l.zone = p."zone" and
   l.duration = p.duration and
   l."time" = p."time")t left join mbad.simple_motifs_dep sm
   on t.department = sm.department
   and t.wd = sm.wd
   and t.zone = sm."zone"
   and t.number_of_sample = sm.number_of_sample
   order by t.employee_id, t.date, t.time
delete from mbad.logs_motif


update logs_motif sm
set motif = 'пришел на работу'
from (
       SELECT
         employee_id,
         date,
         min(time) AS time
       FROM mbad.logs_motif
       WHERE "zone" = '1-1'
       GROUP BY employee_id, date
     ) t
WHERE sm.zone = '1-1'
      AND sm.employee_id = t.employee_id
      AND sm.date = t.date
      AND sm.time = t.time;