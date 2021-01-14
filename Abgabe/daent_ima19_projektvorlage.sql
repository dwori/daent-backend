/*
##########################################################################################
#                                                                                        #
#       Projekt DAENT | IMA19 | WS20/21                       							 #
#                                                                                        #
#       Gruppe 4																		 #
#                                                                                        #
#       Gruppenmitglieder:  Bukvarevic Mensur                                            #
#                           Dworacek Lukas                                               #
#                           Kainz Dominik                                                #
#                                                                                        #
#       Thema: Ticket System                                                             #
#                                                                                        #
########################################################################################## */



-- #######################################################################################
--  Tabellen
-- #######################################################################################
--AUSKLAPPEN--

    -- Tabelle 1: dbo.salutations
    -- The table dbo.salutation stores strings that represent the different kinds of salutation an entity can have. 
    CREATE TABLE salutations (
        id TINYINT NOT NULL,
        name VARCHAR(50) NOT NULL,
        CONSTRAINT PK_salutations PRIMARY KEY (id),
        CONSTRAINT UK_salutations_name UNIQUE (name)
    )

    -- Tabelle 1 - INSERTS
    INSERT INTO salutations (id,name) VALUES (1, 'Mr.')
    INSERT INTO salutations (id,name) VALUES (2, 'Ms.')
    INSERT INTO salutations (id,name) VALUES (3, 'Company')
    INSERT INTO salutations (id,name) VALUES (4, 'Organization')
    INSERT INTO salutations (id,name) VALUES (5, 'other')


    -- Tabelle 2: dbo.customers
    -- The table dbo.customers is used to store customer data, so that tickets can be related to an according issuer. 
    -- It is requied to store the lastname and the firstname of the person.
    -- Every user has his own unique username.
    -- It also stores the email address and the phone number of a person.
    -- The account behaviour of the person is protocoled with the time of the registration and the time the last login accrued.
    -- Also, the try’s where the password is incorrect are stored in the failed logins.
    CREATE TABLE customers (
        id INT IDENTITY NOT NULL,
        username VARCHAR(50) NOT NULL,
        passwordhash VARCHAR(128),
        lastname VARCHAR(50),
        firstname VARCHAR(50),
        email VARCHAR(150),
        phone VARCHAR(50),
        last_login datetime2(0),
        created_at datetime2(0) CONSTRAINT DF_customer_created_at DEFAULT SYSDATETIME(),
        failed_logins tinyint NOT NULL CONSTRAINT DF_customer_failed_logins DEFAULT 0,
        locked BIT NOT NULL,
        salutation TINYINT NOT NULL,
        CONSTRAINT PK_customers PRIMARY KEY (id),
        CONSTRAINT FK_customers_salutations FOREIGN KEY(salutation) REFERENCES salutations(id),
        CONSTRAINT UK_customers_username UNIQUE (username),
        CONSTRAINT UK_customers_email UNIQUE (email)
    )
    -- Tabelle 2 dbo.countries: 
    -- This table is used to store country names with their ISO code that is also used as 
    -- the primary key PK_countries which is referenced in the address table where the actual address with ISO code is stored.
    CREATE TABLE countries (
        iso VARCHAR(2),
        name VARCHAR(100),
        CONSTRAINT PK_countries PRIMARY KEY (iso)
    )

    -- Tabelle 2 INSERTS:
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

    
    -- Tabelle 6: dbo.addresses
    -- //todo
    CREATE TABLE addresses (
        id INT IDENTITY NOT NULL,
        streetname VARCHAR(80),
        postalcode INT,
        cityname VARCHAR(80),
        country VARCHAR(2),
        CONSTRAINT PK_addresses PRIMARY KEY (id),
        CONSTRAINT FK_addresses_country FOREIGN KEY(country) REFERENCES countries(iso)
    )


    -- Tabelle 4: dbo.customer_addresses
    CREATE TABLE customer_addresses (
        aid INT,
        cid INT,
        ship_bill_boolean BIT,
        CONSTRAINT FK_aid_customer_addresses_addresses FOREIGN KEY(aid) REFERENCES addresses (id),
        CONSTRAINT FK_cid_customer_addresses_customers FOREIGN KEY(cid) REFERENCES customers (id),
        CONSTRAINT PK_customer_addresses PRIMARY KEY (aid,cid)
    )

    -- Tabelle 5: dbo.ticket_categories
    -- //todo
    CREATE TABLE ticket_categories (
        id TINYINT NOT NULL,
        name VARCHAR(30),
        CONSTRAINT PK_ticket_categories PRIMARY KEY(id),
        CONSTRAINT UK_ticket_categories_name UNIQUE (name)
    )


    -- Tabelle 5 - INSERTS
    INSERT INTO ticket_categories (id,name) VALUES (1, 'Technical')
    INSERT INTO ticket_categories (id,name) VALUES (2, 'Customer Services')
    INSERT INTO ticket_categories (id,name) VALUES (3, 'Billing')
    INSERT INTO ticket_categories (id,name) VALUES (4, 'Website')
    INSERT INTO ticket_categories (id,name) VALUES (5, 'Server')
    INSERT INTO ticket_categories (id,name) VALUES (6, 'Infrastucture Support')
    INSERT INTO ticket_categories (id,name) VALUES (7, 'VoIP')
    
    

    -- Tabelle 7: dbo.staff
    -- //todo
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
        absence_begin datetime2(0),
        absence_end datetime2(0),
        CONSTRAINT PK_staff PRIMARY KEY (id),
        CONSTRAINT FK_staff_salutations FOREIGN KEY(salutation) REFERENCES salutations (id),
        CONSTRAINT UK_staff_username UNIQUE (username),
        CONSTRAINT UK_staff_email UNIQUE (email),
        CONSTRAINT FK_staff_address FOREIGN KEY(address) REFERENCES addresses
    )

    -- Tabelle 8: dbo.ticket_categories_staff
    -- Kurzbeschreibung: Enthält Referenzen(IDs) zwischen dbo.staff und dbo.ticket_categories
    CREATE TABLE ticket_categories_staff (
        sid INT,
        tcid TINYINT,
        CONSTRAINT FK_sid_ticket_categories_staff FOREIGN KEY(sid) REFERENCES staff (id),
        CONSTRAINT FK_tcid_ticket_categories_staff FOREIGN KEY(tcid) REFERENCES ticket_categories (id),
        CONSTRAINT PK_ticket_categories_staff PRIMARY KEY (sid,tcid)
    )


    -- Tabelle 9: dbo.ticket_statuses
    -- Kurzbeschreibung: Enthält die möglichen Status(e) der Tickets
    CREATE TABLE ticket_statuses (
        id INT PRIMARY KEY NOT NULL,
        name VARCHAR(20),
        CONSTRAINT UK_ticket_statuses_name UNIQUE (name)
    )

    --Tabelle 9 - INSERTS
    INSERT INTO ticket_statuses (id,name) VALUES (1, 'Pending')
    INSERT INTO ticket_statuses (id,name) VALUES (2, 'in Process')
    INSERT INTO ticket_statuses (id,name) VALUES (3, 'Solved')


    -- Tabelle 10: dbo.ticket_priorities
    -- Kurzbeschreibung: Enthält die möglichen Prioritäten der Tickets
    CREATE TABLE ticket_priorities (
        id TINYINT PRIMARY KEY NOT NULL,
        name VARCHAR(20),
        CONSTRAINT UK_ticket_priorities_name UNIQUE (name)
    )

    --Tabelle 10 - INSERTS
    INSERT INTO ticket_priorities (id,name) VALUES (0, 'None')
    INSERT INTO ticket_priorities (id,name) VALUES (1, 'Low')
    INSERT INTO ticket_priorities (id,name) VALUES (2, 'Normal')
    INSERT INTO ticket_priorities (id,name) VALUES (3, 'Critical')


    -- Tabelle 11: dbo.ticket
    -- Kurzbeschreibung: Enthält sämtliche relevante Daten zum ticket sowie dessen Agent und Kategorie.
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


    -- Tabelle 12: dbo.settings
    CREATE TABLE settings (
        id INTEGER IDENTITY NOT NULL,
        value VARCHAR(100) NOT NULL,
        description VARCHAR(100),
        CONSTRAINT PK_settings PRIMARY KEY (id)
    )

    -- Tabelle 12 INSERTS:
    INSERT INTO settings (value,description) VALUES ('5','max ticket_queue')
    INSERT INTO settings (value,description) VALUES ('#sA1tyAF!?','salt für password encryption')
    INSERT INTO settings (value,description) VALUES ('4','absent days switch workload')
    INSERT INTO settings (value,description) VALUES ('4','max failed logins')


