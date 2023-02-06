CREATE TABLE geonames(
   geoname_id BIGINT PRIMARY KEY NOT NULL,
   name TEXT NOT NULL,
   mod_date date NOT NULL,
	UNIQUE(geoname_id)
);

CREATE TABLE time(
country_code TEXT NOT NULL,
time_id TEXT  PRIMARY KEY NOT NULL,
gmt REAL NOT NULL,
offset_2023 REAL NOT NULL,
raw_offset REAL NOT NULL,
	UNIQUE(time_id)
);

CREATE TABLE boundary(
   	geoname_id BIGINT PRIMARY KEY NOT NULL,
	boundaries json NOT NULL,
	FOREIGN KEY(geoname_id) 
	REFERENCES boundary(geoname_id),
	UNIQUE(geoname_id)
);

CREATE TABLE currency(
   	geoname_id BIGINT PRIMARY KEY NOT NULL,
	currency_code TEXT NOT NULL,
	currency_name TEXT NOT NULL,
	FOREIGN KEY(geoname_id) 
	REFERENCES currency(geoname_id),
	UNIQUE(geoname_id)
);

CREATE TABLE country(
	iso TEXT NOT NULL,
	iso3 TEXT NOT NULL,
	iso_numeric TEXT NOT NULL,
	fips TEXT NOT NULL,
	country TEXT,
	capital TEXT,
	area BIGINT NOT NULL,
	population BIGINT NOT NULL,
	continent TEXT NOT NULL,
	Tld TEXT NOT NULL,
	Phone TEXT,
	postal_code_format TEXT,
	postal_code_regex TEXT,
	languages TEXT,
	geoname_id BIGINT NOT NULL,
	neighbors TEXT,
	Equivalent_fips_code TEXT,
	FOREIGN KEY (geoname_id) 
	REFERENCES country(geoname_id),
	UNIQUE(geoname_id)
);

CREATE TABLE admin1(
	admin1_code TEXT UNIQUE PRIMARY KEY NOT NULL,
	admin1_name TEXT NOT NULL,
	geoname_id BIGINT NOT NULL,
	FOREIGN KEY (geoname_id) 
	REFERENCES admin1(geoname_id),
	UNIQUE(geoname_id)
);

CREATE TABLE admin2(
	admin2_code TEXT UNIQUE PRIMARY KEY NOT NULL,
	admin2_name TEXT NOT NULL,
	geoname_id BIGINT NOT NULL,
	FOREIGN KEY (geoname_id) 
	REFERENCES admin2(geoname_id),
	UNIQUE(geoname_id)
);

CREATE TABLE languages(
	iso_language_code TEXT PRIMARY KEY NOT NULL,
	iso_language TEXT NOT NULL,
	UNIQUE(iso_language_code)
);


CREATE TABLE alternate_names(
	geoname_id BIGINT PRIMARY KEY NOT NULL,
	alternate_name TEXT NOT NULL,
	iso_language_code TEXT,
	FOREIGN KEY (geoname_id) 
	REFERENCES alternate_names(geoname_id),
FOREIGN KEY (iso_language_code) 
	REFERENCES languages(iso_language_code),
	UNIQUE(geoname_id)
);

CREATE TABLE region(
	iso_language_code TEXT PRIMARY KEY NOT NULL,
	iso_language TEXT NOT NULL,
	UNIQUE(iso_language_code)
);

CREATE TABLE place(
	iso_language_code TEXT PRIMARY KEY NOT NULL,
	iso_language TEXT NOT NULL,
	UNIQUE(iso_language_code)
);

CREATE TABLE hierarchy (
	admin1_code TEXT UNIQUE NOT NULL REFERENCES hierarchy(admin1_code), 
admin2_code TEXT  UNIQUE NOT NULL REFERENCES hierarchy(admin2_code), 
type TEXT,
PRIMARY KEY(admin1_code, admin2_code)
);


Drop table geonames,time,boundary,currency, languages, admin1, admin2, alternate_names, country, hierarchy cascade;


