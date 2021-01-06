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
        
        --Variablen
        DECLARE @oldAgent INT = (SELECT agent FROM ticket WHERE id = @ticket_id)
        DECLARE @newAgent INT
        DECLARE @category SMALLINT = (SELECT category FROM ticket WHERE id = @ticket_id)
        DECLARE @maxQueue INT = (SELECT value FROM dbo.settings WHERE id = 1)
        


        ----------------------------------------------------------------
        BEGIN TRY
            BEGIN TRANSACTION; 
            SET @newAgent = (  
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    )AND ticket_queue < @maxQueue AND id <> @oldAgent
                    ORDER BY ticket_queue ASC)
            IF @newAgent IS NULL
                THROW 51234, 'No Agent available to switch ticket with!',1;
            --Neuen Agenten eintragen ins Ticket
            UPDATE ticket
            SET agent = @newAgent
            WHERE id = @ticket_id;
            
            --ticket_queue für beide Agenten verändern
            IF (SELECT ticket_queue FROM staff WHERE id = @oldAgent) > 0
            BEGIN
                UPDATE staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @oldAgent;
            END
            
            UPDATE staff
            SET ticket_queue = ticket_queue + 1
            WHERE id = @newAgent;


            SET @errorCode = @newAgent
           
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_agent%'
                SET @errorCode = -1
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99
                
            IF @@trancount = 1
                ROLLBACK
        END CATCH

        IF @select = 1
           SELECT @errorCode AS NewAgent, @errorMsg AS errorMessage, @errorLine AS errorLine
        

    END

GO

