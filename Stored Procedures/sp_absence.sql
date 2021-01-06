GO
CREATE OR ALTER PROCEDURE sp_absence
    @agent INT,
    @startDate DATETIME2,
    @endDate DATETIME2 = NULL,
    --Debugmode
    @errorCode int = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine int = NULL OUTPUT,
    @errorMsg VARCHAR(500) = NULL OUTPUT,
    @select bit = 0

    AS
    BEGIN
        SET NOCOUNT ON;
        --Variablen
        DECLARE @absence INT


    BEGIN TRY
        BEGIN TRANSACTION;

        --Hinzufügen von Start- und Endzeit 
        UPDATE dbo.staff
        SET absence_begin = @startDate
        WHERE id = @agent;

        --Endzeit nur eintragen wenn sie nicht NULL ist
        IF @endDate IS NOT NULL
        BEGIN
            UPDATE dbo.staff
            SET absence_end = @endDate
            WHERE id = @agent;

            Set @absence = DATEDIFF(SECOND,@endDate,@startDate) --Verbessern
        END
            SET @errorCode = @agent

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SET @errorLine = ERROR_LINE()
            SET @errorMsg = ERROR_MESSAGE()
            IF ERROR_MESSAGE() like '%FK_staff%'
                SET @errorCode = -1
            ELSE IF ERROR_NUMBER() >= 50000
                SET @errorCode = (ERROR_NUMBER() - 50000) * -1
            ELSE
                SET @errorCode = -99
                
            IF @@trancount = 1
                ROLLBACK
        END CATCH

        IF @select = 1
           SELECT @errorCode AS Agent, @absence AS absence, @errorMsg AS errorMessage, @errorLine AS errorLine
END
GO