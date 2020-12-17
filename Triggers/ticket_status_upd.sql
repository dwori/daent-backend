GO
CREATE OR ALTER TRIGGER ticket_status_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    IF UPDATE(status)  
        BEGIN 
            UPDATE dbo.ticket
            SET updated_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status != 3
        END 
    IF UPDATE(status)   
        BEGIN 
            UPDATE dbo.ticket
            SET completed_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status = 3
        END 
    
END;



SELECT * FROM dbo.ticket

UPDATE dbo.ticket
SET status = 3
WHERE id = 3;

exec sp_help 'dbo.ticket'