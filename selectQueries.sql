
-- customers join select
select 
c.id as customer_id,
username,
passwordhash,
firstname,
lastname,
s.name as salutation,
a.streetname,
a.postalcode,
a.cityname,
a.country,
ca.ship_bill_boolean,
email,
phone,
last_login,
created_at,
failed_logins
from customers c
inner join salutations s on c.salutation = s.id
inner join customer_addresses ca ON c.id = ca.cid
inner join addresses a ON ca.aid = a.id


select * from customer_addresses
select * from addresses a
join countries c on a.country = c.iso

select username, tc.name from ticket_categories_staff x
join staff s on x.sid = s.id
join ticket_categories tc on x.tcid = tc.id




-- select * from staff
select 
st.id as staff_id,
username,
passwordhash,
ticket_queue,
finished_tickets,
firstname,
lastname,
s.name as salutation,
address,
email,
phone,
last_login,
created_at,
failed_logins
from staff st
inner join salutations s on st.salutation = s.id





-- ticket join select
select t.id,
t.subject,
t.ticket_content,
st.firstname + ' ' + st.lastname as Agent,
tc.name as Category,
tp.name as Priority,
ts.name as Status,
customer_number as customer_id,
s.name as salutation,
c.firstname,
c.lastname,
t.created_at
from ticket t
inner join staff st on t.agent = st.id
inner join customers c on t.customer_number = c.id
inner join salutations s on c.salutation = s.id
inner join ticket_categories tc on t.category = tc.id
inner join ticket_priorities tp on t.priority = tp.id
inner join ticket_statuses ts on t.status = ts.id