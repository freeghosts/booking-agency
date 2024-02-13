/* create views for 3 categories of users: database admins, booking agents, and ticket sellers */


-- ticket seller: view all upcoming shows at all-ages venues 
-- simplifies a complex query & increases security by hiding sensitive information, (e.g. artist contact info) 
CREATE OR REPLACE VIEW all_ages_shows_view AS
	SELECT DATE_FORMAT(show_date, '%m-%d-%Y') AS show_date,
		TIME_FORMAT(show_time, '%r') AS show_time,
		artist_name, genre, venue_name,
		CONCAT(address, ', ', v.city, ', ', v.state, ' ', zip) AS address,
        special_notes, ticket_price,
        total_tickets - tickets_sold AS available_tickets
	FROM artists a
		JOIN shows s
			ON a.artist_id = s.artist_id
		JOIN venues v
			ON s.venue_id = v.venue_id
	WHERE age_restrictions = 'all ages'
		AND show_date >= CURDATE()
	ORDER BY EXTRACT(YEAR_MONTH FROM show_date), EXTRACT(DAY FROM show_date), show_time;

SELECT * FROM all_ages_shows_view;


-- booking agent: see remaining venue capacity for shows where 80% or more of tickets are sold
-- simplifies a complex query and shows customized data; updateable 
CREATE OR REPLACE VIEW ticket_status_view AS
	SELECT show_date, artist_id, v.venue_id, venue_name,
		capacity - total_tickets AS remaining_capacity,
		total_tickets - tickets_sold AS available_tickets,
        total_tickets
	FROM shows s JOIN venues v
		ON s.venue_id = v.venue_id
	WHERE capacity - total_tickets > 0
		AND (tickets_sold / total_tickets) * 100 >= 80;
    
SELECT * FROM ticket_status_view;    


-- database admin: view managers' names and contact information from venues table
-- hypothetically, managers might be given limited access to database in order to view shows at their venues 
-- as well as verify that their venue and contact information is accurate 
-- provides customized information; updateable
CREATE VIEW venue_contacts_view AS
	SELECT venue_id, venue_name, main_phone, mgr_last_name, mgr_first_name, email, mgr_phone
	FROM venues
WITH CHECK OPTION;

SELECT * FROM venue_contacts_view; 