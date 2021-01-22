/*
##########################################################################################
#                                                                                        #
#       Project DAENT | IMA19 | WS20/21                       							 #
#                                                                                        #
#       Group 4																		     #
#                                                                                        #
#       Groupmembers:       Bukvarevic Mensur                                            #
#                           Dworacek Lukas                                               #
#                           Kainz Dominik                                                #
#                                                                                        #
#       Topic: Ticket System                                                             #
#                                                                                        #
########################################################################################## */



-- #######################################################################################
--  Tables
-- #######################################################################################


    -- Table 1: dbo.salutations
    -- The table dbo.salutation stores strings that represent the different kinds of salutation an entity can have. 
    CREATE TABLE salutations (
        id TINYINT NOT NULL,
        name VARCHAR(50) NOT NULL,
        CONSTRAINT PK_salutations PRIMARY KEY (id),
        CONSTRAINT UK_salutations_name UNIQUE (name)
    )
    -- Table 1 - INSERTS
    INSERT INTO salutations (id,name) VALUES (1, 'Mr.')
    INSERT INTO salutations (id,name) VALUES (2, 'Ms.')
    INSERT INTO salutations (id,name) VALUES (3, 'Company')
    INSERT INTO salutations (id,name) VALUES (4, 'Organization')
    INSERT INTO salutations (id,name) VALUES (5, 'other')


    -- Table 2: dbo.customers
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


    -- Table 3: dbo.countries
    -- This table is used to store country names with their ISO code that is also used as 
    -- the primary key PK_countries which is referenced in the address table where the actual address with ISO code is stored.
    CREATE TABLE countries (
        iso VARCHAR(2),
        name VARCHAR(100),
        CONSTRAINT PK_countries PRIMARY KEY (iso)
    )
    -- Table 3 - INSERTS:
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

    
    -- Table 4: dbo.addresses
    -- The addresses table stores the information of customer and staff addresses which are the street name, the postal code, the city name and the country (ISO code). 
    -- The primary key PK_addresses is the id of the address and it is also set to IDENTITY to make it generate id numbers for addresses.
    CREATE TABLE addresses (
        id INT IDENTITY NOT NULL,
        streetname VARCHAR(80),
        postalcode INT,
        cityname VARCHAR(80),
        country VARCHAR(2),
        CONSTRAINT PK_addresses PRIMARY KEY (id),
        CONSTRAINT FK_addresses_country FOREIGN KEY(country) REFERENCES countries(iso)
    )


    -- Table 5: dbo.customer_addresses
    -- This table stores the id of an address and the id of an customer. 
    -- Additionally, it stores a boolean that says if the customer has a shipping address or not. 
    CREATE TABLE customer_addresses (
        aid INT,
        cid INT,
        ship_bill_boolean BIT,
        CONSTRAINT FK_aid_customer_addresses_addresses FOREIGN KEY(aid) REFERENCES addresses (id),
        CONSTRAINT FK_cid_customer_addresses_customers FOREIGN KEY(cid) REFERENCES customers (id),
        CONSTRAINT PK_customer_addresses PRIMARY KEY (aid,cid)
    )


    -- Table 6: dbo.ticket_categories
    -- The categories table includes the different departments of work. 
    -- Every staff member is as-signed to one or more sections. 
    -- Depending on what a customer needs, the ticket system allocates the customer problems to the right employees, who are specialists in their field.
    CREATE TABLE ticket_categories (
        id TINYINT NOT NULL,
        name VARCHAR(30),
        CONSTRAINT PK_ticket_categories PRIMARY KEY(id),
        CONSTRAINT UK_ticket_categories_name UNIQUE (name)
    )
    -- Table 6 - INSERTS
    INSERT INTO ticket_categories (id,name) VALUES (1, 'Technical')
    INSERT INTO ticket_categories (id,name) VALUES (2, 'Customer Services')
    INSERT INTO ticket_categories (id,name) VALUES (3, 'Billing')
    INSERT INTO ticket_categories (id,name) VALUES (4, 'Website')
    INSERT INTO ticket_categories (id,name) VALUES (5, 'Server')
    INSERT INTO ticket_categories (id,name) VALUES (6, 'Infrastucture Support')
    INSERT INTO ticket_categories (id,name) VALUES (7, 'VoIP')
    
    
    -- Table 7: dbo.staff
    -- The staff table is used to store employee data and specify it. Staff members can be assigned to a ticket with their id. 
    -- The finished tickets get stored as well with the customer and a number which indicates the queue, the work an agent has still to complete.
    -- It is required to store the last name and the first name of the person. Every user has his own unique username.
    -- It also stores the email address and the phone number of a person.
    -- The account behaviour of the person is protocoled with the time of the registration and the time the last login accrued.
    -- The columns absence_begin and absence_end are used to store the time an agent is absent.
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

    
    -- Table 8: dbo.ticket_categories_staff
    -- This table stores the id of an agent (member of staff) and the id of a category. 
    -- To have a reference between those two, both values together build the primary key of that table.
    CREATE TABLE ticket_categories_staff (
        sid INT,
        tcid TINYINT,
        CONSTRAINT FK_sid_ticket_categories_staff FOREIGN KEY(sid) REFERENCES staff (id),
        CONSTRAINT FK_tcid_ticket_categories_staff FOREIGN KEY(tcid) REFERENCES ticket_categories (id),
        CONSTRAINT PK_ticket_categories_staff PRIMARY KEY (sid,tcid)
    )


    -- Table 9: dbo.ticket_statuses
    -- The status table shows different states of a ticket.
    -- A ticket can either be pending, in process or solved and is being filled in by the staff members. 
    -- If a ticket gets solved (= 3), it is closed and completed. 
    -- This means, that it cannot be assigned to anyone anymore.
    CREATE TABLE ticket_statuses (
        id INT PRIMARY KEY NOT NULL,
        name VARCHAR(20),
        CONSTRAINT UK_ticket_statuses_name UNIQUE (name)
    )
    -- Table 9 - INSERTS
    INSERT INTO ticket_statuses (id,name) VALUES (1, 'Pending')
    INSERT INTO ticket_statuses (id,name) VALUES (2, 'in Process')
    INSERT INTO ticket_statuses (id,name) VALUES (3, 'Solved')


    -- Table 10: dbo.ticket_priorities
    -- The ticket priorities table defines the different priority levels a ticket can have.
    -- Depending on the size and urgency of the problem, the ticket gets assigned either critical (highly urgent), normal, low (low urgency) or none.
    CREATE TABLE ticket_priorities (
        id TINYINT PRIMARY KEY NOT NULL,
        name VARCHAR(20),
        CONSTRAINT UK_ticket_priorities_name UNIQUE (name)
    )

    -- Table 10 - INSERTS
    INSERT INTO ticket_priorities (id,name) VALUES (0, 'None')
    INSERT INTO ticket_priorities (id,name) VALUES (1, 'Low')
    INSERT INTO ticket_priorities (id,name) VALUES (2, 'Normal')
    INSERT INTO ticket_priorities (id,name) VALUES (3, 'Critical')


    -- Table 11: dbo.ticket
    -- The ticket table is the main table of the ticket system. 
    -- It contains its id, the detailed problem, the customer and agent as well as the status and priority.
    -- The category is set and the time slots of a ticket progress are provided.
    -- This table is the assembly point of our system and gathers the main information of the ticketing functionality. 
    -- The ticket gets identified by an id and the customer by a customer_number.
    -- While the subject only shows a short title of the problem, the detailed description is set in ticket_content.
    -- Created_at, updated_at and completed_at show different self-explaining timestamps. 
    -- Status and priority show the state and prioritization of one ticket. 
    -- Agent represents the id of the assigned employee. 
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


    -- Table 12: dbo.settings
    -- This table is used to store values that are used all over our project and therefore only need to be declared in here. 
    -- For example, the maxQueue parameter is used in different procedures and trigger. 
    -- The value is stored in this table and therefore if I need change, its only necessary to change one value in the table and not all the procedures and trigger. 
    CREATE TABLE settings (
        id INTEGER IDENTITY NOT NULL,
        value VARCHAR(100) NOT NULL,
        description VARCHAR(100),
        CONSTRAINT PK_settings PRIMARY KEY (id)
    )
    -- Table 12 - INSERTS:
    INSERT INTO settings (value,description) VALUES ('5','max ticket_queue')
    INSERT INTO settings (value,description) VALUES ('#sA1tyAF!?','salt für password encryption')
    INSERT INTO settings (value,description) VALUES ('4','absent days switch workload')
    INSERT INTO settings (value,description) VALUES ('4','max failed logins')


