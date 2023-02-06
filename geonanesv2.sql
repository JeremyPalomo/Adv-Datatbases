create table raw.admin1
(
  code text,
  name text,
  ascii_name text,
  geonameid bigint,
);
\copy raw.admin1 from 'admin1CodesASCII.txt' with csv delimiter E'\t'
