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


-- typo correction
ALTER TABLE business.commission
RENAME commisstion_name to commission_name; -- So I corrected it here so I don't have to CASCADE and define FKs again


-- defining foreign keys, done separately because this is more readable for me 
ALTER TABLE business.costs_events
ADD CONSTRAINT event_c_fk FOREIGN KEY (event_id) REFERENCES business.events(event_id);

ALTER TABLE business.costs_events
ADD CONSTRAINT cost_e_fk FOREIGN KEY (cost_item_id) REFERENCES business.costs(item_id);

ALTER TABLE business.events
ADD CONSTRAINT commission_e_fk FOREIGN KEY (commission_id) REFERENCES business.commission(commission_id);

ALTER TABLE business.events
ADD CONSTRAINT place_fk FOREIGN KEY (place_id) REFERENCES business.voting_places(place_id);

ALTER TABLE business.events
ADD CONSTRAINT status_fk FOREIGN KEY (status_id) REFERENCES business.status(status_id);

ALTER TABLE business.commission_person
ADD CONSTRAINT commission_p_fk FOREIGN KEY (commission_id) REFERENCES business.commission(commission_id);

ALTER TABLE business.commission_person
ADD CONSTRAINT person_c_fk FOREIGN KEY (person_id) REFERENCES business.person(person_id);

ALTER TABLE business.person_role
ADD CONSTRAINT person_r_fk FOREIGN KEY (person_id) REFERENCES business.person(person_id);

ALTER TABLE business.person_role
ADD CONSTRAINT role_p_fk FOREIGN KEY (role_id) REFERENCES business.roles(role_id);

ALTER TABLE business.person
ADD CONSTRAINT address_p_fk FOREIGN KEY (address_id) REFERENCES business.address(address_id);

ALTER TABLE business.votes
ADD CONSTRAINT person_v_fk FOREIGN KEY (person_id) REFERENCES business.person(person_id);

ALTER TABLE business.votes
ADD CONSTRAINT group_v_fk FOREIGN KEY (group_id) REFERENCES business.election_groups(group_id);

ALTER TABLE business.voting_places
ADD CONSTRAINT address_vp_fk FOREIGN KEY (address_id) REFERENCES business.address(address_id);

ALTER TABLE business.donations
ADD CONSTRAINT person_d_fk FOREIGN KEY (person_id) REFERENCES business.person(person_id);

ALTER TABLE business.donations
ADD CONSTRAINT campaign_d_fk FOREIGN KEY (campaign_id) REFERENCES business.campaigns(campaign_id);


-- adding record_ts to each table (a column that will record the time of insertion)
ALTER TABLE business.costs
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.costs_events
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.events 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.commission 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.commission_person 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.roles 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.person_role 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.person 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.status 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.votes 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.voting_places 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.donations
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.election_groups 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.campaigns 
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;

ALTER TABLE business.address
ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;