DROP TABLE IF EXISTS salutations
DROP TABLE IF EXISTS customers
DROP TABLE IF EXISTS countries
DROP TABLE IF EXISTS addresses
--  addresses added

CREATE TABLE salutations (
    id TINYINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT PK_salutations PRIMARY KEY (id),
    CONSTRAINT UK_salutations_name UNIQUE (name)
)

INSERT INTO salutations (id,name) VALUES (1, 'Mr.')
INSERT INTO salutations (id,name) VALUES (2, 'Ms.')
INSERT INTO salutations (id,name) VALUES (3, 'Company')
INSERT INTO salutations (id,name) VALUES (4, 'other')

CREATE TABLE customers (
    id INT IDENTITY NOT NULL,
    username VARCHAR(60) NOT NULL,
    passwordhash VARCHAR(128),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    salutation TINYINT NOT NULL,
    billing_address VARCHAR(255),
    shipping_address VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    last_login datetime2(0),
    created_at datetime2(0) CONSTRAINT DF_customer_created_at DEFAULT SYSDATETIME(),
    failed_logins tinyint NOT NULL CONSTRAINT DF_customer_failed_logins DEFAULT 0
    CONSTRAINT PK_customers PRIMARY KEY (id),
    CONSTRAINT FK_customers_salutations FOREIGN KEY(salutation) REFERENCES salutations(id),
    CONSTRAINT UK_customers_username UNIQUE (username),
    CONSTRAINT UK_customers_email UNIQUE (email)
)

CREATE TABLE countries (
    iso VARCHAR(2),
    name VARCHAR(255),
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
    streetname VARCHAR(255),
    postalcode INT,
    cityname VARCHAR(255),
    country VARCHAR(2),
    shipping BIT
    CONSTRAINT PK_addresses PRIMARY KEY (id),
    CONSTRAINT FK_addresses_country FOREIGN KEY(country) REFERENCES countries(iso),
)