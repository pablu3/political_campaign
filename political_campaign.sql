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
	commisstion_name VARCHAR(100) NOT NULL -- I made a typo that I noticed during inserting, fixed below
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
	CHECK (phone_number ~ '^\+\d{11}$'), -- polish phone number format "+48_________"
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
	CHECK (postal_code ~ '^\d{2}-\d{3}$') -- polish postal code format "__-___"
);

-- typo correction
ALTER TABLE business.commission
RENAME commisstion_name to commission_name;



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



-- inserting rows
INSERT INTO business.costs (item_description, price_per_unit)
VALUES
	('Campaign banners', 45.99),
	('Paper stack', 5.99);

INSERT INTO business.roles (role_name, role_description)
VALUES
	('Organizer', 'The person responsible for event organisation and managing problems related to the event.'),
	('Representative', 'The person responsible for event representation in public media and marketing campaigns.');

INSERT INTO business.election_groups (group_name, date_created)
VALUES
	('Huge democrats', '2012-03-13'),
	('Small democrats', '2021-05-14');

INSERT INTO business.address (city, street, house_number, flat_number, postal_code)
VALUES
	('Oslo', 'Torgatta', '16', NULL, '80-333'),
	('Trondheim', 'Sandgata', '11a', '15', '75-567');

INSERT INTO business.campaigns (campaign_name, start_date, end_date)
VALUES
	('We love dogs!', '2023-01-01 12:00:00', '2023-01-03 18:00:00'),
	('We love cows!', '2022-12-01 08:00:00', '2022-12-31 22:00:00');

INSERT INTO business.status (short_description, full_description)
VALUES
	('OK', 'The event is going as planned. No issues identified.'),
	('Postponed', 'The start date of the event is delayed due to complications.');

INSERT INTO business.person (first_name, last_name, gender, phone_number, address_id)
VALUES 
	('Pablo', 'Escobear', 'M', '+67987678654', (SELECT address_id FROM business.address 
							WHERE UPPER(city) = 'OSLO' 
							AND UPPER(street) = 'TORGATTA' 
							AND house_number = '16'
							AND postal_code = '80-333')),
	('Claudia', 'Aidualc', 'F', '+38120175654', (SELECT address_id FROM business.address
							WHERE UPPER(city) = 'TRONDHEIM' 
							AND UPPER(street) = 'SANDGATA' 
							AND UPPER(house_number) = '11A'
							AND postal_code = '75-567'));

INSERT INTO business.votes (person_id, group_id, vote_date)
VALUES
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'PABLO' AND UPPER(last_name) = 'ESCOBEAR'),
	 (SELECT group_id FROM business.election_groups WHERE UPPER(group_name) = 'HUGE DEMOCRATS'), '2022-09-21'),
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'CLAUDIA' AND UPPER(last_name) = 'AIDUALC'),
	 (SELECT group_id FROM business.election_groups WHERE UPPER(group_name) = 'SMALL DEMOCRATS'), '2022-09-22');

INSERT INTO business.donations (person_id, campaign_id, amount_donated, donation_date)
VALUES
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'PABLO' AND UPPER(last_name) = 'ESCOBEAR'),
	 (SELECT campaign_id FROM business.campaigns WHERE UPPER(campaign_name) = 'WE LOVE DOGS!'), 200.00, '2015-09-17'),
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'CLAUDIA' AND UPPER(last_name) = 'AIDUALC'),
	 (SELECT campaign_id FROM business.campaigns WHERE UPPER(campaign_name) = 'WE LOVE COWS!'), 15000.00, '2017-09-21');

INSERT INTO business.person_role (person_id, role_id, start_date, end_date)
VALUES
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'PABLO' AND UPPER(last_name) = 'ESCOBEAR'),
	 (SELECT role_id FROM business.roles WHERE UPPER(role_name) = 'REPRESENTATIVE'), '2022-01-01', '2022-01-03'),
	((SELECT person_id FROM business.person WHERE UPPER(first_name) = 'CLAUDIA' AND UPPER(last_name) = 'AIDUALC'),
	 (SELECT role_id FROM business.roles WHERE UPPER(role_name) = 'REPRESENTATIVE'), '2022-07-01', '2022-07-12');

INSERT INTO business.commission (commission_name)
VALUES ('Big commission'), ('Small commission');

INSERT INTO business.voting_places (place_name, address_id)
VALUES
	('Huge School', (SELECT address_id FROM business.address 
							WHERE UPPER(city) = 'OSLO' 
							AND UPPER(street) = 'TORGATTA' 
							AND house_number = '16'
							AND postal_code = '80-333')),
	('Small School', (SELECT address_id FROM business.address
							WHERE UPPER(city) = 'TRONDHEIM' 
							AND UPPER(street) = 'SANDGATA' 
							AND UPPER(house_number) = '11A'
							AND postal_code = '75-567'));

INSERT INTO business.events (commission_id, place_id, event_name, event_description, start_date, end_date, status_id)
VALUES
	((SELECT commission_id FROM business.commission WHERE UPPER(commission_name) = 'BIG COMMISSION'),
	 (SELECT place_id FROM business.voting_places WHERE UPPER(place_name) = 'HUGE SCHOOL'), 
	 'King election',
	 'The third national election of a king to rule the country', 
	 '2023-09-17',
	 '2023-09-21',
	 (SELECT status_id FROM business.status WHERE UPPER(short_description) = 'OK')),
	((SELECT commission_id FROM business.commission WHERE UPPER(commission_name) = 'SMALL COMMISSION'),
	 (SELECT place_id FROM business.voting_places WHERE UPPER(place_name) = 'SMALL SCHOOL'), 
	 'Queen election',
	 'The third national election of a queen to rule the country alongside the king', 
	 '2023-09-22',
	 '2023-09-24',
	 (SELECT status_id FROM business.status WHERE UPPER(short_description) = 'OK'));

INSERT INTO business.costs_events (event_id, cost_item_id, quantity)
VALUES
	((SELECT event_id FROM business.events WHERE UPPER(event_name) = 'KING ELECTION'),
	 (SELECT item_id FROM business.costs WHERE UPPER(item_description) = 'CAMPAIGN BANNERS'),
	 55),
	((SELECT event_id FROM business.events WHERE UPPER(event_name) = 'QUEEN ELECTION'),
	 (SELECT item_id FROM business.costs WHERE UPPER(item_description) = 'PAPER STACK'),
	 1000);

INSERT INTO business.commission_person (commission_id, person_id, start_date, end_date)
VALUES
	((SELECT commission_id FROM business.commission WHERE UPPER(commission_name) = 'SMALL COMMISSION'),
	 (SELECT person_id FROM business.person WHERE UPPER(first_name) = 'PABLO' AND UPPER(last_name) = 'ESCOBEAR'),
	 '2023-09-21 08:00:00',
	 '2023-09-21 22:00:00'),
	((SELECT commission_id FROM business.commission WHERE UPPER(commission_name) = 'BIG COMMISSION'),
	 (SELECT person_id FROM business.person WHERE UPPER(first_name) = 'CLAUDIA' AND UPPER(last_name) = 'AIDUALC'),
	 '2023-09-23 08:00:00',
	 '2023-09-25 22:00:00');

-- record_ts works fine
SELECT * FROM business.commission;