-- TICKET SYSTEM

-- TICKET CATEGORIES

select * from ticket_categories

-- STAFF / AGENT creation

EXECUTE dbo.sp_CreateUser
   @username = 'mensur480'
  ,@password = 'Mensur123#'
  ,@firstname = 'Mensur'
  ,@lastname = 'Bukvarevic'
  ,@salutation = 1
  ,@address1 = 'Reslfeldtstraße 10,4451,Garsten,AT'
  ,@email = 'MBUKVAREVIC@GMAIL.COM'
  ,@categories = 'Customer Services,Technical,Website,Infrastucture Support'
  ,@phone = '06764604331'
  ,@agent = 1
  ,@select = 1
GO

select * from ticket_categories_staff

select * from staff

select * from addresses

-- password must be long enough
-- email must be unique and contain @ and .
-- username must be unique and longer than 7 characters
-- address must contain at least 3 commas


EXEC sp_createUser
 'dominikk'
 ,'hallo!!!!'
 ,'Dominik'
 ,'Kainz'
 ,1 
 ,@address1 ='Weinbergweg 4,9400,Wolfsberg,AT'
 ,@email ='kainz.domi@gmail.com'
 ,@categories = 'Technical,Infrastucture Support,Website,Customer Services,VoIP'
 ,@phone = '0 66410 62393'
 ,@agent = 1
 ,@select = 1
GO
EXEC sp_createUser
 'dwori10'
 ,'Pa55w.rd!!'
 ,'Lukas'
 ,'Dworacek'
 ,1 
 ,@address1 ='Schererstraße 39b ,8052,Graz,AT'
 ,@email ='lukas.dworacek@gmail.com'
 ,@categories = 'Technical,Infrastucture Support,Website,Billing'
 ,@phone = '0 66410 6111112393'
 ,@agent = 1
 ,@select = 1
GO
EXEC sp_createUser
 'controller'
 ,'Pa555w.rd!!'
 ,'Franz'
 ,'Joseph'
 ,1 
 ,@address1 ='Kaiser Franz Joseph Platz 1,8010,Graz,AT'
 ,@email ='controller@gmail.com'
 ,@categories = 'Billing,VoIP,Customer Services,Server'
 ,@phone = '0 66412212393'
 ,@agent = 1
 ,@select = 1
GO
EXEC sp_createUser
 'lisa12345'
 ,'Pa555tw.rd!!'
 ,'Lisa'
 ,'Zimmerfrau'
 ,2 
 ,@address1 ='Gries Platz 20,8020,Graz,AT'
 ,@email ='zimmerfrau@gmail.com'
 ,@categories = 'Billing,VoIP,Server'
 ,@phone = '0 66412545235'
 ,@agent = 1
 ,@select = 1
GO

select * from ticket_categories_staff

select * from staff

select * from addresses



-- CUSTOMER creation

EXEC sp_createUser
    'customer1'  -- must be unique & must be longer than 7 characters
    ,'Pa55word!'  -- must be longer than 7 characters
    ,'Jamal'
    ,'Mosley'
    ,1 
    ,@address1 ='Koenigstrasse 2,63770,Goldbach,DE'
    ,@address2 ='Lange Strasse 95,85702,Unterschleißheim,DE'
    ,@email ='p6dimaux33@temporary-mail.net'  -- must be unique and contain @ and .
    ,@phone = '089 40 45 24'
    ,@agent = 0
    ,@select = 1
GO
EXEC sp_CreateUser 
    'customer2'
    ,'hallo!!!!'
    ,'Jennifer'
    ,'Schneider'
    ,2 
    ,@address1 ='Luetzowplatz 79,8052,Graz,AT'
    ,@email ='4psolfsz3wb@temporary-mail.net'
    ,@phone = '06569 23 60 43'
    ,@agent = 0
    ,@select = 1
GO

EXEC sp_CreateUser 
    'BMW Steyr'
    ,'1234!!!!'
    ,'BMW Group'
    ,'Werk Steyr'
    ,3 
    ,@address1 ='Hinterbergestraße 2,4400,Steyr,AT'
    ,@address2 ='Anton-neumanstraße 121,4040,Linz,AT'
    ,@email ='info.steyr@bmw.com'
    ,@phone = '+43 07252 8880'
    ,@agent = 0
    ,@select = 1
