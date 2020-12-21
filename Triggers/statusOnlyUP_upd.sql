GO
CREATE OR ALTER TRIGGER dbo.statusOnlyUP_upd
ON dbo.ticket
FOR update
AS
BEGIN
	SET NOCOUNT ON;

	-- Prüfen: ist es eine relevante Änderung?
	IF UPDATE(status) -- OR UPDATE(spalte2) OR UPDATE(spalte3); liefert beim INSERT immer TRUE
	BEGIN
		PRINT '... ich mach jetzt was ...';
		-- Prüfen: gibt es irgendetwas, das nicht passt?
		IF (SELECT COUNT(*)
			FROM inserted i
			INNER JOIN deleted d ON i.id = d.id
			WHERE i.status < d.status) > 0
		BEGIN
            PRINT '-------------------ALARM--------------------'
			ROLLBACK;
			THROW 50871, 'Ungültiger Statusübergang', 1;
		END
	END

END
GO