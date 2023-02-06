CREATE TABLE admin1_temp (
  code text,
  name text,
  ascii_name text,
  geonameid bigint
);
\copy admin1_temp from '/var/local/cs4443/geonames/admin1CodesASCII.txt' with csv delimiter E'\t'

CREATE TABLE admin2_temp (
  code text,
  name text,
  ascii_name text,
  geonameid bigint
);
\copy admin2_temp from '/var/local/cs4443/geonames/admin2Codes.txt' with csv delimiter E'\t'

create table feature_temp (
    code text,
    description text,
    comment text
);
\copy feature_temp from '/var/local/cs4443/geonames/featureCodes_en.txt' with csv delimiter E'\t'

create table country_temp(
    iso text,
    iso3 text,
    isocode integer,
    fips text,
    name text,
    capital text,
    area double precision,
    population bigint,
    continent text,
    tld text,
    currency_code text,
    currency_name text,
    phone text,
    postal_code_format text,
    postal_code_regex text,
    languages text,
    geonamesid bigint,
    neighbors text,
    fips_equiv text
);
\copy country_temp from '/var/local/cs4443/geonames/countryInfo2.txt' with csv delimiter E'\t'