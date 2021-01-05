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
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND priority <> 0
        END    
END;

--SELECT * FROM dbo.ticket
--EXEC dbo.sp_changePriority 3,1