select z.* from
(select x.employee_id, x.zone, round(avg(x.duration)) as mean,  count(zone), round(stddev_pop(x.duration)) as stdev
from
(select t.*, extract(epoch from t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by employee_id ORDER BY "timestamp") next_time
from mbad.proxout p
)t) x
group by employee_id, zone
order by employee_id, zone) z
where mean < stdev