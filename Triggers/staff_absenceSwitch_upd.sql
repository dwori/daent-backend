GO

CREATE OR ALTER TRIGGER staff_absenceSwitch_upd
ON dbo.staff
AFTER UPDATE
AS
BEGIN 
    SET NOCOUNT ON;
  
    
    DECLARE @absence_begin DATETIME2 
    DECLARE @absence_end DATETIME2
    DECLARE @agent INT 
    DECLARE @t_id INT
    IF UPDATE(absence_begin)
        BEGIN
        SELECT @absence_begin = absence_begin, @absence_end = absence_end, @agent = id
        FROM Inserted 
        WHERE id IN(SELECT DISTINCT ID FROM Inserted) 
        IF ((DATEDIFF(DAY,@absence_begin,@absence_end)) > 3) OR ((@absence_end IS NULL) AND (@absence_begin IS NOT NULL))
            BEGIN
                DECLARE @errormsg VARCHAR(500)
                DECLARE @errorcode INT
                DECLARE ticket_cursor CURSOR LOCAL STATIC
                FOR                 
                SELECT id                
                FROM ticket                 
                WHERE agent = @agent AND status <> 3                         
                OPEN ticket_cursor             
                FETCH NEXT FROM ticket_cursor INTO @t_id       
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        PRINT 'Cursor running'
                        EXEC sp_switchAgent @ticket_id = @t_id, @errorCode = @errorcode OUTPUT,@errorMsg = @errormsg OUTPUT
                        IF @errorcode < 0
                            THROW 50935,@errormsg,1;
                        FETCH NEXT FROM ticket_cursor INTO @t_id 
                    END
                CLOSE ticket_cursor
                DEALLOCATE ticket_cursor
                UPDATE dbo.staff
                    SET ticket_queue = 99
                    WHERE id = @agent
                PRINT 'Cursor fertig'
            END
        
        IF @absence_begin IS NULL
            BEGIN
                UPDATE dbo.staff
                SET ticket_queue = 0
                WHERE id = @agent
            END
        END  
END