update mbad.employee x set zone = '1-1'
from (select * from mbad.zone_office )t
where x.office = t.office;

update mbad.proxout_mc2  set "zone" = 'Server'
where "zone" = ' Server Room'

select * from mbad.proxout_mc2


