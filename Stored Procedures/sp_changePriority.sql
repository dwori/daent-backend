GO
CREATE OR ALTER PROCEDURE sp_changePriority
    @ticket_id  INT,
    @priority SMALLINT,

    --Error Handeling ;)
    @user_id INT = NULL OUTPUT, 
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0


        AS
        BEGIN
            SET NOCOUNT ON;

            --Wenn Ticket existiert, führe Code aus.
            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id AND priority = @priority) = 1
            THROW 50004, 'ticket has already this priority',1;

            IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
            BEGIN
                UPDATE ticket
                SET priority = @priority
                WHERE id = @ticket_id
                
            END
        END
        END
GO