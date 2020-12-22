DROP TABLE IF EXISTS salutations
DROP TABLE IF EXISTS customers

DROP TABLE IF EXISTS countries
DROP TABLE IF EXISTS addresses
DROP TABLE IF EXISTS customer_addresses
DROP TABLE IF EXISTS ticket_categories_staff
DROP TABLE IF EXISTS staff
DROP TABLE IF EXISTS ticket
DROP TABLE IF EXISTS ticket_statuses
DROP TABLE IF EXISTS ticket_priorities
DROP TABLE IF EXISTS ticket_categories




CREATE TABLE salutations (
    id TINYINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT PK_salutations PRIMARY KEY (id),
    CONSTRAINT UK_salutations_name UNIQUE (name)
)
INSERT INTO salutations (id,name) VALUES (1, 'Mr.')
INSERT INTO salutations (id,name) VALUES (2, 'Ms.')
INSERT INTO salutations (id,name) VALUES (3, 'Company')
INSERT INTO salutations (id,name) VALUES (4, 'other')



CREATE TABLE customers (
    id INT IDENTITY NOT NULL,
    username VARCHAR(50) NOT NULL,
    passwordhash VARCHAR(128),
    lastname VARCHAR(50),
    firstname VARCHAR(50),
    -- billing_address VARCHAR(255),
    -- shipping_address VARCHAR(255),
    email VARCHAR(150),
    phone VARCHAR(50),
    last_login datetime2(0),
    created_at datetime2(0) CONSTRAINT DF_customer_created_at DEFAULT SYSDATETIME(),
    failed_logins tinyint NOT NULL CONSTRAINT DF_customer_failed_logins DEFAULT 0,
    salutation TINYINT NOT NULL,
    CONSTRAINT PK_customers PRIMARY KEY (id),
    CONSTRAINT FK_customers_salutations FOREIGN KEY(salutation) REFERENCES salutations(id),
    CONSTRAINT UK_customers_username UNIQUE (username),
    CONSTRAINT UK_customers_email UNIQUE (email)
)



CREATE TABLE countries (
    iso VARCHAR(2),
    name VARCHAR(100),
    CONSTRAINT PK_countries PRIMARY KEY (iso)
)
INSERT INTO countries (iso, name) VALUES ('AL', 'Albanien')
INSERT INTO countries (iso, name) VALUES ('BE', 'Belgium')
INSERT INTO countries (iso, name) VALUES ('BA', 'Bosnia and Herzegovina')
INSERT INTO countries (iso, name) VALUES ('BG', 'Bulgaria')
INSERT INTO countries (iso, name) VALUES ('DK', 'Denmark')
INSERT INTO countries (iso, name) VALUES ('DE', 'Germany')
INSERT INTO countries (iso, name) VALUES ('EE', 'Estonia')
INSERT INTO countries (iso, name) VALUES ('FI', 'Finland')
INSERT INTO countries (iso, name) VALUES ('FR', 'France')
INSERT INTO countries (iso, name) VALUES ('GI', 'Gibraltar')
INSERT INTO countries (iso, name) VALUES ('GR', 'Greece')
INSERT INTO countries (iso, name) VALUES ('IE', 'Ireland')
INSERT INTO countries (iso, name) VALUES ('IS', 'Iceland')
INSERT INTO countries (iso, name) VALUES ('IT', 'Italy')
INSERT INTO countries (iso, name) VALUES ('HR', 'Croatia')
INSERT INTO countries (iso, name) VALUES ('XK', 'Kosovo')
INSERT INTO countries (iso, name) VALUES ('LV', 'Latvia')
INSERT INTO countries (iso, name) VALUES ('LI', 'Liechtenstein')
INSERT INTO countries (iso, name) VALUES ('LT', 'Lithuania')
INSERT INTO countries (iso, name) VALUES ('LU', 'Luxembourg')
INSERT INTO countries (iso, name) VALUES ('MT', 'Malta')
INSERT INTO countries (iso, name) VALUES ('MD', 'Moldova')
INSERT INTO countries (iso, name) VALUES ('ME', 'Montenegro')
INSERT INTO countries (iso, name) VALUES ('NL', 'Netherlands')
INSERT INTO countries (iso, name) VALUES ('MK', 'North Macedonia')
INSERT INTO countries (iso, name) VALUES ('NO', 'Norway')
INSERT INTO countries (iso, name) VALUES ('AT', 'Austria')
INSERT INTO countries (iso, name) VALUES ('PL', 'Poland')
INSERT INTO countries (iso, name) VALUES ('PT', 'Portugal')
INSERT INTO countries (iso, name) VALUES ('RO', 'Romania')
INSERT INTO countries (iso, name) VALUES ('SE', 'Sweden')
INSERT INTO countries (iso, name) VALUES ('CH', 'Switzerland')
INSERT INTO countries (iso, name) VALUES ('RS', 'Serbia')
INSERT INTO countries (iso, name) VALUES ('SK', 'Slovakia')
INSERT INTO countries (iso, name) VALUES ('SI', 'Slovenia')
INSERT INTO countries (iso, name) VALUES ('ES', 'Spain')
INSERT INTO countries (iso, name) VALUES ('CZ', 'Czech Republic')
INSERT INTO countries (iso, name) VALUES ('HU', 'Hungary')
INSERT INTO countries (iso, name) VALUES ('GB', 'United Kingdom')
INSERT INTO countries (iso, name) VALUES ('CY', 'Cyprus')



