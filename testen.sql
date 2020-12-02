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

-- TODO: Set parameter values here. --?? hä lg domi

EXECUTE dbo.sp_CreateUser
   @username = 'mensur480'
  ,@password = 'Mensur123#'
  ,@firstname = 'Mensur'
  ,@lastname = 'Bukvarevic'
  ,@salutation = 1
  ,@address1 = 'Reslfeldtstraße 10'
  ,@email = 'MBUKVAREVIC@GMAIL.COM'
  ,@phone = '06764604331'
  ,@agent = 1
  ,@select = 1
GO



-- CUSTOMER
EXEC sp_createUser
 'dominikk'
 ,'hallo!!!!'
 ,'Dominik'
 ,'Kainz'
 ,1 
 ,'Weinbergweg 4'
 ,'Weinbergweg 4'
 ,'kainz.domi@gmail.com'
 ,'0 66410 62393'
 ,@agent = 1
 ,@select = 1
GO



--- STAFF 
EXEC sp_CreateUser 
'huso111'
,'hallo!!!!'
,'Dominik'
,'Kainz'
,1 
,'Weinbergweg 4'
,'Weinbergweg 4'
,'kainz.domi@gmail.com'
,'0664102002'
,@agent = 0
,@select = 1






select * from dbo.staff
select * from dbo.customers

exec sp_help 'dbo.customers'