/*
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
    DROP TABLE IF EXISTS settings
*/

-- #######################################################################################
--  Trigger for input verification
-- #######################################################################################

    -- Trigger 1: dbo.ticket_statusOnlyup_upd
    -- If an update to the status column of the ticket table is processed, values of the inserted and deleted table are compared. 
    -- Is the value of the deleted table bigger than the other one, an error is thrown.
    -- This trigger is used to check the transition from one status to another. 
    -- So it is possible to increase the status but not to go back.
    GO
    CREATE OR ALTER TRIGGER dbo.ticket_statusOnlyup_upd
        ON dbo.ticket
        FOR update
        AS
        BEGIN
            SET NOCOUNT ON;
            --TRIGGER fires if the status of a ticket is changed. We only allow to increase the status
            IF UPDATE(status)
            BEGIN
                -- Check if inserted status is bigger than deleted. If not so it rolls back the transaction.
                IF (SELECT COUNT(*) FROM inserted i 
                    INNER JOIN deleted d ON i.id = d.id 
                    WHERE i.status < d.status) > 0
                BEGIN
                    ROLLBACK;
                    THROW 50871, 'invalid status change', 1;
                END
            END
        END
    GO
    -- Trigger 1 - TESTS:

    -- Variant 1 (works to increase the status)
    UPDATE dbo.ticket
    SET status = 2 
    WHERE id = 2

    -- Variant 2 (denies to decrease the status)
    UPDATE dbo.ticket
    SET status = 1 
    WHERE id = 2


    -- Trigger 2: dbo.customers_lockUser_upd
    -- This trigger fires whenever the amount of failed_login exceeds the number saved in the settings table failed login attempts. 
    -- If this happens, the customer gets locked and cannot login until the account is unlocked by changeing the bit locked and setting the failed attempts to zero.
    GO
    CREATE OR ALTER TRIGGER dbo.customers_lockUser_upd
        ON dbo.customers
        FOR update
        AS
        BEGIN
            SET NOCOUNT ON;
            --If there are more than 3 failed logins the account gets locked.
            IF UPDATE(failed_logins)

            IF (SELECT failed_logins FROM inserted WHERE failed_logins = (SELECT value FROM settings WHERE id = 4)) > 1
            BEGIN
                UPDATE dbo.customers SET locked = 1
                WHERE id IN(SELECT DISTINCT ID FROM Inserted);
            END
        END
    GO
    -- Trigger 2 - TESTS:
    -- Variant 1 (account gets locked)
    UPDATE dbo.customers
    SET failed_logins = 4
    WHERE id = 1
    
    -- Reset
    UPDATE dbo.customers
    SET failed_logins = 0, locked = 0
    WHERE id = 1


    -- Trigger 3: dbo.ticket_finished_upd
    -- This trigger checks whether a ticket is already closed and therefore cannot be assigned any-more. 
    -- If the status of a ticket is set to three, an error message is thrown.
    GO 
    CREATE OR ALTER TRIGGER dbo.ticket_finished_upd
        ON dbo.ticket
        FOR UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;
            --TRIGGER fires if someone tries to change the agent of a ticker. If the status of the ticket is 3 this is not possible anymore.
            IF UPDATE(agent)
                BEGIN
                    IF (SELECT status FROM ticket WHERE id IN(SELECT DISTINCT ID FROM Inserted)) = 3
                        --ROLLBACK
                        THROW 50632,'Ticket bereits abgeschlossen',1;
                END
        END
    GO


