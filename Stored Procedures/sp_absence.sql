GO
CREATE OR ALTER PROCEDURE sp_absence
    @agent INT,
    @startDate DATETIME2,
    @endDate DATETIME2 = NULL,
    --Debug
    @errorCode INT = NULL OUTPUT,  -- USER ID is returned if procedures gets executed without error
    @errorLine INT = NULL OUTPUT, -- returns exact line, where the error occured
    @errorMsg VARCHAR(500) = NULL OUTPUT, --returns the error message from the system or a predefined error message
    @select BIT = 0

    AS 
    BEGIN
        SET NOCOUNT ON;
        -- variables
        DECLARE @absence INT = NULL

    BEGIN TRY
        BEGIN TRANSACTION;
        --Add starttime & endtime
        UPDATE dbo.staff
        SET absence_begin = @startDate
        WHERE id = @agent;

        UPDATE dbo.staff
        SET absence_end = @endDate
        WHERE id = @agent;
        --If the endtime is not null, the length of the absence in days will be stored in  @absence. Else it´s set to null.
        IF @endDate IS NOT NULL
            SET @absence = DATEDIFF(DAY,@startDate,@endDate);

        --Setting errorcode to the agent´s is who is absent
        SET @errorCode = @agent;
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
                ROLLBACK;
    END CATCH
    
        IF (@select = 1)
            BEGIN
                IF (@errorCode > 0)
                    SELECT @errorCode AS Agent, @absence AS absence_days;
                ELSE
                    SELECT @errorCode AS errorCode, @errorMsg AS errorMessage, @errorLine AS errorLine;
            END
           
END
GO