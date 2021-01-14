GO
CREATE OR ALTER TRIGGER ticket_priority_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    /*
     *TRIGGER fires if something gets changed at a ticket. 
     *It just logs the timestamp of the changes in the updated_at column of the ticket table.
     */
    IF UPDATE(priority) 
        BEGIN 
            UPDATE dbo.ticket
            SET updated_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND priority <> 0;
        END    
END;