-- #######################################################################################
--  Trigger for further actions
-- #######################################################################################

    -- Trigger 4: dbo.ticket_status_upd
    -- This trigger fires whenever an update on the status of one ticket changes. 
    -- The status of a ticket shows its completion process.
    -- The trigger distinguishes between status update and status completion.
    -- Whether it is an update or completion, the trigger fills in the proper fields updated_at and completed_at with the current timestamp. 
    -- Also, when completed, the priority of a ticket is set to null.
    GO
    CREATE OR ALTER TRIGGER dbo.ticket_status_upd
        ON dbo.ticket
        AFTER update
        AS
        BEGIN
            SET NOCOUNT ON;
            /*
            * TRIGGER fires if the status of a ticket gets changed.
            * Just logs the timestamp of the changes either into updated_at,
            * if status is changed to 2, or into completed_at , if status is changed to 3.
            */
            DECLARE @status INT
            DECLARE @ticket_id INT
            SELECT @ticket_id = id, @status = status
            FROM inserted;


            IF UPDATE(status)  
            BEGIN 
                IF (@status <> 3)
                    UPDATE dbo.ticket
                    SET updated_at = SYSDATETIME()
                    WHERE id = @ticket_id;
                ELSE
                BEGIN
                    UPDATE dbo.ticket
                    SET completed_at = SYSDATETIME()
                    WHERE id = @ticket_id;

                    --If the status is changed to 3, the priority automatically is changed to 0.
                    UPDATE dbo.ticket
                    SET priority = 0
                    WHERE id = @ticket_id;
                END
            END     
        END
    GO
    -- Trigger 4 - TESTS:
    -- Variant 1 (updated_at is stored)
    UPDATE dbo.ticket
    SET status = 2 
    WHERE id = 2

    -- Variante 2 (completed_at is stored)
    UPDATE dbo.ticket
    SET status = 3 
    WHERE id = 2


    -- Trigger 5: dbo.ticket_priority_upd
    -- This trigger fires whenever an update on the priority of one ticket changes. 
    -- If the priority gets changed, the updated_at field is filled in with the current timestamp.
    GO
    CREATE OR ALTER TRIGGER dbo.ticket_priority_upd
        ON dbo.ticket
        AFTER update
        AS
        BEGIN
            SET NOCOUNT ON;
            /*
            *TRIGGER fires if something gets changed at a ticket. 
            *It just logs the timestamp of the changes in the updated_at column of the ticket table.
            */
            IF UPDATE(priority) 
            BEGIN 
                UPDATE dbo.ticket
                SET updated_at = SYSDATETIME()
                WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND priority <> 0;
            END    
        END;
    GO
    -- Trigger 4 - TESTS:
    -- Variant 1 (updated_at is stored)
    UPDATE dbo.ticket
    SET priority = 2 
    WHERE id = 2

  
    -- Trigger 6: dbo.staff_absenceSwitch_upd
    -- This trigger fires whenever an update on absence_begin of a staff member happens. 
    -- The main task of this trigger is to detect whenever a staff member is absent for more than the amout of days stored in the settings table. 
    -- If this is the case, then the trigger calls the procedure sp_switchAgent with every ticket id that is assigned to the agent.
    GO
    CREATE OR ALTER TRIGGER dbo.staff_absenceSwitch_upd
        ON dbo.staff
        AFTER UPDATE
        AS
        BEGIN 
            SET NOCOUNT ON;
            
            --Variables
            DECLARE @absence_begin DATETIME2 
            DECLARE @absence_end DATETIME2
            DECLARE @agent INT 
            DECLARE @t_id INT

            IF UPDATE(absence_begin)
            BEGIN
                SELECT @absence_begin = absence_begin, @absence_end = absence_end, @agent = id
                FROM Inserted 
                WHERE id IN(SELECT DISTINCT ID FROM Inserted);

                --TRIGGER fires if length ob ansence is unknown or longer then 3 days
                IF ((DATEDIFF(DAY,@absence_begin,@absence_end)) > 3) OR ((@absence_end IS NULL) AND (@absence_begin IS NOT NULL))
                    BEGIN
                        --Variables
                        DECLARE @errormsg VARCHAR(500)
                        DECLARE @errorcode INT

                        --Cursor is used to switch all tickets an agent has.
                        DECLARE ticket_cursor CURSOR LOCAL STATIC
                        FOR                 
                            SELECT id                
                            FROM ticket                 
                            WHERE agent = @agent AND status <> 3                        
                        OPEN ticket_cursor 
                            FETCH NEXT FROM ticket_cursor INTO @t_id       
                            WHILE @@FETCH_STATUS = 0
                                BEGIN
                                    --Switch agent for all open tickets of absent agent.
                                    EXEC sp_switchAgent @ticket_id = @t_id, @errorCode = @errorcode OUTPUT,@errorMsg = @errormsg OUTPUT
                                    IF @errorcode < 0
                                        THROW 50935,@errormsg,1;

                                    FETCH NEXT FROM ticket_cursor INTO @t_id ;
                                END
                        CLOSE ticket_cursor;
                        DEALLOCATE ticket_cursor;

                        /*
                        * Sets the ticket queue to 99 so it does not look like the queue is full,
                        * but the agent still can not get any new tickets.
                        */
                        UPDATE dbo.staff
                        SET ticket_queue = 99
                        WHERE id = @agent;
                        
                    END
                /*
                *If the @absence_begin is Set to NULL, what happens if the absence is over,
                * the ticket_queue will be reset to 0. So now the agent can get tickets again.
                */
                IF @absence_begin IS NULL
                BEGIN
                    UPDATE dbo.staff
                    SET ticket_queue = 0
                    WHERE id = @agent
                END
            END  
        END
    GO


