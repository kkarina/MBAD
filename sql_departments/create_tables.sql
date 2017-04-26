CREATE TABLE mbad.avgDuration_dep (
  department      CHAR(30),
  zone             CHAR(20),
  wd               CHAR(20),
  avgDuration      INT,
  numberofvisit    INT,
  sko              INT,
  sko_by_avg       REAL,
  number_of_sample INT
);

CREATE TABLE mbad.avgtime_dep
(
  department      CHAR(30),
  zone             CHAR(20),
  wd               CHAR(20),
  avgTime          INT,
  numberofvisit    INT,
  sko              INT,
  sko_by_avg       REAL,
  number_of_sample INT
);
