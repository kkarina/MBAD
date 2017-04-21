select x.prox_id, x.zone, round(avg(x.duration)) as mean,  count(zone), round(stddev_pop(x.duration)) as stdev
from
(select t.*, extract(epoch from t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by prox_id ORDER BY "timestamp") next_time
from mbad.proxout_mc2 p
)t) x
group by prox_id, zone
order by prox_id, zone



select prox_id,
	   "floor"||'-'||substring ("zone" from 2) as "zone",
       ("timestamp")::date as "date",
       date_part  ('hour',"timestamp")*3600+date_part  ('minute', "timestamp")*60+date_part ('second', "timestamp") as "time",
       extract(epoch from t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by prox_id ORDER BY "timestamp") next_time
from mbad.proxout_mc2 p
)t