-- #######################################################################################
--  Procedures
-- #######################################################################################



-- Procedur 1: sp_createUser
-- Is a procedure to create either a customer or an agent. Parameter that are provided
-- get stored in the customers table, staff table, addresses table or the customer_addresses table.
-- Depending on the @agent bit.
-- This procedure takes two address strings which must be separated with three commas so that it can be split up into streetname, city, postalcode and country. 
-- The part that creates the agent only can take one address.

GO
CREATE OR ALTER PROCEDURE dbo.sp_createUser
    @username VARCHAR(50),
    @password VARCHAR(128),
    @firstname VARCHAR(50),
    @lastname VARCHAR(50),
    @salutation TINYINT,
    @address1 VARCHAR(255),
    @address2 VARCHAR(255) = NULL,
    @categories VARCHAR(255) = NULL,
    @email VARCHAR(150),
    @phone VARCHAR(150),
    @agent BIT = 0,
    @errorCode INT = NULL OUTPUT,  -- Customer/Agent ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION
            DECLARE @a1_length INT = len(@address1) - len(replace(@address1,',',''))
            DECLARE @a2_length INT = len(@address2) - len(replace(@address2,',',''))
            DECLARE @c_length INT = len(@categories) - len(replace(@categories,',','')) 
            -- not lenght anymore, but the comma count 

            --Check the complexity of the password
            IF LEN(ISNULL(@password, '')) < 6
                THROW 50002, 'register: PASSWORD NOT COMPLEX ENOUGH', 1;

            IF LEN(ISNULL(@username, '')) < 6 
                THROW 50003, 'register: USERNAME IS TOO SHORT', 1;

            IF (@email NOT LIKE '%[@]%') OR (@email NOT LIKE '%[.]%')
                THROW 50004, 'register: NO VALID EMAIL ADDRESS ENTERED', 1;
            
            IF NOT @a1_length = 3
                THROW 50005, 'register: NO VALID ADDRESS ENTERED', 1;
            
            IF NOT @a2_length = 3
                THROW 50006, 'register: NO VALID 2ND ADDRESS ENTERED', 1;

            SET @email = LOWER(@email)

            IF @phone LIKE '%_%' 
                SET @phone = REPLACE(@phone, ' ', '');

            --parameters needed for password encryption
            DECLARE @salt VARCHAR(10) = (SELECT value FROM dbo.settings WHERE id = 2)
            DECLARE @hash VARCHAR(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2)
            DECLARE @streetname1 VARCHAR(80) = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 1)
            DECLARE @postalcode1 INT = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 2)
            DECLARE @cityname1 VARCHAR(80) = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 3)
            DECLARE @country1 VARCHAR(2) = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 4)
            DECLARE @address_id1 INT

            --For the creation of a customer
            IF (@agent = 0)
                BEGIN
                IF @address2 IS NOT NULL
                    BEGIN
                    DECLARE @streetname2 VARCHAR(80) = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 1)
                    DECLARE @postalcode2 int = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 2)
                    DECLARE @cityname2 VARCHAR(80) = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 3)
                    DECLARE @country2 VARCHAR(2) = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 4)
                    DECLARE @address_id2 INT
                    END
                INSERT INTO dbo.customers (username,passwordhash,firstname,lastname,salutation,email,phone,locked) 
                VALUES (@username,@hash,@firstname,@lastname,@salutation,@email,@phone,0)
                SET @errorCode = SCOPE_IDENTITY();
                
                INSERT INTO dbo.addresses (streetname,postalcode,cityname,country)
                VALUES (@streetname1,@postalcode1,@cityname1,@country1);
                SET @address_id1 = SCOPE_IDENTITY();

                INSERT INTO dbo.customer_addresses (aid,cid,ship_bill_boolean)
                VALUES (@address_id1,@errorCode,0);

                IF (@address2 IS NOT NULL)
                    BEGIN
                    INSERT INTO dbo.addresses (streetname,postalcode,cityname,country)
                    VALUES (@streetname2,@postalcode2,@cityname2,@country2);
                    SET @address_id2 = SCOPE_IDENTITY();

                    INSERT INTO dbo.customer_addresses (aid,cid,ship_bill_boolean)
                    VALUES (@address_id2,@errorCode,1);
                    END
                END

            IF (@agent = 1)
                BEGIN	
                INSERT INTO dbo.addresses (streetname,postalcode,cityname,country)
                VALUES (@streetname1,@postalcode1 ,@cityname1,@country1);
                SET @address_id1 = SCOPE_IDENTITY();

                INSERT INTO dbo.staff (username, passwordhash, firstname, lastname, salutation, address, email, phone)
                VALUES (@username, @hash, @firstname, @lastname, @salutation, @address_id1, @email, @phone);
                SET @errorCode = SCOPE_IDENTITY();
                    
                DECLARE @count INT;
                DECLARE @category VARCHAR(max)
                DECLARE @category_id TINYINT

                SET @count = 0;

                IF (@c_length = 0)
                    BEGIN
                    SET @category_id = (SELECT id FROM ticket_categories WHERE name LIKE @categories + '%');
                    INSERT INTO dbo.ticket_categories_staff (sid,tcid) VALUES (@errorCode,@category_id);
                    END
                ELSE
                    BEGIN
                    WHILE @count <= @c_length
                        BEGIN
                        SET @count = @count + 1;
                        SET @category = (SELECT Data FROM dbo.Split(@categories,',') WHERE Id = @count);
                        SET @category_id = (SELECT id FROM dbo.ticket_categories WHERE name LIKE @category + '%');
                                    
                        INSERT INTO dbo.ticket_categories_staff (sid,tcid) VALUES (@errorCode,@category_id);
                        END
                    END
                END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF @errorMsg LIKE '%UK_customers_username%'
                SET @errorCode = -7
            ELSE IF @errorMsg LIKE '%UK_customers_email%'
                SET @errorCode = -8
            ELSE IF @errorMsg LIKE '%UK_staff_username%'
                SET @errorCode = -9
            ELSE IF @errorMsg LIKE '%UK_staff_email%'
                SET @errorCode = -10
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99
            ROLLBACK TRANSACTION
        END CATCH

        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                IF (@agent = 0)
                    SELECT @errorCode AS customer_id;
                ELSE
                    SELECT @errorCode AS agent_id;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO

