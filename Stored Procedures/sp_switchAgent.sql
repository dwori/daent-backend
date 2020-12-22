GO
CREATE OR ALTER PROCEDURE sp_switchAgent
    @ticket_id INT,

    --Debug mode
    @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRANSACTION
        --Variablen
        DECLARE @oldAgent INT = (SELECT agent FROM ticket WHERE id = @ticket_id)
        DECLARE @newAgent INT
        DECLARE @category SMALLINT = (SELECT category FROM ticket WHERE id = @ticket_id)
        DECLARE @maxQueue INT = (SELECT value FROM dbo.settings WHERE id = 1)



        ----------------------------------------------------------------
        BEGIN TRY
            SET @newAgent = (
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    ) AND ticket_queue < @maxQueue AND id <> @oldAgent
                    ORDER BY ticket_queue ASC)

            --Neuen Agenten eintragen ins Ticket
            UPDATE ticket
            SET agent = @newAgent
            WHERE id = @ticket_id;

            --ticket_queue für beide Agenten verändern
            UPDATE staff
            SET ticket_queue = ticket_queue - 1
            WHERE id = @oldAgent;

            UPDATE staff
            SET ticket_queue = ticket_queue + 1
            WHERE id = @newAgent;


            SET @errorCode = @newAgent
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_agent%'
                SET @errorCode = -1
            ELSE
                SET @errorCode = -99

        END CATCH

        IF @select = 1
           SELECT @errorCode AS NewAgent, @errorMsg AS errorMessage, @errorLine AS errorLine
        

    END

GO