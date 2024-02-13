
-- create database
DROP DATABASE IF EXISTS booking_agency;
CREATE DATABASE booking_agency;

-- select database
USE booking_agency;

-- create tables
CREATE TABLE artists
(
	artist_id			INT				PRIMARY KEY		AUTO_INCREMENT,
    artist_name			VARCHAR(100)	NOT NULL,
    record_label		VARCHAR(100),
    genre				VARCHAR(50),
    contact_first_name	VARCHAR(50),
    contact_last_name	VARCHAR(50),
    email				VARCHAR(50)		NOT NULL,
    country_code		VARCHAR(10),
    phone				VARCHAR(40),
    city				VARCHAR(50)		NOT NULL,
    state				CHAR(2),
    country				VARCHAR(50)		NOT NULL
);

CREATE TABLE venues
(
	venue_id			INT 			PRIMARY KEY		AUTO_INCREMENT,
    venue_name			VARCHAR(140)	NOT NULL,
    address				VARCHAR(50)		NOT NULL,
    city				VARCHAR(50)		NOT NULL,
    state				CHAR(2)			NOT NULL,
    zip					VARCHAR(20)		NOT NULL,
    main_phone			VARCHAR(20)		NOT NULL,
    mgr_first_name		VARCHAR(50),
    mgr_last_name		VARCHAR(50),
    mgr_phone			VARCHAR(20),
    email				VARCHAR(50),
    age_restrictions	VARCHAR(50)		NOT NULL,
    capacity			INT
);

CREATE TABLE shows
(
	artist_id			INT 			NOT NULL,
    venue_id			INT				NOT NULL,
    show_date			VARCHAR(50)		NOT NULL,
    show_time			VARCHAR(50)		NOT NULL,
    ticket_price		DECIMAL(9,2)	NOT NULL,
    total_tickets		INT				NOT NULL,
    tickets_sold		INT 							DEFAULT 0,
    special_notes		VARCHAR(140),
    CONSTRAINT shows_pk 
		PRIMARY KEY (artist_id, venue_id, show_date),
	CONSTRAINT shows_fk_artist
		FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id),
	CONSTRAINT shows_fk_venue
		FOREIGN KEY (venue_id)
        REFERENCES venues (venue_id)
);

-- create indexes
CREATE INDEX artists_city_country_ix
	ON artists (city, country);
    
CREATE INDEX venues_city_state_ix
	ON venues (city, state);