-- Tests
-- Variant 1 creates staff / agent
EXEC sp_createUser
 'testuser2' -- must be unique and longer than 6 letters
 ,'Pasddsfsdf!' -- must be longer than 6 letters
 ,'Hubert'
 ,'Testperson'
 ,@salutation = 1
 ,@address1 ='Gries Platz 12,8020,Graz,AT'
 ,@email ='maxchefss@gmail.com' -- must contain @, . and be unique
 ,@categories = 'Billing,VoIP,Server'
 ,@phone = '0 6641213123'
 ,@agent = 1
 ,@select = 1
GO
SELECT * FROM staff
-- Variant 2 creates customer
EXEC sp_createUser
    'customer'  -- must be unique and longer than 6 letters
    ,'Pasddsfsdf!' -- must be longer than 6 letters
    ,'Jamal'
    ,'Mosley'
    ,@salutation = 1
    ,@address1 ='Koenigstrasse 2,63770,Goldbach,DE'
    ,@address2 ='Lange Strasse 95,85702,Unterschleißheim,DE'
    ,@email ='p6dimaux3@temporary-mail.net'  -- must contain @, . and be unique
    ,@phone = '089 40 45 24'
    ,@agent = 0
    ,@select = 1
GO
SELECT * FROM customers


-- Procedur 2: sp_loginUser
-- This procedure is used to log in a user, either agents or customers to their accounts.
GO
CREATE OR ALTER PROCEDURE dbo.sp_loginUser
    @username VARCHAR(50),
    @password VARCHAR(128),
    @agent BIT = 0,
    @errorCode INT = NULL OUTPUT,  -- ticket ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            DECLARE @salt VARCHAR(10) = (SELECT value FROM dbo.settings WHERE id = 2);
            DECLARE @hash VARCHAR(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2);
            DECLARE @actual_hash VARCHAR(128);
            DECLARE @locked BIT;

            IF (@agent = 0)
                BEGIN
                SELECT @actual_hash = passwordhash, @errorCode = id, @locked = locked
			    FROM dbo.customers
			    WHERE username = @username;
                IF @locked = 1
                    THROW 50011, 'login: ACCOUNT IS LOCKED',1;

                IF @errorCode IS NULL
                    THROW 50012, 'login: WRONG USERNAME', 1;

                IF @hash = @actual_hash
                    BEGIN
                    UPDATE dbo.customers 
                    SET last_login = SYSDATETIME(), failed_logins = 0 
                    WHERE id = @errorCode;
                    END
                ELSE
                    BEGIN
                    IF @actual_hash IS NOT NULL
                        BEGIN
                        UPDATE dbo.customers 
                        SET failed_logins += 1 
                        WHERE username = @username;
                        THROW 50013, 'login: WRONG PASSWORD', 1;
                        END
                    END
                END
            IF @agent = 1
                BEGIN
                SELECT @actual_hash = passwordhash,
				@errorCode = id
			    FROM dbo.staff
			    WHERE username = @username;

                IF @errorCode IS NULL
                    THROW 50014, 'login: WRONG USERNAME', 1;

                IF @hash = @actual_hash
                    BEGIN
                    UPDATE dbo.staff 
                    SET last_login = SYSDATETIME(), failed_logins = 0 
                    WHERE id = @errorCode;
                    END
                ELSE
                    BEGIN
                    IF @actual_hash IS NOT NULL
                        BEGIN
                        UPDATE dbo.staff 
                        SET failed_logins += 1 
                        WHERE username = @username;
                        THROW 50015, 'login: WRONG PASSWORD', 1;
                        END
                    END
                END
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS account_id;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO
-- Tests
-- Variant 1 right password
EXEC sp_loginUser
    'dwori10' 
    ,'Pa55w.rd!!'
    ,@agent = 1
    ,@select = 1
