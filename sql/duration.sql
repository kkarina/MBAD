select t.*, (t.next_time - t.timestamp) as duration
from
(
select p.*,
 LEAD("timestamp") OVER(partition by employee_id ORDER BY "timestamp") next_time
from mbad.proxout p
)t

