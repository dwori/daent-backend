GO
CREATE OR ALTER PROCEDURE dbo.sp_changeStatus
    @ticket_id INT,
    @status INT,
    
    --Debug
    @errorCode int = NULL OUTPUT,  -- Status ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS
    BEGIN
        SET NOCOUNT ON;

        --Variables
        DECLARE @agent INT
            SET @agent = (SELECT agent FROM ticket WHERE id = @ticket_id)
        DECLARE @tran int = @@trancount
       
        BEGIN TRY
        BEGIN TRANSACTION;
        SET @tran = @@trancount;
        --Check if ticket exists and if it does not hold the provided status
        IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id AND status = @status) = 1
            THROW 50001, 'ticket has already this status',1;

        IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
        BEGIN
            UPDATE dbo.ticket
            SET status = @status
            WHERE id = @ticket_id;

            --If the provided status is 3 the ticket will be finished. Therfore the ticket_queue of the agent needs to be decreased
            --and his finished_tickets need to be incresed.
            IF (@status = 3)
            BEGIN
                --Decrease ticket_queue
                UPDATE dbo.staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @agent;

                --Increase finished_tickets
                UPDATE dbo.staff
                SET finished_tickets = finished_tickets + 1
                WHERE id = @agent;
            END
        END
        ELSE 
        BEGIN;
            THROW 50002, 'No id was found!',1;
        END

        SET @errorCode = @status;
        COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_statuses%'
                SET @errorCode = -1;
            IF ERROR_MESSAGE() like '%FK_ticket%'
                SET @errorCode = -2;

            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1;
            ELSE
                SET @errorCode = -99;

            IF @@trancount = 1
                ROLLBACK;
        END CATCH
        IF (@select = 1)
            BEGIN
                IF (@errorCode > 0)
                    SELECT @errorCode AS Status;
                ELSE
                    SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
END