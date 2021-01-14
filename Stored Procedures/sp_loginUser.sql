GO
CREATE OR ALTER PROCEDURE sp_loginUser
    @username VARCHAR(50),
    @password VARCHAR(128),
    @agent BIT = 0,

    --Debug
    @errorCode int = NULL OUTPUT,  -- ticket ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            --Variables
            DECLARE @salt varchar(10) = (SELECT value FROM settings WHERE id= 2)
            DECLARE @hash varchar(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2)
            DECLARE @actual_hash varchar(128)
            DECLARE @locked bit

            IF (@agent = 0)
            BEGIN
                SELECT @actual_hash = passwordhash, @errorCode = id, @locked = locked
			    FROM dbo.customers
			    WHERE username = @username
                IF @locked = 1
                    THROW 50005, 'login: ur account is locked',1;

                IF @errorCode IS NULL
                    THROW 50001, 'login: WRONG USERNAME', 1;

                IF @hash = @actual_hash
                BEGIN
                    UPDATE dbo.customers SET last_login = SYSDATETIME(), failed_logins = 0 WHERE id = @errorCode
                END
                ELSE
                BEGIN
                    IF @actual_hash IS NOT NULL
                    BEGIN
                        UPDATE dbo.customers SET failed_logins += 1 WHERE username = @username;
                        THROW 50002, 'login: WRONG PASSWORD', 1
                    END
                END
            END
            IF @agent = 1
            BEGIN
                SELECT @actual_hash = passwordhash,
				@errorCode = id
			    FROM dbo.staff
			    WHERE username = @username

                IF @errorCode IS NULL
                    THROW 50001, 'login: WRONG USERNAME', 1;

                IF @hash = @actual_hash
                BEGIN
                    UPDATE dbo.staff SET last_login = SYSDATETIME(), failed_logins = 0 WHERE id = @errorCode
                END
                ELSE
                BEGIN
                    IF @actual_hash IS NOT NULL
                    BEGIN
                        UPDATE dbo.staff SET failed_logins += 1 WHERE username = @username;
                        THROW 50002, 'login: WRONG PASSWORD', 1
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