GO
EXEC sp_loginUser 
    'mensur480'
    ,'Mensur123#'
    ,@agent = 1
    ,@select = 1
GO
-- Variant 2 wrong password
EXEC sp_loginUser
    'customer3' 
    ,'hallo!!!'
    ,@agent = 0
    ,@select = 1
GO
-- reset 
EXEC sp_unlockUser 2, @select = 1


-- Procedur 3: sp_unlockUser
-- This procedure is used to unlock a user account after too many failed logins. 
GO
CREATE OR ALTER PROCEDURE dbo.sp_unlockUser
    @customer_id INT,
    @errorCode INT = NULL OUTPUT,  -- agent ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            --Variables
            DECLARE @locked BIT
            DECLARE @failed_logins TINYINT
            DECLARE @maxFailed_logins INT = (SELECT value FROM dbo.settings WHERE id = 4)

            --Fetch locked status and number of failed logins
            SELECT @locked = locked, @failed_logins = failed_logins
            FROM dbo.customers
            WHERE id = @customer_id;
            IF (@failed_logins IS NULL)
                THROW 50016, 'unlock: THIS ACCOUNT DOES NOT EXIST',1;
            --If there are more than 3 failed logins and the account is locked it ges unlocked with an update 
            IF (@failed_logins >= @maxFailed_logins AND @locked = 1)
                BEGIN
                UPDATE dbo.customers
                SET locked = 0,failed_logins = 0
                WHERE id = @customer_id;

                SET @errorCode = @customer_id;
                END
            ELSE
                THROW 50017, 'unlock: THIS ACCOUNT IS NOT LOCKED',1;

        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE();
            IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1;
            ELSE
                SET @errorCode = -99;
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS customer_id;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO
-- TESTS
-- Variant 1 (locks user so that it is possbile to unlock him)
EXEC sp_loginUser
    'customer3' 
    ,'hallo!!!'
    ,@agent = 0
    ,@select = 1
GO
-- reset 
EXEC sp_unlockUser 2, @select = 1
-- Variant 2 with errors
EXEC sp_unlockUser 11111, @select = 1
EXEC sp_unlockUser 1, @select = 1


