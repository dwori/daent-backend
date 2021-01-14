GO
CREATE OR ALTER PROCEDURE sp_changePriority
    @ticket_id  INT,
    @priority TINYINT,

    --Debug
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
            THROW 50004, 'ticket has already this priority',1;
            
            --Only update priority if the ticket exists
            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
            BEGIN
                UPDATE ticket
                SET priority = @priority
                WHERE id = @ticket_id;

            END
            ELSE
                THROW 50025,'This ticket does not exist!',1;

            SET @errorCode = @priority;

            END TRY
            BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_priorities%'
                SET @errorCode = -1
            ELSE IF ERROR_MESSAGE() like '%FK_ticket%'
                SET @errorCode = -2

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