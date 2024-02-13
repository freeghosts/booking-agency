
/* ***** TICKET SELLER (cecil) ***** */

-- see all upcoming shows in austin, tx at all-ages venues
SELECT *
FROM all_ages_shows_view
WHERE address REGEXP 'Austin'
	AND available_tickets > 0;

-- display all shows occurring in Jan.2017 in Hot Springs, AR
SELECT show_date, 
	TIME_FORMAT(show_time, '%r') AS show_time, 
    artist_name, genre, venue_name, 
	CONCAT(address, ', ', zip) AS address, 
	age_restrictions, special_notes,
    total_tickets - tickets_sold AS available_tickets
FROM artists a
	JOIN shows s
		ON a.artist_id = s.artist_id
	JOIN venues v
		ON s.venue_id = v.venue_id
WHERE v.city IN ('Hot Springs')
	AND EXTRACT(YEAR_MONTH FROM show_date) = 201701
ORDER BY artist_name, show_date;

-- display all shows in tx with ticket prices less than 20.00
SELECT show_date, show_time, a.artist_id, artist_name, v.venue_id, venue_name, ticket_price
FROM artists a
	JOIN shows s USING (artist_id)
    JOIN venues v USING (venue_id)
WHERE ticket_price <= 20.00
	AND venue_id IN
		(SELECT venue_id
		 FROM venues
         WHERE state = 'TX'
		 GROUP BY venue_id)
ORDER BY ticket_price DESC;

-- show all artists whose genre is a type of rock
SELECT artist_id, artist_name, record_label, genre
FROM artists
WHERE genre REGEXP 'rock'
ORDER BY genre, artist_name;

-- show artists from countries other than the US who have upcoming shows
SELECT show_date, a.artist_id, artist_name, genre, 
	CONCAT_WS(', ', a.city, country) AS artist_location, 
	v.venue_id, venue_name, 
	CONCAT(address, ', ', v.city, ', ', v.state, ' ', zip) AS venue_address
FROM artists a
	JOIN shows s
		ON a.artist_id = s.artist_id
	JOIN venues v
		ON s.venue_id = v.venue_id
WHERE a.country NOT IN ('USA')
	AND show_date >= CURDATE()
ORDER BY country, a.city;



/* ***** BOOKING AGENT (carlos) ***** */

-- show ticket sales for a particular month by venue
SELECT venue_id, COUNT(*) AS dec_shows_qty,
	SUM(tickets_sold * ticket_price) AS december2016_sales
FROM shows 
WHERE show_date BETWEEN '2016-12-01' AND '2016-12-31'
GROUP BY venue_id;

-- show all venue managers who don’t have a phone number listed
SELECT CONCAT_WS(', ', mgr_last_name, mgr_first_name) AS manager_name, 
	email, venue_id, venue_name, main_phone,
	CONCAT_WS(', ', city, state) AS location
FROM venues
WHERE mgr_phone IS NULL
ORDER BY mgr_last_name, mgr_first_name;

-- add new show to shows table 
INSERT shows VALUES
	(11, 18, '2016-02-29', '20:30:00', 28.00, 300, 300, NULL); 
    
SELECT * FROM shows;

-- update an artist's genre
UPDATE artists
SET genre = 'cloud rap'
WHERE artist_id = 9;

SELECT * FROM artists;

-- add tickets to shows where 80% or more of tickets have been sold and venue is not at full capacity
UPDATE ticket_status_view
SET total_tickets = total_tickets + (remaining_capacity DIV 2)
WHERE remaining_capacity > 0; 

SELECT * FROM ticket_status_view;



/* ***** DATABASE ADMIN (tamika) ***** */

-- view log files for slow queries
SELECT * 
FROM mysql.slow_log;

-- get information about a system variable
SELECT @@GLOBAL.long_query_time, @@SESSION.long_query_time;

-- show grants for current user
SHOW GRANTS;

-- delete data for shows that happened more than 6 months ago
DELETE FROM shows
WHERE DATEDIFF(CURDATE(), show_date) > (365 / 2);

SELECT * FROM shows;

-- export venue manager contact information to an external text file
SELECT *
INTO OUTFILE 'venues_contact_list.txt' 
FROM venue_contacts_view;
