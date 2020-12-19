--Nur Statusupdates nach oben erlaubt.
CREATE OR ALTER TRIGGER dbo.ticketStatus_upd
        ON dbo.ticket
        FOR UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;
            IF UPDATE(status)
            BEGIN
                IF (SELECT COUNT(*) 
                    FROM inserted i
                    INNER JOIN deleted d ON i.status = d.status
                    WHERE i.status < d.status) > 0
                BEGIN
                    ROLLBACK;
                    THROW 50088, 'Ungültiger Statusübergang',1;
                END
            END
END
GO

