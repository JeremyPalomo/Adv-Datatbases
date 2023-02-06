begin;

CREATE TABLE raw.geonames (
    geoname_id bigint,
    name text,
    ascii_name text,
    alternate_names text,
    latitude double precision,
    longitude double precision,
    f_class text,
    f_code text,
    cc1 text,
    cc2 text,
    admin1 text,
    admin2 text,
    admin3 text,
    admin4 text,
    population bigint,
    elevation bigint,
    dem bigint,
    time text,
    mod_date date
);
load csv
  from /tmp/geonames/allCountries.txt
  into pgsql://appdev@/appdev
  target table raw.geonames
  with fields terminated by '\t',
       fields optionally enclosed by '§',fields escaped by '%',
       truncate;
commit;