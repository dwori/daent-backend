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


--- STAFF 


EXECUTE dbo.sp_CreateUser
   @username = 'mensur480'
  ,@password = 'Mensur123#'
  ,@firstname = 'Mensur'
  ,@lastname = 'Bukvarevic'
  ,@salutation = 1
  ,@address1 = 'Reslfeldtstraße 10,4451,Garsten,AT'
  ,@email = 'MBUKVAREVIC@GMAIL.COM'
  ,@categories = 'Customer Services'
  ,@phone = '06764604331'
  ,@agent = 1
  ,@select = 1
GO
select username, tc.name from ticket_categories_staff x
join staff s on x.sid = s.id
join ticket_categories tc on x.tcid = tc.id
select * from addresses a
join countries c on a.country = c.iso
GO

EXEC sp_createUser
 'dominikk'
 ,'hallo!!!!'
 ,'Dominik'
 ,'Kainz'
 ,1 
 ,@address1 ='Weinbergweg 4,9400,Wolfsberg,AT'
 ,@email ='kainz.domi@gmail.com'
 ,@categories = 'Technical,Infrastucture Support,Website'
 ,@phone = '0 66410 62393'
 ,@agent = 1
 ,@select = 1
GO
select username, tc.name from ticket_categories_staff x
join staff s on x.sid = s.id
join ticket_categories tc on x.tcid = tc.id
select * from addresses a
join countries c on a.country = c.iso
GO

EXEC sp_createUser
 'lukasss'
 ,'geheim!'
 ,'Lukas'
 ,'Dworacek'
 ,1 
 ,@address1 ='Schererstraße 39b ,8052,Graz,AT'
 ,@email ='lukas.dwori@gmail.com'
 ,@categories = 'Technical,Infrastucture Support,Website'
 ,@phone = '0 66410 6111112393'
 ,@agent = 1
 ,@select = 1
GO
select username, tc.name from ticket_categories_staff x
join staff s on x.sid = s.id
join ticket_categories tc on x.tcid = tc.id
select * from addresses a
join countries c on a.country = c.iso
GO



-- CUSTOMER
EXEC sp_CreateUser 
'customers1'  -- must be unique
,'hallo!!!!'
,'Hansi'
,'Hinterseher'
,1 
,@address1 ='Schererstraße 39b ,8052,Graz,AT'
,@address2 ='Haydengasse 7 ,8020,Graz,AT'
,@email ='lukas11.d2sws11s22so22ri@gmail.com'  -- must be unique
,@phone = '0 66410 6111112393'
,@agent = 0
,@select = 1
GO
select * from customers
select * from customer_addresses
select * from addresses a
GO


EXEC sp_CreateUser 
'customer2'
,'hallo!!!!'
,'Hansi'
,'Hinterseher 2'
,1 
,@address1 ='XY Gasse ,8052,Graz,AT'
,@email ='hallihal2lo@gmail.com'
,@phone = '0 66410 6111112393'
,@agent = 0
,@select = 1
GO
select * from customers
select * from customer_addresses
select * from addresses a
GO



EXEC sp_CreateUser 
'customer3'
,'hallo!!!!'
,'Herbert'
,'Prohaska 12'
,1 
,@address1 ='Beste leben ,8052,Graz,AT'
,@address2 ='net leben ,8052,Graz,AT'
,@email ='hallihal2los@gmail.com'
,@phone = '0 66410 6111112393'
,@agent = 0
,@select = 1
GO
select * from customers
select * from customer_addresses
select * from addresses a
GO




select * from dbo.staff
select * from dbo.customers

exec sp_help 'dbo.customers'


