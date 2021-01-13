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
        PRINT 'BEGIN WORKS'

        --Endzeit nur eintragen wenn sie nicht NULL ist
        UPDATE dbo.staff
        SET absence_end = @endDate
        WHERE id = @agent;
        PRINT 'END WORKS'

        IF @endDate IS NOT NULL
        BEGIN
            Set @absence = DATEDIFF(DAY,@startDate,@endDate)
        END
        ELSE
        BEGIN
            SET @absence = NULL
        END
            SET @errorCode = @agent
        PRINT 'OIS WORKED'
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
                
            IF @@trancount = 3
            BEGIN
                PRINT 'sp_absence_error'
                ROLLBACK
            END
        END CATCH

        IF @select = 1
           SELECT @errorCode AS Agent, @absence AS absence_days, @errorMsg AS errorMessage, @errorLine AS errorLine
END
GO