GO
CREATE OR ALTER TRIGGER ticket_priority_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    IF UPDATE(priority)  
        BEGIN 
            UPDATE dbo.ticket
            SET updated_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) 
        END    
END;


