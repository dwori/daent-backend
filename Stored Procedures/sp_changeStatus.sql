/*Ändert den Status eines Tickets*/


GO
CREATE OR ALTER PROCEDURE dbo.sp_changeStatus
    @ticket_id INT,
    @status INT,
    --Developer Mode
    @errorCode int = NULL OUTPUT,  
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0
    AS
    BEGIN
        SET NOCOUNT ON;

        --Variablen
        DECLARE @agent INT
        SET @agent = (SELECT agent FROM ticket WHERE id = @ticket_id)
        DECLARE @tran int = @@trancount

            
        BEGIN TRY
        BEGIN TRANSACTION
        set @tran = @@trancount
        --Wenn Ticket ID existiert führe code aus
        IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id AND status = @status) = 1
            THROW 50001, 'ticket has already this status',1;

        IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
        BEGIN
            -- IF ERROR_MESSAGE() IS NULL
            -- BEGIN
                UPDATE dbo.ticket
                SET status = @status
                WHERE id = @ticket_id
            -- END
            
            /*
            Bei insert eines Status, wird die Queue um 1 erhöht bzw. bei Update um 1 verringert. 
            Dabei wird beim verringern der queue dem Mitarbeiter closed_cases um 1 erhöht.
            */

            IF @status = 3 -- AND ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @agent

                UPDATE dbo.staff
                SET finished_tickets = finished_tickets + 1
                WHERE id = @agent
            END
        END
        ELSE 
        BEGIN;
            THROW 50002, 'No id was found!',1;
        END
        COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_statuses%'
                SET @errorCode = -1
            IF ERROR_MESSAGE() like '%FK_ticket%'
                SET @errorCode = -2

            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99

            IF @@trancount = 1
                ROLLBACK
        END CATCH
        IF @select = 1
            SELECT @errorCode AS resultCode, @errorMsg AS errorMessage, @errorLine AS errorLine
    END