GO
CREATE OR ALTER TRIGGER dbo.ticket_statusOnlyup_upd
ON dbo.ticket
FOR update
AS
BEGIN
	SET NOCOUNT ON;

	--TRIGGER fires if the status of a ticket is changed. We only allow to increase the status
	IF UPDATE(status)
	BEGIN
		-- Check if inserted status is bigger than deleted. If not so it rolls back the transaction.
		IF (SELECT COUNT(*)
			FROM inserted i
			INNER JOIN deleted d ON i.id = d.id
			WHERE i.status < d.status) > 0
		BEGIN
			ROLLBACK;
			THROW 50871, 'Ungültiger Statusübergang', 1;
		END
	END

END
GO

