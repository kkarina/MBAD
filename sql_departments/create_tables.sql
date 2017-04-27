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

CREATE TABLE mbad.simple_motifs_dep
(
  department       CHAR(30),
  zone             CHAR(20),
  wd               CHAR(20),
  number_of_sample INT,
  avgduration      INT,
  numberofvisit    INT,
  duration_sko     INT,
  avgtime          INT,
  time_sko         INT,
  motif            CHAR(100),
  "cid"            REAL,
  cit              REAL,
  work_place       boolean
);

CREATE TABLE mbad.simple_motifs_dep_1v
(
  department       CHAR(30),
  zone             CHAR(20),
  wd               CHAR(20),
  number_of_sample INT,
  avgduration      INT,
  numberofvisit    INT,
  duration_sko     INT,
  avgtime          INT,
  time_sko         INT,
  motif            CHAR(100),
  "cid"            REAL,
  cit              REAL,
  work_place       boolean
);
