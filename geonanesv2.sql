CREATE TABLE rawgeonames(
    geonameid       BIGINT,
    name            text,
    asciiname       text,
    alternames      text,
    latitude        double precision,
    longitude       double precision,
    class           text,
    code            text,
    cc2             text,
    admin1          text,
    admin2          text,
    admin3          text,
    admin4          text,
    population     bigint,
    elevation       bigint,
    dem             bigint,
    timezone        text,
    modification    date
);


CREATE TABLE rawcountry(
    iso             text,
    iso3            text,
    isocode         int,
    fips            text,
    name            text,
    capital         text,
    area            double precision,
    population      bigint,
    continent       text,
    tld             text,
    currency_code   text,
    currency_name   text,
    phone           text,
    postalcodef     text,
    postalcoder     text,
    languages       text,
    geonameid       bigint,
    neighbors       text,
    fips_equiv      text
);

\copy rawcountry from '/var/local/cs4443/geonames/countryInfo2.txt' with csv delimiter E'\t'

