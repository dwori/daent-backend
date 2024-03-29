
GO
CREATE OR ALTER PROCEDURE sp_createUser
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
    @agent bit = 0,
  
    --Debug
    @errorCode int = NULL OUTPUT,  -- Customer/Agent ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY

            BEGIN TRANSACTION
        

            --Variables

            DECLARE @a1_length int
            DECLARE @a2_length int
            DECLARE @c_length int


            -- not lenght anymore, but the comma count 
            SET @a1_length = len(@address1) - len(replace(@address1,',',''))
            SET @a2_length = len(@address2) - len(replace(@address2,',',''))
            SET @c_length = len(@categories) - len(replace(@categories,',','')) 

            --Check the complexity of the password
            IF LEN(ISNULL(@password, '')) < 6 OR @password NOT LIKE '%[#!*µ]%'
                    THROW 50002, 'register: PASSWORD NOT COMPLEX ENOUGH', 1;

            IF LEN(ISNULL(@username, '')) < 6 
                    THROW 50003, 'register: USERNAME IS TOO SHORT', 1;

            IF @email NOT LIKE '%[@.]%' 
                    THROW 50004, 'register: NO VALID EMAIL ADDRESS', 1;
            
            IF NOT @a1_length = 3
                    THROW 50005, 'no valid address', 1;
            
            IF NOT @a2_length = 3
                    THROW 50006, 'no valid address2', 1;

            SET @email = LOWER(@email)

            IF @phone LIKE '%_%' 
                    SET @phone = REPLACE(@phone, ' ', '');


            --parameters needed for password encryption
            DECLARE @salt varchar(10) = (SELECT value FROM dbo.settings WHERE id = 2)
            DECLARE @hash varchar(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2)

            DECLARE @address_id1 int
           
            DECLARE @streetname1 VARCHAR(80)
            DECLARE @postalcode1 int
            DECLARE @cityname1 VARCHAR(80)
            DECLARE @country1 VARCHAR(2)

            SET @streetname1 = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 1)
            SET @postalcode1 = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 2)
            SET @cityname1 = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 3)
            SET @country1 = (SELECT Data from dbo.Split(@address1,',') WHERE Id = 4)

                      


            --For the creation of a customer
            IF (@agent = 0)
            BEGIN
                IF @address2 IS NOT NULL
                BEGIN
                    DECLARE @streetname2 VARCHAR(80)
                    DECLARE @postalcode2 int
                    DECLARE @cityname2 VARCHAR(80)
                    DECLARE @country2 VARCHAR(2)
                    DECLARE @address_id2 int
                    

                    SET @streetname2 = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 1)
                    SET @postalcode2 = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 2)
                    SET @cityname2 = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 3)
                    SET @country2 = (SELECT Data from dbo.Split(@address2,',') WHERE Id = 4)
                    
                END


                
                    INSERT INTO dbo.customers (username,passwordhash,firstname,lastname,salutation,email,phone,locked) VALUES (@username,@hash,@firstname,@lastname,@salutation,@email,@phone,0)
                    SET @user_id = SCOPE_IDENTITY()
                    PRINT @user_id


                    INSERT INTO dbo.addresses (streetname,postalcode,cityname,country)
                    VALUES (@streetname1,@postalcode1,@cityname1,@country1);
                    SET @address_id1 = SCOPE_IDENTITY()

                    INSERT INTO dbo.customer_addresses (aid,cid,ship_bill_boolean)
                    VALUES (@address_id1,@errorCode,0)

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

                            INSERT INTO dbo.ticket_categories_staff (sid,tcid)
                            VALUES (@errorCode,@category_id);
                        END
                    ELSE
                        BEGIN
                            WHILE @count <= @c_length
                                BEGIN
                                    SET @count = @count + 1;
                                    SET @category = (SELECT Data FROM dbo.Split(@categories,',') WHERE Id = @count);
                                    SET @category_id = (SELECT id FROM dbo.ticket_categories WHERE name LIKE @category + '%');
                                    
                                    INSERT INTO dbo.ticket_categories_staff (sid,tcid)
                                    VALUES (@errorCode,@category_id);
                                END
                        END

                
            END
        COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()

            IF @errorMsg LIKE '%UK_customers_username%'
                SET @errorCode = -1
            
            IF @errorMsg LIKE '%UK_customers_email%'
                SET @errorCode = -2
            
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99

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

