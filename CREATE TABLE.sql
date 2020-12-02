DROP TABLE IF EXISTS salutations
DROP TABLE IF EXISTS customers
DROP TABLE IF EXISTS ticket_categories_staff
DROP TABLE IF EXISTS staff
DROP TABLE IF EXISTS ticket
DROP TABLE IF EXISTS ticket_statuses
DROP TABLE IF EXISTS ticket_priorities
DROP TABLE IF EXISTS ticket_categories

-- Completion time: 2020-11-21T19:58:57.1963319+01:00 VERSION 1.0


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


CREATE TABLE ticket_categories (
    id TINYINT PRIMARY KEY NOT NULL,
    name VARCHAR(255),
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
    username VARCHAR(60) NOT NULL,
    passwordhash VARCHAR(128),
    ticket_queue TINYINT NOT NULL CONSTRAINT DF_staff_ticket_queue DEFAULT 0,
    finished_tickets INT NOT NULL CONSTRAINT DF_staff_finished_tickets DEFAULT 0,
    salutation TINYINT NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    address VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    last_login datetime2(0),
    created_at datetime2(0) CONSTRAINT DF_staff_created_at DEFAULT SYSDATETIME(),
    failed_logins tinyint NOT NULL CONSTRAINT DF_staff_failed_logins DEFAULT 0
    CONSTRAINT PK_staff PRIMARY KEY (id),
    CONSTRAINT FK_staff_salutations FOREIGN KEY(salutation) REFERENCES salutations (id),
    CONSTRAINT UK_staff_username UNIQUE (username),
    CONSTRAINT UK_staff_email UNIQUE (email)
)
-- TODO: ticket_categories_staff
-- ?? 
CREATE TABLE ticket_categories_staff (
    sid INT,
    tcid TINYINT,
    CONSTRAINT FK_sid_ticket_categories_staff FOREIGN KEY(sid) REFERENCES staff (id),
    CONSTRAINT FK_tcid_ticket_categories_staff FOREIGN KEY(tcid) REFERENCES ticket_categories (id),
    CONSTRAINT PK_ticket_categories_staff PRIMARY KEY (sid,tcid)
)







CREATE TABLE ticket_statuses (
    id TINYINT PRIMARY KEY NOT NULL,
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
INSERT INTO ticket_priorities (id,name) VALUES (1, 'Low')
INSERT INTO ticket_priorities (id,name) VALUES (2, 'Normal')
INSERT INTO ticket_priorities (id,name) VALUES (3, 'Critical')

CREATE TABLE ticket (
    id INTEGER IDENTITY NOT NULL,
    subject VARCHAR(100) NOT NULL,
    ticket_content VARCHAR(255),
    customer_number INT,
	agent INT,
    status TINYINT,
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




INSERT INTO customers (salutation,username,firstname,lastname,email) VALUES (1,'mittelaltermax','Max','Musermann','max@musterman.com')
INSERT INTO staff (salutation,username,firstname,lastname,email) VALUES (1,'domi','Dominik','Kainz','domi@hahaxd.at')
INSERT INTO ticket(subject,ticket_content,customer_number,agent,status,category,priority) VALUES ('FirstTicket','x',1,1,1,2,3)