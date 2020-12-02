
GO
CREATE OR ALTER PROCEDURE sp_createUser
  
  @username VARCHAR(60),
  @password VARCHAR(128),
  @firstname VARCHAR(255),
  @lastname VARCHAR(255),
  @salutation TINYINT,
  @address1 VARCHAR(255),
  @address2 VARCHAR(255) = NULL,
  @email VARCHAR(255),
  @phone VARCHAR(255),
  @agent bit = 0,
  
  --Error Handeling ;)
  @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
  @errorLine int = NULL OUTPUT,
  @errorMsg VARCHAR(500) = NULL OUTPUT,
  @select bit = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            DECLARE @salt varchar(10) = '#sA1tyAF!?'
            DECLARE @hash varchar(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2)

            IF @agent = 0 
            BEGIN	
                IF LEN(ISNULL(@password, '')) < 6 OR @password NOT LIKE '%[#!*µ]%'
                    THROW 50002, 'register: PASSWORD NOT COMPLEX ENOUGH', 1;

                IF LEN(ISNULL(@username, '')) < 6 
                    THROW 50003, 'register: USERNAME IS TOO SHORT', 1;

                IF @email NOT LIKE '%[@.]%' 
                    THROW 50004, 'register: NO VALID EMAIL ADDRESS', 1;

                SET @email = LOWER(@email)

                IF @phone LIKE '%_%' 
                    SET @phone = REPLACE(@phone, ' ', '')

                IF @phone LIKE '0%' 
                    SET @phone = STUFF(@phone, CHARINDEX('0', @phone), LEN('0'), '+43')

                INSERT INTO dbo.customers (username, passwordhash, firstname, lastname, salutation, billing_address, shipping_address, email, phone) VALUES (@username, @hash, @firstname, @lastname, @salutation, @address1, @address2, @email, @phone)
                SET @errorCode = SCOPE_IDENTITY()
            END

            IF @agent = 1 
            BEGIN	
                IF LEN(ISNULL(@password, '')) < 6 OR @password NOT LIKE '%[#!*µ]%'
                    THROW 50002, 'register: PASSWORD NOT COMPLEX ENOUGH', 1;

                IF LEN(ISNULL(@username, '')) < 6 
                    THROW 50003, 'register: USERNAME IS TOO SHORT', 1;

                IF @email NOT LIKE '%[@.]%' 
                    THROW 50004, 'register: NO VALID EMAIL ADDRESS', 1;

                SET @email = LOWER(@email)

                IF @phone LIKE '%_%' 
                    SET @phone = REPLACE(@phone, ' ', '')

                IF @phone LIKE '0%' 
                    SET @phone = STUFF(@phone, CHARINDEX('0', @phone), LEN('0'), '+43')

                INSERT INTO dbo.staff (username, passwordhash, firstname, lastname, salutation, address, email, phone) VALUES (@username, @hash, @firstname, @lastname, @salutation, @address1, @email, @phone)
                SET @errorCode = SCOPE_IDENTITY()
            END

        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() LIKE '%UK_customers_username%'
                SET @errorCode = -1

            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99

        END CATCH

        IF @select = 1
            SELECT @errorCode AS result, @errorMsg AS errormessage, @errorLine AS Line
    END
GO



EXEC sp_createUser 'dominikk', 'hallo!!!!', 'Dominik', 'Kainz', 1 ,'Weinbergweg 4','Weinbergweg 4','kainz.domi@gmail.com', '0 6641062393', @agent = 1, @select = 1


EXEC sp_CreateUser 'huso111', 'hallo!!!!', 'Dominik', 'Kainz', 1 ,'Weinbergweg 4','Weinbergweg 4','kainz.domi@gmail.com', '0664102002', @agent = 0, @select = 1


EXEC sp_loginUser 'dominikk', 'hallo!!!!', @select = 1, @agent = 1