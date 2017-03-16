select x.employee_id, x.zone, avg(x.duration),  count(zone), round(stddev(x.duration))
from
(select t.*, extract(epoch from t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by employee_id ORDER BY "timestamp") next_time
from mbad.proxout p
)t) x
where employee_id
group by employee_id, zone
order by employee_id, zone