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
    jiwjiji          text,
    population     bigint,
    elevation       bigint, 
    dem             bigint,
    timezone        text,
    modification    date
);
\copy rawgeonames from '/var/local/cs4443/geonames/allCountries.txt' with csv delimiter E'\t' WHERE geonameid != 8376355

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
   country_codes            text,
   country_timezone        text,
   country_gst             float,
   country_dst             float,
   country_globaloffset    float
);

\copy rawtime from '/var/local/cs4443/geonames/timeZones.txt' delimiter E'\t' csv header

CREATE TABLE rawfeature(
   feature_codes            text,
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

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE DOMAIN testbool AS INT CHECK(value = 0 or value = 1 or value is null);

CREATE TABLE continents(
   continent_id    serial  NOT NULL,
   abrriviation    char(2) NOT NULL,
   name            text    NOT NULL    UNIQUE,
   PRIMARY KEY(continent_id)
);


INSERT INTO continents(abrriviation, name)
   values
       ('AF', 'Africa'),
       ('NA', 'North America'),
       ('OC', 'Oceania'),
       ('AN', 'Antarctica'),
       ('AS', 'Asia'),
       ('EU', 'Europe'),
       ('SA', 'South America');


CREATE TABLE timezones(
   timezone_id     serial  NOT NULL,
   country_code    char(2),
   timezone_name            text    NOT NULL    UNIQUE,
   offsets    float   NOT NULL,
   PRIMARY KEY(timezone_id)         
);


INSERT INTO timezones(country_code, timezone_name, offsets)
   SELECT  DISTINCT country_codes, country_timezone, country_globaloffset
   FROM    rawtime
   WHERE   country_timezone IS NOT NULL;

CREATE TABLE features(
   feature_id      serial  NOT NULL,
   code            text    NOT NULL    UNIQUE,
   description     text    NOT NULL,
   PRIMARY KEY(feature_id)
);


INSERT INTO features(code, description)
   SELECT  DISTINCT feature_codes, feature_description
   FROM    rawfeature
   WHERE   feature_codes <> 'null';

CREATE TABLE coordinates(
   coordinates_id        serial      NOT NULL,
   longitude       double precision NOT NULL,
   latitude        double precision NOT NULL,
   PRIMARY KEY(coordinates_id)
);

INSERT INTO coordinates(longitude, latitude)
   SELECT  longitude, latitude
   FROM    rawgeonames
   WHERE   longitude IS NOT NULL AND latitude IS NOT NULL;

   CREATE TABLE currency(
   currency_id     serial  NOT NULL,
   currency_code            text    NOT NULL    UNIQUE,
   currency_name            text    NOT NULL,
   PRIMARY KEY(currency_id)
);

INSERT INTO currency(currency_code, currency_name)
   SELECT  DISTINCT currency_code, currency_name
   FROM    rawcountry
   WHERE   currency_code IS NOT NULL AND currency_name IS NOT NULL;

CREATE TABLE countries(
   country_id      serial  NOT NULL,
   geoname_id      bigint      NOT NULL,
   iso             text    NOT NULL,
   iso3            text    NOT NULL,
   iso_code        text    NOT NULL    UNIQUE,
   fips            text,
   name            text    NOT NULL,
   capital         text,
   area            double precision NOT NULL,
   population      BIGINT NOT NULL,
   tld             text,
   currency_id     bigint      NOT NULL,
   languages       text,      
   neighbors       text,
   PRIMARY KEY(country_id),
   FOREIGN KEY (currency_id) REFERENCES currency(currency_id)
);


INSERT INTO countries(geoname_id, iso, iso3, iso_code, fips, name, capital, area, population, tld, currency_id, languages, neighbors)
   SELECT  geonameid, iso, iso3, isocode, fips, name, capital, area, population, tld, 1, languages, neighbors
   FROM rawcountry;

CREATE TABLE geonames(
   geoname_id      bigint      NOT NULL,
   geoname         text    NOT NULL,
   coordinates_id        bigint      NOT NULL,
   feature_id      bigint      NOT NULL,
   country_id      bigint      NOT NULL,
   population      bigint     NOT NULL,
   elevation       double precision NOT NULL,
   timezone_id     bigint      NOT NULL, 
   PRIMARY KEY(geoname_id),
   FOREIGN KEY(feature_id) REFERENCES features(feature_id),
   FOREIGN KEY(country_id) REFERENCES countries(country_id),
   FOREIGN KEY(timezone_id) REFERENCES timezones(timezone_id),
   FOREIGN KEY(coordinates_id) REFERENCES coordinates(coordinates_id)
);

CREATE TABLE languages(
   language_id     serial  NOT NULL,
   language_name            text    NOT NULL UNIQUE,
   language_iso1 text  UNIQUE NOT NULL,
   PRIMARY KEY(language_id)
);


INSERT INTO languages(language_name,language_iso1)
   SELECT  language_name,language_iso1
   FROM rawlanguage
   WHERE language_name IS NOT NULL and language_iso1 IS NOT NULL;

CREATE TABLE boundry(
   boundry_id      serial    NOT NULL,
   iso_code         text      NOT NULL,
   neighbor        text      NOT NULL,
   PRIMARY KEY(boundry_id)
);

INSERT INTO boundry(iso_code, neighbor)
   WITH n AS (
       SELECT isocode,
           REGEXP_SPLIT_TO_TABLE(neighbors, ',') AS neighbor
       FROM rawcountry
       where isocode IS NOT NULL and neighbors IS NOT NULL
   )
   SELECT isocode, neighbor
   FROM n
   WHERE neighbor IS NOT NULL AND isocode IS NOT NULL;

CREATE TABLE alternate(
   alt_id          serial  NOT NULL,
   geoname_id      bigint      NOT NULL,
   language_id     text NOT NULL,
   alt_name        text    NOT NULL,
   prefered        text,
   short           text,
   collquial       text,
   historic        text,
   _from       text,
   _to         text,
   PRIMARY KEY(alt_id),
   FOREIGN KEY(geoname_id) REFERENCES geonames(geoname_id),
   FOREIGN KEY(language_id) REFERENCES languages(language_iso1)
);

INSERT INTO alternate(alt_id,geoname_id,language_id,alt_name,prefered,short,collquial,historic,_from,_to)
   SELECT alternate_altid,alternate_geoid,alternate_isolang,alternate_name,
   alternate_prefered,
   alternate_short,
   alternate_collquial,
   alternate_historic,
   alternate_f,
   alternate_t
   FROM rawalternate;

CREATE TABLE hierarchy(
   hierarchy_id    serial  NOT NULL,
   parent          bigint      NOT NULL,
   child           bigint      NOT NULL,
   heirarchy_code            text    NOT NULL,
   PRIMARY KEY(hierarchy_id),
   FOREIGN KEY(parent) REFERENCES geonames(geoname_id),
   FOREIGN KEY(child) REFERENCES geonames(geoname_id)
);

INSERT INTO hierarchy(parent, child, heirarchy_code)
   SELECT heirarchy_parent, heirarchy_child, heirarchy_code
   FROM rawhierarchy where heirarchy_code IS NOT NULL;



DROP TABLE rawcountry;
DROP TABLE rawfeature;
--DROP TABLE rawgeonames;
DROP TABLE rawtime;
DROP TABLE rawalternate;
DROP TABLE rawlanguage;
DROP TABLE rawhierarchy;