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

CREATE TABLE rawalternate(
   alternate_altid           int,
   alternate_geoid           int,
   alternate_isolang         text,
   alternate_name            text,
   alternate_prefered        int,
   alternate_short           int,
   alternate_collquial       int,
   alternate_historic        int,
   alternate_f               text,
   alternate_t               text
);


\copy rawalternate from '/var/local/cs4443/geonames/alternateNamesV2.txt' with csv delimiter E'\t'

CREATE TABLE rawlanguage(
   language_iso3        text,
   language_iso2        text,
   language_iso1        text,
   language_name        text
);

\copy rawlanguage from '/var/local/cs4443/geonames/iso-languagecodes.txt' delimiter E'\t' csv header

CREATE TABLE rawtime(
   country_code            text,
   country_timezone            text,
   country_gst             float,
   country_dst             float,
   country_globaloffset    float
);

\copy rawtime from '/var/local/cs4443/geonames/timeZones.txt' delimiter E'\t' csv header

CREATE TABLE rawfeature(
   feature_code            text,
   feature_description     text,
   feature_description_two text
);

\copy rawfeature from '/var/local/cs4443/geonames/featureCodes_en.txt' with csv delimiter E'\t'

CREATE TABLE rawhierarchy(
   heirarchy_parent       BIGINT,
   heirarchy_child       BIGINT,
   heirarchy_code        text
);


\copy rawhierarchy from '/var/local/cs4443/geonames/hierarchy.txt' with csv delimiter E'\t'