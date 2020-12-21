GO
CREATE OR ALTER PROCEDURE sp_loginUser
  
  @username VARCHAR(50),
  @password VARCHAR(128),
  @agent BIT = 0,

  --Error Handeling
  @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
  @errorLine int = NULL OUTPUT,
  @errorMsg VARCHAR(500) = NULL OUTPUT,
  @select bit = 0

    AS
    BEGIN
        BEGIN TRY
            DECLARE @salt varchar(10) = '#sA1tyAF!?'
            DECLARE @hash varchar(128) = CONVERT(varchar(128), HASHBYTES('SHA2_512', @password + @salt), 2)
            DECLARE @actual_hash varchar(128)
            IF @agent = 0
            BEGIN
                SELECT @actual_hash = passwordhash,
				@errorCode = id
			    FROM dbo.customers
			    WHERE username = @username

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

        IF @select = 1
            SELECT @errorCode AS resultCode, @errorMsg AS errorMessage, @errorLine AS errorLine
    END
GO
