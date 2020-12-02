DECLARE @RC int
DECLARE @username varchar(60)
DECLARE @password varchar(128)
DECLARE @firstname varchar(255)
DECLARE @lastname varchar(255)
DECLARE @salutation tinyint
DECLARE @address1 varchar(255)
DECLARE @address2 varchar(255)
DECLARE @email varchar(255)
DECLARE @phone varchar(255)
DECLARE @agent bit
DECLARE @errorCode int
DECLARE @errorLine int
DECLARE @errorMsg varchar(500)
DECLARE @select bit

-- TODO: Set parameter values here.

EXECUTE dbo.sp_CreateUser
   @username = 'mensur480'
  ,@password = 'Mensur123#'
  ,@firstname = 'Mensur'
  ,@lastname = 'Bukvarevic'
  ,@salutation = 1
  ,@address1 = 'Reslfeldtstraﬂe 10'
  ,@email = 'MBUKVAREVIC@GMAIL.COM'
  ,@phone = '06764604331'
  ,@agent = 1
  ,@select = 1
GO

select * from dbo.staff
select * from dbo.customers

exec sp_help 'dbo.customers'


