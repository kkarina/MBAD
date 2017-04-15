create table mbad.zone_id
(id integer, zone char(15));

create table mbad.proxout
(timestamp timestamp, employee_id char (30), zone char (20));

create table mbad.employee
(id char(30), department char (50), office integer);

create table mbad.sequences
(employee_id char(30), Tstart timestamp, Tend timestamp, sequence char(255), duration interval);

create table mbad.avgDuration
(employee_id char(30), zone char(20), wd char(20), avgDuration int, numberofvisit int, sko INT);

SELECT x.timestamp as Tstart, y.timestamp as Tend, (y.timestamp - x.timestamp) as duration, x.employee_id, x.zone as zone1, y.zone as zone2

                FROM mbad.proxout x
                join mbad.proxout y
                on x.employee_id = y.employee_id
                and y.timestamp = (select min(y2.timestamp)
                            from mbad.proxout y2
                            where x.employee_id=y2.employee_id and x.timestamp<y2.timestamp);

DELETE FROM mbad.proxout;

DELETE FROM mbad.avgDuration;