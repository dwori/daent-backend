GO
CREATE OR ALTER TRIGGER ticket_status_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
	
    IF UPDATE(status)
        BEGIN 
            PRINT 'jetzt'
            UPDATE dbo.ticket
            SET updated_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted)  
        END 
END;



SELECT * FROM dbo.ticket

UPDATE dbo.ticket
SET status = 2
WHERE id = 2;

exec sp_help 'dbo.ticket'