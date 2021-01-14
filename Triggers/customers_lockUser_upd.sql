GO
CREATE OR ALTER TRIGGER dbo.customers_failedlogins
ON dbo.customers
FOR update
AS
BEGIN
    SET NOCOUNT ON;
    --If there are more than 3 failed logins the account gets locked.
    IF UPDATE(failed_logins)
        IF (SELECT failed_logins from inserted where failed_logins > 3) > 1
        BEGIN
            UPDATE dbo.customers
            SET locked = 1
            WHERE id IN(SELECT DISTINCT ID FROM Inserted);
        END
END
Go
