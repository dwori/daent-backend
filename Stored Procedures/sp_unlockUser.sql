GO
CREATE OR ALTER PROCEDURE sp_unlockUser
    @customer_id INT,
    
    --Debug
    @errorCode int = NULL OUTPUT,  -- agent ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
        --Variables
        DECLARE @locked bit
        DECLARE @failed_logins tinyint

        --Fetch locked status and number of failed logins
        SELECT @locked = locked, @failed_logins = failed_logins
        FROM dbo.customers
        WHERE id = @customer_id;

        --If there are more than 3 failed logins and the account is locked it ges unlocked with an update 
        IF (@failed_logins > 3 AND @locked = 1)
            BEGIN
                UPDATE dbo.customers
                SET locked = 0,failed_logins = 0
                WHERE id = @customer_id;
            END
        ELSE
            THROW 50002, 'user is not locked',1;

        SET @errorCode = @customer_id;
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