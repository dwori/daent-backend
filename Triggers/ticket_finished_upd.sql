GO 
CREATE OR ALTER TRIGGER ticket_finished_upd
ON dbo.ticket
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    --TRIGGER fires if someone tries to change the agent of a ticker. If the status of the ticket is 3 this is not possible anymore.
    IF UPDATE(agent)
        BEGIN
            IF (SELECT status FROM ticket WHERE id IN(SELECT DISTINCT ID FROM Inserted)) = 3
                BEGIN;
                    THROW 50632,'Ticket bereits abgeschlossen',1;
                END
        END
END
GO
