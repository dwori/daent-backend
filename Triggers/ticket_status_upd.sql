GO
CREATE OR ALTER TRIGGER ticket_status_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    /*
     * TRIGGER fires if the status of a ticket gets changed.
     * Just logs the timestamp of the changes either into updated_at,
     * if status is changed to 2, or into completed_at , if status is changed to 3.
     */
    DECLARE @status INT
    DECLARE @ticket_id INT
    SELECT @ticket_id = id, @status = status
    FROM inserted


    IF UPDATE(status)  
        BEGIN 
            IF (@status <> 3)
                UPDATE dbo.ticket
                SET updated_at = SYSDATETIME()
                WHERE id = @ticket_id
            ELSE
            BEGIN
                UPDATE dbo.ticket
                SET completed_at = SYSDATETIME()
                WHERE id = @ticket_id

                --If the status is changed to 3, the priority automaticall is changed to 0.
                UPDATE dbo.ticket
                SET priority = 0
                WHERE id = @ticket_id
            END
        END     
END