/*
-- #######################################################################################
--  Trigger
-- #######################################################################################
--AUSKLAPPEN--

    -- Trigger 1
    -- Kurzbeschreibung: XXXXXXXXXX
    CREATE TRIGGER ...


    -- Testaufrufe
    -- Variante 1 mit Ergebnis AB

    -- Variante 2 mit Ergebnis CD
    -- ...


    -- Reset



    -- ...

    -- Trigger n
    -- Kurzbeschreibung: XXXXXXXXXX
    CREATE TRIGGER ...


    -- Testaufrufe
    -- Variante 1 mit Ergebnis AB

    -- Variante 2 mit Ergebnis CD
    -- ...



    -- Reset






-- #######################################################################################
--  Prozeduren
-- #######################################################################################
--AUSLAPPEN--


-- Prozedur 1
-- Kurzbeschreibung: Erstellt ein neuers Ticket mit Sunject, Kategorie usw. und fügt dem Ticket einen Agenten hinzu.
GO
CREATE OR ALTER PROCEDURE dbo.sp_createTicket
    @subject VARCHAR(100),
    @content VARCHAR(255),
    @customer INT,
    @status TINYINT = 1,
    @category TINYINT,
    @priority TINYINT = 1,
    --Developer Mode
    @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        --Variables
        DECLARE @agent INT

        BEGIN TRY
            --Den Agenten mit der geringsten ticket_queue ermitteln und @agent hizufügen
            SET @agent = (SELECT TOP 1 id FROM dbo.staff WHERE id IN(SELECT sid FROM dbo.ticket_categories_staff WHERE tcid = @category)
            ORDER BY ticket_queue ASC)
            --ticket queue für diesen Agenten um 1 erhöhen
            

            INSERT INTO dbo.ticket(subject,ticket_content,customer_number,agent,status,category,priority)
            VALUES(@subject,@content,@customer,@agent,@status,@category,@priority)
            SET @errorCode = SCOPE_IDENTITY();

            IF ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.staff
                SET ticket_queue = ISNULL(ticket_queue,0) + 1
                WHERE id = @agent;
            END
        END TRY
        BEGIN CATCH
            
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_customer%'
                SET @errorCode = -2
            ELSE IF ERROR_MESSAGE() like '%FK_ticket_categories%'
                SET @errorCode = -1
            ELSE
                SET @errorCode = -99

        END CATCH
        IF @select = 1
            SELECT @errorCode AS resultCode, @errorMsg AS errorMessage, @errorLine AS errorLine
    END
GO
-- Testaufrufe

EXEC dbo.sp_createTicket 'Test5','Ich habe ein Problem mit meiner Website!',44,@category = 4, @select = 1;

-- Variante 1 mit Ergebnis AB

-- Variante 2 mit Ergebnis CD
-- ...


EXEC dbo.sp_CreateUser 'dwori420','hdjkahjkhdjkah!','dsad','dasdad',1,'dasd', 'dasda','dsad','323423',@select = 1
-- Reset



-- ...

-- Prozedur n
-- Kurzbeschreibung: XXXXXXXXXX
GO
CREATE OR ALTER PROCEDURE dbo.sp_changeStatus
    @ticket_id INT,
    @status TINYINT,
    --Developer Mode
    @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        --Variablen
            
        BEGIN TRY
            IF ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.ticket
                SET status = @status
                WHERE id = @ticket_id
            END

            IF @status = 3 AND ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @ticket_id
            END

        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_statuses%'
                SET @errorCode = -1
            ELSE IF ERROR_MESSAGE() like '%FK_ticket_categories%'
                SET @errorCode = -2
            ELSE
                SET @errorCode = -99
        END CATCH
        IF @select = 1
            SELECT @errorCode AS resultCode, @errorMsg AS errorMessage, @errorLine AS errorLine
    END



-- Testaufrufe
EXEC dbo.sp_changeStatus 2,2,@select = 1
-- Variante 1 mit Ergebnis AB

-- Variante 2 mit Ergebnis CD
-- ...



-- Reset

--TESTING

EXEC dbo.sp_CreateUser 'dwori420', 'Pa55w.rd!', 'Lukas', 'Dworacek',1, 'Eckertstraße 30i','Eckertstraße 30i','lukas.dworacek@edu.fh-joanneum.at','+43 0664 1355895',@agent = 1, @select = 1;
SELECT * FROM dbo.customers;
SELECT * FROM dbo.staff;

EXEC dbo.sp_LoginUser 'dwori420','Pa55wf.rd!', @select = 1
DELETE FROM dbo.customers WHERE username = 'dwori420';

SELECT * FROM dbo.ticket_categories_staff;

INSERT INTO dbo.ticket_categories_staff(sid,tcid)
VALUES(1,4);

UPDATE dbo.staff
SET ticket_queue = 3 WHERE id = 1;