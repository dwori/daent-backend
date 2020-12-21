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
 'dwori10'
 ,'Pa55w.rd!!'
 ,'Lukas'
 ,'Dworacek'
 ,1 
 ,@address1 ='Schererstraße 39b ,8052,Graz,AT'
 ,@email ='lukas.dworacek@gmail.com'
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

GO
EXEC sp_loginUser
'dwori10'  -- must be unique
,'Pa55w.rd!!'
,@agent = 1
,@select = 1
GO



-- CUSTOMER
EXEC sp_createUser
'mensi4801'  -- must be unique
,'hallo!!!!'
,'Mensur'
,'Bukvarevic'
,1 
,@address1 ='Ghegagasse 15/29,8020,Graz,AT'
,@address2 ='Reslfeldtstra�e 10,4451,Garsten,AT'
,@email ='mbukvarevic123@gmail.com'  -- must be unique
,@phone = '+436764604331'
,@agent = 0
,@select = 1
GO

select * from customers
SELECT * from staff
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
'Mensur'
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

GO
EXEC sp_createUser 
'Joergl'  -- must be unique
,'hallo!!!!'
,'Joerg'
,'Haider'
,1 
,@address1 ='Hans-Sachs-Straße 23,9020,Klagenfurt,AT'
,@address2 ='Haydengasse 7,8020,Graz,AT'
,@email ='jörg.haider@gmail.com'  -- must be unique
,@phone = '0 66410 6111112393'
,@agent = 0
,@select = 1
GO

GO
EXEC sp_loginUser
'Joergl'  -- must be unique
,'hallo!!!1!'
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


--tickets
SELECT * FROM customers
SELECT * FROM ticket_categories


SELECT s.username,s.ticket_queue,s.finished_tickets,c.name From staff s
INNER JOIN ticket_categories_staff t ON s.id = t.sid
INNER JOIN ticket_categories c ON t.tcid = c.id
SELECT * FROM ticket


EXEC sp_createTicket 'Trigger Problem','Der Status Update trigger funktioniert nicht so wie er soll!',1,@category = 1;

SELECT * from dbo.ticket
--Auf Status 2 ändern
EXEC sp_changeStatus 3,3,@select = 1
SELECT * FROM ticket WHERE id = 6

--Auf Status 1 zurückändern
EXEC sp_changeStatus 6,1,@select = 1
SELECT * FROM ticket WHERE id = 6

--Auf Status 3 ändern
EXEC sp_changeStatus 4,3,@select = 1
SELECT * FROM ticket WHERE id = 4
SELECT * FROM ticket_statuses


SELECT t.subject,c.username,s.username,ts.name
FROM ticket t
INNER JOIN staff s ON t.agent = s.id
INNER JOIN customers c ON t.customer_number = c.id
INNER JOIN ticket_statuses ts ON t.status = ts.id

SELECT t.id, t.subject, s.username AS agent, t.status, t.updated_at, t.completed_at FROM ticket t
INNER JOIN staff s ON t.agent = s.id
WHERE t.status < 3;
SELECT id,username, ticket_queue FROM staff;

SELECT * FROM ticket WHERE status > 2
SELECT * FROM staff

--Change priority

SELECT * FROM ticket

--Ändern der Priorität auf 2
EXEC sp_changePriority 3,3,@select = 1

SELECT * FROM ticket where id = 3