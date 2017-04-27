select distinct l.employee_id, l.department, l."date", l."time", l.wd, l.duration, s.motif, l."zone"
from logs l left join mbad.simple_motifs_dep s on
l.department = s.department
and l.wd = s.wd
and l."zone" = s."zone"
and l.duration >=s.avgduration -s."cid"
and l.duration<=s.avgduration+s."cid"
and l."time">=s.avgtime - s.cit
and l."time"<=s.avgtime + s.cit
order by  date, time

select x.employee_id, x.department, x."date", x."time", x.wd, x.duration, x."zone", count(x.*)
from
(select distinct l.employee_id, l.department, l."date", l."time", l.wd, l.duration, s.motif, l."zone"
from logs l left join mbad.simple_motifs_dep s on
l.department = s.department
and l.wd = s.wd
and l."zone" = s."zone"
and l.duration >=s.avgduration -s."cid"
and l.duration<=s.avgduration+s."cid"
and l."time">=s.avgtime - s.cit
and l."time"<=s.avgtime + s.cit
order by  date, time)x
group by x.employee_id, x.department, x."date", x."time", x.wd, x.duration, x."zone"
having count(*)>1;