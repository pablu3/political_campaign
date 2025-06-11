CREATE SCHEMA business;

-- creating tables
CREATE TABLE business.costs (
	item_id SERIAL PRIMARY KEY, -- serial will be used for every PK as it auto-increments the ID
	item_description VARCHAR(150),
	price_per_unit NUMERIC(10,2) NOT NULL,
	CHECK (price_per_unit > 0)
);

CREATE TABLE business.costs_events (
	event_id INT NOT NULL,
	cost_item_id INT NOT NULL,
	quantity INT NOT NULL,
	CHECK (quantity > 0)
);

CREATE TABLE business.events (
	event_id SERIAL PRIMARY KEY,
	commission_id INT,
	place_id INT NOT NULL,
	event_name VARCHAR(100) NOT NULL,
	event_description VARCHAR(300),
	start_date TIMESTAMP NOT NULL DEFAULT current_timestamp,
	end_date TIMESTAMP,
	status_id INT NOT NULL,
	CHECK (start_date > '2000-01-01'),
	CHECK (end_date > start_date)
);

CREATE TABLE business.commission (
	commission_id SERIAL PRIMARY KEY,
	commisstion_name VARCHAR(100) NOT NULL -- I made a typo that I noticed during inserting
);

CREATE TABLE business.commission_person (
	commission_id INT NOT NULL,
	person_id INT NOT NULL,
	start_date TIMESTAMP NOT NULL DEFAULT current_timestamp,
	end_date TIMESTAMP,
	CHECK (start_date > '2000-01-01'),
	CHECK (end_date > start_date)
);

CREATE TABLE business.roles (
	role_id SERIAL PRIMARY KEY,
	role_name VARCHAR(100) NOT NULL,
	role_description VARCHAR(300)
);

CREATE TABLE business.person_role (
	person_id INT NOT NULL,
	role_id INT NOT NULL,
	start_date DATE NOT NULL DEFAULT current_date,
	end_date DATE,
	CHECK (start_date > '2000-01-01'),
	CHECK (end_date > start_date)
);

CREATE TABLE business.person (
	person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(200) NOT NULL,
	full_name VARCHAR(302) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED, 
	gender VARCHAR(1),
	phone_number VARCHAR(12) UNIQUE NOT NULL,
	address_id INT NOT NULL,
	CHECK (phone_number ~ '^\+\d{11}$'), 
	CHECK (gender IN ('M', 'F'))
);

CREATE TABLE business.status (
	status_id SERIAL PRIMARY KEY,
	short_description VARCHAR(100) NOT NULL,
	full_description VARCHAR(500)
);

CREATE TABLE business.votes (
	vote_id SERIAL PRIMARY KEY,
	person_id INT NOT NULL,
	group_id INT NOT NULL,
	vote_date DATE NOT NULL DEFAULT current_date
);

CREATE TABLE business.voting_places (
	place_id SERIAL PRIMARY KEY,
	place_name VARCHAR(150) NOT NULL,
	address_id INT NOT NULL
);

CREATE TABLE business.donations (
	donation_id SERIAL PRIMARY KEY,
	person_id INT NOT NULL,
	campaign_id INT,
	amount_donated NUMERIC(10,2) NOT NULL,
	donation_date DATE NOT NULL DEFAULT current_date,
	CHECK (amount_donated > 0)
);

CREATE TABLE business.election_groups (
	group_id SERIAL PRIMARY KEY,
	group_name VARCHAR(150) NOT NULL UNIQUE,
	date_created DATE,
	CHECK (date_created < current_date)
);

CREATE TABLE business.campaigns (
	campaign_id SERIAL PRIMARY KEY,
	campaign_name VARCHAR(150) NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP,
	CHECK (CAST(start_date AS DATE) > '2000-01-01'),
	CHECK (end_date > start_date)
);


CREATE TABLE business.address (
	address_id SERIAL PRIMARY KEY,
	city VARCHAR(120) NOT NULL,
	street VARCHAR(150) NOT NULL,
	house_number VARCHAR(15) NOT NULL,
	flat_number VARCHAR(15),
	postal_code VARCHAR(6) NOT NULL,
	CHECK (postal_code ~ '^\d{2}-\d{3}$') -- same case as phone number - I know that not every postal code looks like this
);