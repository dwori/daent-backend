GO
CREATE OR ALTER PROCEDURE sp_unlockUser
  
    @customer_id INT,
    @errorCode int = NULL OUTPUT,  
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0
    AS
    BEGIN
        BEGIN TRY
        SET NOCOUNT ON
        DECLARE @locked bit
        DECLARE @failed_logins tinyint

        SELECT @locked = locked,
        @failed_logins = failed_logins
        FROM dbo.customers WHERE id = @customer_id

        IF (@failed_logins > 3 AND @locked = 1)
            BEGIN
                UPDATE dbo.customers SET locked = 0,failed_logins = 0 WHERE id = @customer_id
            END
        ELSE
            THROW 50002, 'user is not locked',1;
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