GO
CREATE OR ALTER PROCEDURE sp_switchAgent
    @ticket_id INT,

    --Debug
    @errorCode int = NULL OUTPUT,  -- agent ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        
        --Variablen
        DECLARE @oldAgent INT = (SELECT agent FROM ticket WHERE id = @ticket_id)
        DECLARE @newAgent INT
        DECLARE @category SMALLINT = (SELECT category FROM ticket WHERE id = @ticket_id)
        DECLARE @maxQueue INT = (SELECT value FROM dbo.settings WHERE id = 1)
        
        BEGIN TRY
            BEGIN TRANSACTION; 

            /*
             * Set @newAgent to the agent with the lowest ticket_queue who hold the category of the ticket that should be switched
             * and whose ticket_queue is below the maximum. Also @newAgent can not be @oldAgent
            */
            SET @newAgent = (  
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    )AND ticket_queue < @maxQueue AND id <> @oldAgent
                    ORDER BY ticket_queue ASC);

            --If there are no agents available throw an error        
            IF @newAgent IS NULL
                THROW 51234, 'No Agent available to switch ticket with!',1;

            --Update the agent in the ticket table where id is like the provided id.
            UPDATE ticket
            SET agent = @newAgent
            WHERE id = @ticket_id;
            
            --Decrease ticket_queue by one for @oldAgent if id was not null
            IF (SELECT ticket_queue FROM staff WHERE id = @oldAgent) > 0
            BEGIN
                UPDATE staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @oldAgent;
            END
            
            --Increase ticket_queue for @newAgent by one.
            UPDATE staff
            SET ticket_queue = ticket_queue + 1
            WHERE id = @newAgent;


            SET @errorCode = @newAgent;
           
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_agent%'
                SET @errorCode = -1;
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1;
            ELSE
                SET @errorCode = -99;
                
            ROLLBACK;

        END CATCH

        IF (@select = 1)
            BEGIN
                IF (@errorCode > 0)
                    SELECT @errorCode AS new_agent;
                ELSE
                    SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
    END
GO

