GO

CREATE OR ALTER TRIGGER staff_absenceSwitch_upd
ON dbo.staff
AFTER UPDATE
AS
BEGIN 
    SET NOCOUNT ON;
    
    --Variables
    DECLARE @absence_begin DATETIME2 
    DECLARE @absence_end DATETIME2
    DECLARE @agent INT 
    DECLARE @t_id INT

    IF UPDATE(absence_begin)
    BEGIN
        SELECT @absence_begin = absence_begin, @absence_end = absence_end, @agent = id
        FROM Inserted 
        WHERE id IN(SELECT DISTINCT ID FROM Inserted);

        --TRIGGER fires if length ob ansence is unknown or longer then 3 days
        IF ((DATEDIFF(DAY,@absence_begin,@absence_end)) > 3) OR ((@absence_end IS NULL) AND (@absence_begin IS NOT NULL))
            BEGIN
                --Variables
                DECLARE @errormsg VARCHAR(500)
                DECLARE @errorcode INT

                --Cursor is used to switch all tickets an agent has.
                DECLARE ticket_cursor CURSOR LOCAL STATIC
                FOR                 
                SELECT id                
                FROM ticket                 
                WHERE agent = @agent AND status <> 3                         
                OPEN ticket_cursor             
                FETCH NEXT FROM ticket_cursor INTO @t_id       
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        --Switch agent for all open tickets of absent agent.
                        EXEC sp_switchAgent @ticket_id = @t_id, @errorCode = @errorcode OUTPUT,@errorMsg = @errormsg OUTPUT
                        IF @errorcode < 0
                            THROW 50935,@errormsg,1;

                        FETCH NEXT FROM ticket_cursor INTO @t_id ;
                    END
                CLOSE ticket_cursor;
                DEALLOCATE ticket_cursor;

                /*
                 * Sets the ticket queue to 99 so it does not look like the queue is full,
                 * but the agent still can not get any new tickets.
                 */
                UPDATE dbo.staff
                SET ticket_queue = 99
                WHERE id = @agent;
                
            END
        /*
         *If the @absence_begin is Set to NULL, what happens if the absence is over,
         * the ticket_queue will be reset to 0. So now the agent can get tickets again.
         */
        IF @absence_begin IS NULL
        BEGIN
            UPDATE dbo.staff
            SET ticket_queue = 0
            WHERE id = @agent
        END
    END  
END