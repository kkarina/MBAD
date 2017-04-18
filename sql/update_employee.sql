update mbad.employee x set zone = '1-1'
from (select * from mbad.zone_office )t
where x.office = t.office