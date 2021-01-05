GO 
CREATE OR ALTER TRIGGER ticket_finished_upd
ON dbo.ticket
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF UPDATE(agent)
        BEGIN
            IF (SELECT status FROM ticket WHERE id IN(SELECT DISTINCT ID FROM Inserted)) = 3
                BEGIN;
                    THROW 50632,'Ticket bereits abgeschlossen',1;
                    --ROLLBACK; 
                END
        END
END
GO
--DROP TRIGGER IF EXISTS dbo.ticket_finished_upd