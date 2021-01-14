GO
CREATE OR ALTER TRIGGER ticket_status_upd
ON dbo.ticket
AFTER update
AS
BEGIN
	SET NOCOUNT ON;
    BEGIN TRY
    BEGIN TRANSACTION;
    /*
     * TRIGGER fires if the status of a ticket gets changed.
     * Just logs the timestamp of the changes either into updated_at,
     * if status is changed to 2, or into completed_at , if status is changed to 3.
     */
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
    
    --If the status is changed to 3, the priority automaticall is changed to 0.
    IF UPDATE(status)  
        BEGIN     
            UPDATE dbo.ticket
            SET priority = 0
            WHERE id IN(SELECT DISTINCT ID FROM Inserted) AND status = 3
        END     
    COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END

