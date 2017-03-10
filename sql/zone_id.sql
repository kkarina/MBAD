create table mbad.zone_id
(id integer, zone char(15));

create table mbad.proxout
(timestamp timestamp, employee_id char (30), zone char (20));

create table mbad.employee
(id char(30), department char (50), office integer);

create table mbad.sequences
(employee_id char(30), Tstart timestamp, Tend timestamp, sequence char(255), duration interval)