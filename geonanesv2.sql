create table admin1
(
  code text,
  name text,
  ascii_name text,
  geonameid bigint,
);
\copy admin1 from '/var/local/cs4443/geonames/admin1CodesASCII.txt' with csv delimiter E'\t'
