select x.employee_id, x.department, x."date", x."time", x.wd, x.duration, x."zone", count(x.*)
from
(select distinct  l.employee_id, l.department, l."date", l."time", l.wd, l.duration, s.motif, l."zone"
from logs l left join simple_motifs s on
l.employee_id = s.employee_id
and l.wd = s.wd
and l."zone" = s."zone"
and l.duration >=s.avgduration -2*s.duration_sko-1
and l.duration<=s.avgduration+2*s.duration_sko+1
and l."time">=s.avgtime - 2*s.time_sko
and l."time"<=s.avgtime + 2*s.time_sko
order by  date, time)x
group by x.employee_id, x.department, x."date", x."time", x.wd, x.duration, x."zone"
having count(*)>1;

