/*
Erstellt ein neues Ticket, welches mit den dafür nötigen Attributen befüllt wird. 
Über die Kategorie werden passende Sachbearbeiter ermittelt. 
Dann wird dem jenigen mit der niedrigsten queue das Ticket zugeordnet. 
Eingabeparameter: , subject, category, content. 
Beim ausführen der Prozedur wird der timestamp in created_at gespeichert, Status und priority auf auf den default Wert 1 gesetzt.
*/

GO
CREATE OR ALTER   PROCEDURE dbo.sp_createTicket
    @subject VARCHAR(100),
    @content VARCHAR(255),
    @customer INT,
    @category TINYINT,

    --Debug
    @errorCode int = NULL OUTPUT,  -- ticket ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        --Variables
        DECLARE @status INT = 1
        DECLARE @priority TINYINT = 1
        DECLARE @agent INT
        DECLARE @maxQueue INT 
            SET @maxQueue = (SELECT value FROM dbo.settings WHERE id = 1)


        BEGIN TRY
            BEGIN TRANSACTION;

            --Check if category does exist and if an agent holds that category
            IF (SELECT COUNT(*) FROM dbo.ticket_categories WHERE id = @category) = 0
            AND (SELECT COUNT(*) FROM dbo.ticket_categories_staff WHERE tcid = @category) = 0
                THROW 50004, 'This category does not exist', 1;

            /*
             * Set @agent to the agent with the lowest ticket_queue who hold the provided category and
             * whose ticket_queue is below the maximum
            */
            SET @agent = (
                SELECT TOP 1 id FROM dbo.staff WHERE id IN(
                    SELECT sid 
                    FROM dbo.ticket_categories_staff 
                    WHERE tcid = @category
                    ) AND ticket_queue < @maxQueue
                ORDER BY ticket_queue ASC
            );

            --If there are no agents available throw an error
            IF (@agent IS NULL)
                THROW 50089,'No agent available right now!',1;
            --Insert data into dbo.ticket
            INSERT INTO dbo.ticket(subject,ticket_content,customer_number,agent,status,category,priority)
            VALUES(@subject,@content,@customer,@agent,@status,@category,@priority);

            SET @errorCode = SCOPE_IDENTITY(); 

            --Increase the agent´s ticket_queue
            UPDATE dbo.staff
            SET ticket_queue = ISNULL(ticket_queue,0) + 1
            WHERE id = @agent;
            
            COMMIT;
        END TRY
        BEGIN CATCH  
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_customer%'
                SET @errorCode = -1;
            ELSE
                SET @errorCode = -99;
            ROLLBACK;
        END CATCH

        IF (@select = 1)
            BEGIN
                IF (@errorCode > 0)
                    SELECT @errorCode AS ticket_id;
                ELSE
                    SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
END
GO
