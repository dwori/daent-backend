GO
CREATE OR ALTER TRIGGER dbo.ticket_statusOnlyup_upd
ON dbo.ticket
FOR update
AS
BEGIN
	SET NOCOUNT ON;

	-- Prüfen: ist es eine relevante Änderung?
	IF UPDATE(status)
	BEGIN
		
		-- Check if inserted status is bigger than deleted
		IF (SELECT COUNT(*)
			FROM inserted i
			INNER JOIN deleted d ON i.id = d.id
			WHERE i.status < d.status) > 0
		BEGIN
            --PRINT '-------------------ALARM--------------------'
			ROLLBACK;
			THROW 50871, 'Ungültiger Statusübergang', 1;
		END
	END

END
GO

