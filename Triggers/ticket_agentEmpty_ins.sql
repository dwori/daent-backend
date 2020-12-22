--Überprüft ob ein Agent dem ticket zugewiesen wordenist. Ist dies nicht der Fall, sind
--alle Agenten voll ausgelastet und wurden dehalb nicht hinzugefügt. Somit wird das ticket
GO
CREATE OR ALTER TRIGGER dbo.ticket_agentEmpty_ins
ON dbo.ticket
FOR Insert
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM inserted where agent IS NULL) > 0
        ROLLBACK TRANSACTION;
        THROW 50971, 'No agents available! All our agents ques are full!', 1;
END
Go

--DROP TRIGGER IF EXISTS dbo.ticket_agentEmpty_ins