GO
EXEC sp_CreateUser 
    'greenpeace'
    ,'4321!!!!'
    ,'Greenpeace'
    ,'Greenpeace International'
    ,4 
    ,@address1 ='Wiener Hauptstraße 120/124,1050,Wien,AT'
    ,@address2 ='Münzgrabenstraße 20,8010,Graz,AT'
    ,@email ='peace.info@greenpeace.com'
    ,@phone = '+43 921900 010'
    ,@agent = 0
    ,@select = 1
GO

EXEC sp_CreateUser 
    'therealdonaldtrump'
    ,'12345!!!!'
    ,'Donald'
    ,'Trump'
    ,1 
    ,@address1 ='Mustermanngasse 1,1050,Wien,AT'
    ,@email ='max@mustermann.com'
    ,@phone = '+43 921900 010'
    ,@agent = 0
    ,@select = 1
GO


select * from customers

select * from customer_addresses

select * from addresses



-- LOGIN CUSTOMERS 

EXEC sp_loginUser
    'mensur480'  
    ,'Mensur123#'
    ,@agent = 1
    ,@select = 1
GO

select * from staff

select * from settings

EXEC sp_loginUser
    'customer2'  
    ,'hallo!!!!'
    ,@agent = 0
    ,@select = 1
GO

select * from customers

EXEC sp_loginUser -- 4x
    'customer2'  
    ,'hallo!!!' -- wrong pw
    ,@agent = 0
    ,@select = 1
GO

select * from customers

EXEC sp_unlockUser 2, @select = 1

select * from customers




--- CREATION OF TICKETS

select t.id,
    t.subject,
    t.ticket_content,
    st.firstname + ' ' + st.lastname as Agent,
    tc.name as Category,
    tp.name as Priority,
    ts.name as Status,
    c.username as customer_username,
    t.created_at,
    t.updated_at,
    t.completed_at
    from ticket t
    inner join staff st on t.agent = st.id
    inner join customers c on t.customer_number = c.id
    inner join ticket_categories tc on t.category = tc.id
    inner join ticket_priorities tp on t.priority = tp.id
    inner join ticket_statuses ts on t.status = ts.id
GO

select * from ticket_categories_staff

select * from ticket_categories

select * from staff

EXEC sp_createTicket 'long loading times on website',
'The website is teaking to long when loading on the users browser. compress pictures',
@customer = 2,
@category = 4,
@select = 1;


EXEC sp_createTicket 'Cronjob not working',
'The cronjob is not working is intent, several indexes stopped updating',
@customer = 3,
@category = 5,
@select = 1;

EXEC sp_createTicket 'The bill from 24.10.2020 is missing',
'I cant find the bill from the date i mentioned.',
@customer = 4,
@category = 3,
@select = 1;

EXEC sp_createTicket 'Keyboard broken',
'this problem is urgent, my keyboard is broken I need you to order a new one',
@customer = 1,
@category = 1,
@select = 1;

EXEC sp_createTicket 'The Backup is corrupted',
'I dont know how to fix it but you must have an idea how.',
@customer = 5,
@category = 6,
@select = 1;

EXEC sp_createTicket 'App not responding',
'there is some major bugs in the application where the view is in the settings tab',
@customer = 3,
@category = 4,
@select = 1;


EXEC sp_createTicket 'Problem with Audio',
'Please help me fix this',
@customer = 2,
@category = 7,
@select = 1;

select * from ticket

select * from staff




-- UPDATING TICKETS
-- PRIORITY CHANGE 

SELECT * FROM ticket_priorities

EXEC sp_changePriority 6,3,@select = 1

SELECT * FROM ticket



-- STATUS CHANGE

SELECT * FROM ticket_statuses


-- state 2
EXEC sp_changeStatus 3,2,@select = 1


-- State 1 (wont change)
EXEC sp_changeStatus 3,1,@select = 1


-- State 3
EXEC sp_changeStatus 3,3,@select = 1


SELECT * FROM ticket

SELECT * FROM staff




-- AGENT IS ABSENT


select * from settings

select * from staff

-- longer than 4 days
EXEC sp_absence 4,'20210126 12:30:00','20210131 12:30:00', @select = 1;

select * from staff

select * from ticket
-- open end
EXEC sp_absence 4,'20210106 12:30:00', @select = 1;

select * from staff
-- cancel absence
EXEC sp_absence 4,NULL, NULL, @select = 1;

select * from staff