CREATE TABLE addresses (
    id INT IDENTITY NOT NULL,
    streetname VARCHAR(80),
    postalcode INT,
    cityname VARCHAR(80),
    country VARCHAR(2),
    CONSTRAINT PK_addresses PRIMARY KEY (id),
    CONSTRAINT FK_addresses_country FOREIGN KEY(country) REFERENCES countries(iso),
)


CREATE TABLE customer_addresses (
    aid INT,
    cid INT,
    ship_bill_boolean BIT,
    CONSTRAINT FK_aid_customer_addresses_addresses FOREIGN KEY(aid) REFERENCES addresses (id),
    CONSTRAINT FK_cid_customer_addresses_customers FOREIGN KEY(cid) REFERENCES customers (id),
    CONSTRAINT PK_customer_addresses PRIMARY KEY (aid,cid)
)

CREATE TABLE ticket_categories (
    id TINYINT NOT NULL,
    name VARCHAR(30),
    CONSTRAINT PK_ticket_categories PRIMARY KEY(id),
	CONSTRAINT UK_ticket_categories_name UNIQUE (name)
)
INSERT INTO ticket_categories (id,name) VALUES (1, 'Technical')
INSERT INTO ticket_categories (id,name) VALUES (2, 'Customer Services')
INSERT INTO ticket_categories (id,name) VALUES (3, 'Billing')
INSERT INTO ticket_categories (id,name) VALUES (4, 'Website')
INSERT INTO ticket_categories (id,name) VALUES (5, 'Server')
INSERT INTO ticket_categories (id,name) VALUES (6, 'Infrastucture Support')
INSERT INTO ticket_categories (id,name) VALUES (7, 'VoIP')

CREATE TABLE staff (
    id INT IDENTITY NOT NULL,
    username VARCHAR(50) NOT NULL,
    passwordhash VARCHAR(128),
    ticket_queue TINYINT NOT NULL CONSTRAINT DF_staff_ticket_queue DEFAULT 0,
    finished_tickets INT NOT NULL CONSTRAINT DF_staff_finished_tickets DEFAULT 0,
    lastname VARCHAR(50),
    firstname VARCHAR(50),
    email VARCHAR(150),
    phone VARCHAR(50),
    last_login datetime2(0),
    created_at datetime2(0) CONSTRAINT DF_staff_created_at DEFAULT SYSDATETIME(),
    failed_logins tinyint NOT NULL CONSTRAINT DF_staff_failed_logins DEFAULT 0,
    address INT,
    salutation TINYINT NOT NULL,
    CONSTRAINT PK_staff PRIMARY KEY (id),
    CONSTRAINT FK_staff_salutations FOREIGN KEY(salutation) REFERENCES salutations (id),
    CONSTRAINT UK_staff_username UNIQUE (username),
    CONSTRAINT UK_staff_email UNIQUE (email),
    CONSTRAINT FK_staff_address FOREIGN KEY(address) REFERENCES addresses
)
CREATE TABLE ticket_categories_staff (
    sid INT,
    tcid TINYINT,
    CONSTRAINT FK_sid_ticket_categories_staff FOREIGN KEY(sid) REFERENCES staff (id),
    CONSTRAINT FK_tcid_ticket_categories_staff FOREIGN KEY(tcid) REFERENCES ticket_categories (id),
    CONSTRAINT PK_ticket_categories_staff PRIMARY KEY (sid,tcid)
)
CREATE TABLE ticket_statuses (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(20),
    CONSTRAINT UK_ticket_statuses_name UNIQUE (name)
)

INSERT INTO ticket_statuses (id,name) VALUES (1, 'Pending')
INSERT INTO ticket_statuses (id,name) VALUES (2, 'in Process')
INSERT INTO ticket_statuses (id,name) VALUES (3, 'Solved')

CREATE TABLE ticket_priorities (
    id TINYINT PRIMARY KEY NOT NULL,
    name VARCHAR(20),
    CONSTRAINT UK_ticket_priorities_name UNIQUE (name)
)
INSERT INTO ticket_priorities (id,name) VALUES (0, 'None')
INSERT INTO ticket_priorities (id,name) VALUES (1, 'Low')
INSERT INTO ticket_priorities (id,name) VALUES (2, 'Normal')
INSERT INTO ticket_priorities (id,name) VALUES (3, 'Critical')

CREATE TABLE ticket (
    id INTEGER IDENTITY NOT NULL,
    subject VARCHAR(100) NOT NULL,
    ticket_content VARCHAR(255),
    customer_number INT,
	agent INT,
    status INT,
    category TINYINT,
    priority TINYINT,
    created_at DATETIME2 CONSTRAINT DF_ticket_created_at DEFAULT SYSDATETIME(),
    updated_at DATETIME2,
    completed_at DATETIME2,
    CONSTRAINT PK_ticket PRIMARY KEY (id),
    CONSTRAINT FK_ticket_customer FOREIGN KEY (customer_number) REFERENCES customers(id),
    CONSTRAINT FK_ticket_agent FOREIGN KEY (agent) REFERENCES staff(id),
    CONSTRAINT FK_ticket_categories FOREIGN KEY (category) REFERENCES ticket_categories(id),
    CONSTRAINT FK_ticket_priorities FOREIGN KEY (priority) REFERENCES ticket_priorities(id),
    CONSTRAINT FK_ticket_statuses FOREIGN KEY (status) REFERENCES ticket_statuses(id)
)


CREATE TABLE settings (
    id INTEGER IDENTITY NOT NULL,
    value VARCHAR NOT NULL,
    description VARCHAR(100),
    CONSTRAINT PK_settings PRIMARY KEY (id)
)

--DROP TABLE settings;
SELECT * FROM settings
INSERT INTO settings (value,description) VALUES ('5','max ticket_queue')
