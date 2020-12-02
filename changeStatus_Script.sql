GO
CREATE OR ALTER PROCEDURE dbo.sp_changeStatus
    @ticket_id INT,
    @status TINYINT,
    --Developer Mode
    @errorCode int = NULL OUTPUT,  
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0
    AS
    BEGIN
        SET NOCOUNT ON;
        --Variablen
            
        BEGIN TRY
        --Wenn Ticket ID existiert führe code aus
        IF (SELECT COUNT(*) FROM dbo.ticket WHERE id = @ticket_id) = 1
        BEGIN
            IF ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.ticket
                SET status = @status
                WHERE id = @ticket_id
            END

            IF @status = 3 AND ERROR_MESSAGE() IS NULL
            BEGIN
                UPDATE dbo.staff
                SET ticket_queue = ticket_queue - 1
                WHERE id = @ticket_id
            END
        END
        ELSE 
            THROW 50001, 'No id found',1;
        END TRY
        BEGIN CATCH
            SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_ticket_statuses%'
                SET @errorCode = -1
            ELSE IF ERROR_MESSAGE() like '%FK_ticket%'
                SET @errorCode = -2
            ELSE
                SET @errorCode = -99
        END CATCH
        IF @select = 1
            SELECT @errorCode AS resultCode, @errorMsg AS errorMessage, @errorLine AS errorLine
    END