-- Procedur 4: dbo.sp_createTicket
-- With this procedure, customers can issue tickets to the agents. It creates a new ticket and automatically assigns a new agent to it.
-- But only if there is an agent available and if he is as-signed to the category the ticket is related to. Another feature is that the timestamp
-- of the ticket’s creation is stored.
GO
CREATE OR ALTER PROCEDURE dbo.sp_createTicket
    @subject VARCHAR(100),
    @content VARCHAR(255),
    @customer INT,
    @category TINYINT,
    @errorCode INT = NULL OUTPUT,  -- ticket ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @status INT = 1
        DECLARE @priority TINYINT = 1
        DECLARE @agent INT
        DECLARE @maxQueue INT  = (SELECT value FROM dbo.settings WHERE id = 1)
        BEGIN TRY
            BEGIN TRANSACTION;

            --Check if category does exist and if an agent holds that category
            IF (SELECT COUNT(*) FROM dbo.ticket_categories WHERE id = @category) = 0
            AND (SELECT COUNT(*) FROM dbo.ticket_categories_staff WHERE tcid = @category) = 0
                THROW 50018, 'ticket: THIS CATEGORY DOES NOT EXIST', 1;
            /*
             * Set @agent to the agent with the lowest ticket_queue who hold the provided category and
             * whose ticket_queue is below the maximum
            */
            SET @agent = (
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    ) AND ticket_queue < @maxQueue
                ORDER BY ticket_queue ASC
            );

            --If there are no agents available throw an error
            IF (@agent IS NULL)
                THROW 50019,'ticket: NO AGENT AVAILABLE RIGHT NOW',1;
            --Insert data into dbo.ticket
            INSERT INTO dbo.ticket(subject,ticket_content,customer_number,agent,status,category,priority)
            VALUES(@subject,@content,@customer,@agent,@status,@category,@priority);

            SET @errorCode = SCOPE_IDENTITY(); 

            --Increase the agent´s ticket_queue
            UPDATE dbo.staff
            SET ticket_queue = ISNULL(ticket_queue,0) + 1
            WHERE id = @agent;
            
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH  
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_customer%'
                SET @errorCode = -20;
            ELSE
                SET @errorCode = -99;
            ROLLBACK TRANSACTION;
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS ticket_id;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO
--TEST
-- Variant 1
EXEC sp_createTicket 'long loading times on website','The website is teaking to long when loading on the users browser. compress pictures',2,@category = 4,@select =1;
EXEC sp_createTicket 'Cronjob not working','The cronjob is not working is intent, several indexes stopped updating',3,@category = 5, @select = 1;



-- Procedur 5: dbo.sp_changeStatus
-- This procedure is used by agents to start a transition from one status into another. 
GO
CREATE OR ALTER PROCEDURE dbo.sp_changeStatus
    @ticket_id INT,
    @status INT,
    @errorCode INT = NULL OUTPUT,  -- Status ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @agent INT = (SELECT agent FROM ticket WHERE id = @ticket_id);
        BEGIN TRY
            BEGIN TRANSACTION;
            --Check if ticket exists and if it does not hold the provided status
            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id AND status = @status) = 1
                THROW 50021, 'status: TICKET ALREADY HAS THIS STATUS', 1;

            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
                BEGIN
                UPDATE dbo.ticket
                SET status = @status
                WHERE id = @ticket_id;

                --If the provided status is 3 the ticket will be finished. Therfore the ticket_queue of the agent needs to be decreased
                --and his finished_tickets need to be incresed.
                IF (@status = 3)
                    BEGIN
                    --Decrease ticket_queue
                    UPDATE dbo.staff
                    SET ticket_queue = ticket_queue - 1
                    WHERE id = @agent;

                    --Increase finished_tickets
                    UPDATE dbo.staff
                    SET finished_tickets = finished_tickets + 1
                    WHERE id = @agent;
                    END
                END
            ELSE 
                THROW 50022, 'status: NO TICKET WITH THIS ID FOUND', 1;

            SET @errorCode = @status;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF @errorMsg LIKE '%FK_ticket_statuses%'
                SET @errorCode = -23
            ELSE IF @errorMsg LIKE '%FK_ticket%'
                SET @errorCode = -24;
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1;
            ELSE
                SET @errorCode = -99;

            IF @@trancount = 1
                ROLLBACK TRANSACTION;
        END CATCH
        IF (@select = 1)
            BEGIN
                IF (@errorCode > 0)
                    SELECT @errorCode AS Status;
                ELSE
                    SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO
-- TEST
-- Status 2 
EXEC sp_changeStatus 3,2,@select = 1
SELECT * FROM ticket WHERE id = 3

-- Status 1
EXEC sp_changeStatus 3,1,@select = 1
SELECT * FROM ticket WHERE id = 3

-- Status 3
EXEC sp_changeStatus 3,3,@select = 1
SELECT * FROM ticket WHERE id = 3
SELECT * FROM ticket_statuses


-- Procedur 6: dbo.sp_changePriority
-- The procedure is used by the agents to change the priority of their tickets.
GO
CREATE OR ALTER PROCEDURE dbo.sp_changePriority
    @ticket_id  INT,
    @priority TINYINT,
    @errorCode INT = NULL OUTPUT,  -- Priority ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            --Check if ticket already has the provided Priority
            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id AND priority = @priority) = 1
            THROW 50025, 'priority: TICKET HAS ALREADY THIS PRIORITY',1;
            
            --Only update priority if the ticket exists
            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
            BEGIN
                UPDATE dbo.ticket
                SET priority = @priority
                WHERE id = @ticket_id;
            END
            ELSE
                THROW 50026,'priority: THIS TICKET DOES NOT EXIST',1;

            SET @errorCode = @priority;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_priorities%'
                SET @errorCode = -27
            ELSE IF ERROR_MESSAGE() like '%FK_ticket%'
                SET @errorCode = -28
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS Priority;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO

