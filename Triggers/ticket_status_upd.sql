/*
Bei update eines Ticket Status wird in created_at und completed_at ein timestamp eingetragen.
*/



GO
CREATE OR ALTER TRIGGER ticket_status_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    BEGIN TRY
    BEGIN TRANSACTION
    IF UPDATE(status)  
        BEGIN 
            UPDATE dbo.ticket
            SET updated_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status <> 3
        END      
    IF UPDATE(status)  
        BEGIN     
            UPDATE dbo.ticket
            SET completed_at = SYSDATETIME()
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status = 3
        END 
    
    IF UPDATE(status)  
        BEGIN     
            UPDATE dbo.ticket
            SET priority = 0
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status = 3
        END     
    COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK
    END CATCH


END;

/*EXEC sp_changeStatus 

SELECT * FROM dbo.ticket

E


UPDATE dbo.ticket
SET status = 3
WHERE id = 3;

exec sp_help 'dbo.ticket'*/