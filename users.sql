
-- create users
CREATE USER tamika@localhost IDENTIFIED BY '123456'; 
CREATE USER carlos IDENTIFIED BY '987654';
CREATE USER cecil IDENTIFIED BY 'password';


-- grant global privileges to database admin (tamika)
-- has full access with GRANT OPTION so DBA can manage and maintain all databases
-- restricted to using local host for security 
GRANT ALL 
ON *.*
TO tamika@localhost
WITH GRANT OPTION;

-- grant database privileges to booking agent (carlos)
-- booking agent is primary contact for artists and venue managers so they may view and alter data 
-- may connect remotely, but only has access to booking_agency database
GRANT SELECT, INSERT, UPDATE, DELETE
ON booking_agency.*
TO carlos
WITH GRANT OPTION;

-- grant table and column privileges to ticket seller (cecil)
-- only interacts with customers buying tickets and can only SELECT columns in booking_agency db necessary to do their job, 
-- may connect remotely, but access is limited to keep user from sharing sensitive information with general public, (e.g. artist contact info)
GRANT SELECT (artist_id, artist_name, record_label, genre, city, state, country)
ON booking_agency.artists
TO cecil; 

GRANT SELECT (venue_id, venue_name, address, city, state, zip, main_phone, age_restrictions, capacity)
ON booking_agency.venues
TO cecil;

GRANT SELECT
ON booking_agency.shows
TO cecil;

GRANT SELECT
ON booking_agency.all_ages_shows_view
TO cecil;