-- PRIORITY CHANGE
EXEC sp_changePriority 6,3,@select = 1


-- Procedur 7: dbo.sp_switchAgent
-- This procedure is used to switch tickets from one agent to another. It is automatically used in the trigger if someone is absent
-- for longer than some days or with unknown end of absence.
GO
CREATE OR ALTER PROCEDURE dbo.sp_switchAgent
    @ticket_id INT,
    @errorCode int = NULL OUTPUT,  -- agent ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION; 
            
            DECLARE @oldAgent INT = (SELECT agent FROM dbo.ticket WHERE id = @ticket_id);
            DECLARE @newAgent INT;
            DECLARE @category SMALLINT = (SELECT category FROM dbo.ticket WHERE id = @ticket_id);
            DECLARE @maxQueue INT = (SELECT value FROM dbo.settings WHERE id = 1);
            /*
             * Set @newAgent to the agent with the lowest ticket_queue who hold the category of the ticket that should be switched
             * and whose ticket_queue is below the maximum. Also @newAgent can not be @oldAgent
            */
            SET @newAgent = (  
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    )AND ticket_queue < @maxQueue AND id <> @oldAgent
                    ORDER BY ticket_queue ASC);

            --If there are no agents available throw an error        
            IF @newAgent IS NULL
                THROW 50029, 'switch: NO AGENT AVAILABLE TO SWITCH WITH',1;
            --Update the agent in the ticket table where id is like the provided id.
            UPDATE ticket
            SET agent = @newAgent
            WHERE id = @ticket_id;
            --Decrease ticket_queue by one for @oldAgent if id was not null
            IF (SELECT ticket_queue FROM staff WHERE id = @oldAgent) > 0
                BEGIN
                UPDATE dbo.staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @oldAgent;
                END
            --Increase ticket_queue for @newAgent by one.
            UPDATE dbo.staff
            SET ticket_queue = ticket_queue + 1
            WHERE id = @newAgent;

            SET @errorCode = @newAgent;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_agent%'
                SET @errorCode = -30;
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1;
            ELSE
                SET @errorCode = -99;
            ROLLBACK TRANSACTION;
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS new_agent;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO


-- Test Variant 1
EXEC sp_switchAgent @ticket_id = 2,@select = 1;


-- Procedur 8: dbo.absence
-- The sp_absence procedure puts agents on vacation or rather sets them absent, either until a certain date or open ended.
GO
CREATE OR ALTER PROCEDURE sp_absence
    @agent INT,
    @startDate DATETIME2,
    @endDate DATETIME2 = NULL,
    @errorCode INT = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0
    AS 
    BEGIN
        SET NOCOUNT ON;
        DECLARE @absence INT = NULL;
        BEGIN TRY
            BEGIN TRANSACTION;
            --Add starttime & endtime
            UPDATE dbo.staff
            SET absence_begin = @startDate
            WHERE id = @agent;

            UPDATE dbo.staff
            SET absence_end = @endDate
            WHERE id = @agent;
            --If the endtime is not null, the length of the absence in days will be stored in  @absence. Else it´s set to null.
            IF @endDate IS NOT NULL
                SET @absence = DATEDIFF(DAY,@startDate,@endDate);

            --Setting errorcode to the agent´s is who is absent
            SET @errorCode = @agent;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
                SET @errorMsg = ERROR_MESSAGE()
                IF ERROR_MESSAGE() like '%FK_staff%'
                    SET @errorCode = -31
                ELSE IF ERROR_NUMBER() >= 50000
                    SET @errorCode = (ERROR_NUMBER() - 50000) * -1
                ELSE
                    SET @errorCode = -99
                IF @@trancount = 3
                    ROLLBACK;
        END CATCH
        IF (@select = 1)
            BEGIN
            IF (@errorCode > 0)
                SELECT @errorCode AS Agent, @absence AS absence_days;
            ELSE
                SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO


-- Test
--4 days
EXEC sp_absence 5,'20210114 12:30:00','20210119 12:30:00', @select = 1;
-- without end
EXEC sp_absence 2,'20210106 12:30:00', @select = 1;
-- reset the agent to not absent
EXEC sp_absence 5,NULL, NULL, @select = 1;

select * from staff
select * from ticket

-- #######################################################################################
--  Userdefined functions
-- #######################################################################################

-- dbo.Split
-- This function is used to split a string at the provided delimiter.
GO
CREATE OR ALTER FUNCTION dbo.Split
  (
      @String NVARCHAR(4000),
      @Delimiter NCHAR(1)
  )
  RETURNS TABLE
  AS
  RETURN
  (
      WITH Split(stpos,endpos)
      AS(
          SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
          UNION ALL
          SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
              FROM Split
              WHERE endpos > 0
      )
      SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
          'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
      FROM Split
  )
GO