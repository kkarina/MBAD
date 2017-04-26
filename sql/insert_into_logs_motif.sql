SELECT
  l.*,
  sm.motif
FROM mbad.logs l, mbad.simple_motifs
  LEFT JOIN mbad.simple_motifs sm
    ON (l.employee_id = sm.employee_id
       AND l.zone = sm.zone
       AND l.duration >= .8*sm.avgduration
       AND l.duration <=1.2* sm.avgduration
       AND l.time >= 0.8*sm.avgtime
       AND l.time <= 1.2*sm.avgtime
       AND to_char(l.date, 'Day') = sm.wd);


SELECT count(*) FROM mbad.logs