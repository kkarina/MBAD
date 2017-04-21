update mbad.employee x set zone = t.zone
from (select * from mbad.zone_office )t
where x.office = t.office;

update mbad.proxout_mc2  set "zone" = 'Server'
where "zone" = ' Server Room'

select * from mbad.proxout_mc2

select *
from mbad.logs
order by duration

update mbad.logs set duration = 0
where duration is null

delete  from mbad.logs

select count (*)
from mbad.logs
where duration is null


delete from mbad.simple_motifs
where numberofvisit = 1 and avgduration !=0

select count (*) from mbad.simple_motifs