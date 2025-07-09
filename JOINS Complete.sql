-- JOINS

-- INNER JOIN
-- combine two column in one query
-- one common column - join column
-- only the rows where the value in the join column occurs in both tables
-- SELECT * FROM tableA
-- INNER JOIN tableB
-- ON tableA.employee = tableB.employee


-- SELECT * FROM tableA AS a
-- INNER JOIN tableB AS b
-- ON a.employee = b.employee

-- always need a common column
-- only rows where the refernce column value is in both tables

select * from payment
inner join customer
on payment.customer_id = customer.customer_id

select payment.*, first_name, last_name from payment
inner join customer
on payment.customer_id = customer.customer_id

select payment_id, payment.customer_id, amount, 
first_name, last_name 
from payment
inner join customer
on payment.customer_id = customer.customer_id

select payment_id, A.customer_id, amount, 
first_name, last_name 
from payment A
inner join customer B
on A.customer_id = B.customer_id


-- The airline company wants to understand in which category they sell most tickets
-- How many people choose seats in the category
-- Business
-- Economy
-- Comfort ?
-- HINT: use tables seats, flights & boarding_passes

select S.fare_conditions, count(*) as "Count"
from boarding_passes BP
inner join flights f 
on bp.flight_id = f.flight_id
inner join seats S 
on f.aircraft_code = S.aircraft_code and BP.seat_no = S.seat_no
group by S.fare_conditions
order by 2 desc


--  FULL OUTER JOIN

-- SELECT * FROM tableA
-- FULL OUTER JOIN tableB
-- ON tableA.employee = tableB.employee
select * from boarding_passes b
full outer join tickets t
on b.ticket_no = t.ticket_no


-- Find the tickets that don't have a boarding pass related to it!
select * from boarding_passes b
full outer join tickets t
on b.ticket_no = t.ticket_no
where b.ticket_no is null


-- Count those null
select count(*) from boarding_passes b
full outer join tickets t
on b.ticket_no = t.ticket_no
where b.ticket_no is null


-- any null values in table t
select * from boarding_passes b
full outer join tickets t
on b.ticket_no = t.ticket_no
where t.ticket_no is null


-- LEFT OUTER JOIN
-- all rows that are only in left table will be included but not the rows which are only in right table
select * from aircrafts_data a
left join flights f
on a.aircraft_code = f.aircraft_code

-- Find all the aircrafts that have not been used in any flight
select * from aircrafts_data a
left join flights f
on a.aircraft_code = f.aircraft_code
where flight_id is null

-- or 

select * from aircrafts_data a
left join flights f
on a.aircraft_code = f.aircraft_code
where f.flight_id is null


-- The flight company is trying to find out what their most popular seats are.
-- Try to find out which seat has been chosen most frequently.
--  Make sure all seats are included even if they have never been booked.
select * from boarding_passes
select * from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no

select s.seat_no, count(*) from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
group by s.seat_no
order by 2 desc


-- Are there seats that have never been booked?
select * from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
where bp.seat_no is null

-- Try to find out which line (A, B, C,...) has been chosen most frequently.
select right(s.seat_no, 1), count(s.seat_no)
from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
group by 1
order by 2 desc

-- or 

select right(s.seat_no, 1), count(*)
from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
group by right(s.seat_no, 1)
order by count(*) desc


-- RIGHT OUTER JOIN: joins everything from right table (which is tableB)
 -- SELECT * FROM tableA
 -- RIGHT OUTER JOIN tableB
 -- ON tableA.employee = tableB.employee

select * from aircrafts_data a
right join flights f
on a.aircraft_code = f.aircraft_code


-- Challenge: 
-- The company wants to run a phone call campaing on all customers in Texas (=district)
-- What are the customers (first_name, last_name, phone number, and their district) from Texas?

select first_name, last_name, a.phone, a.district from customer c
left join address a
on c.address_id = a.address_id
where  a.district = 'Texas'

-- Are there any (old) addresses that are not related to any customer?
select a.address_id, address from address a 
left join customer c
on c.address_id = a.address_id
where c.customer_id is null


-- JOINS ON MULTIPLE CONDITIONS
-- two column are used to join tables
-- SELECT * FROM table.A
-- INNER JOIN table.B
-- ON a.first_name = b.first_name
-- AND a.last_name = b.last_name

-- also we can use it to filter the data
-- example
-- -- SELECT * FROM table.A
-- INNER JOIN table.B
-- ON a.first_name = b.first_name
-- AND a.last_name = 'Jones'

-- CHALLENGE:
-- hOW MUCH A SPECIFIC SEAT COSTING?

select * from ticket_flights

select * from boarding_passes

-- Data Type PK (Primary Key): uniquely identifies every column in a table
-- we can identify every unique row by using these primary key
-- PK's purpose is to uniquely identify every row

-- Challenge: 
-- Get the average price (amount) for the different seat_no
select bp.seat_no, avg(t.amount)
from ticket_flights t
inner join boarding_passes bp
on t.flight_id = bp.flight_id
and t.ticket_no = bp.ticket_no
group by bp.seat_no
order by 2 desc

-- round till two decimal places
select bp.seat_no, round(avg(t.amount), 2)
from ticket_flights t
inner join boarding_passes bp
on t.flight_id = bp.flight_id
and t.ticket_no = bp.ticket_no
group by bp.seat_no 
order by 2 desc


-- JOINING MULTIPLE TABLES
-- in INNER JOIN table order doesn't matter, output will always be same
SELECT a.city_id, ci.country_id FROM address a
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id

-- find scheduled departure for each passgener

select t.ticket_no, t.passenger_name, f.scheduled_departure from tickets t
inner join ticket_flights tf
on t.ticket_no = tf.ticket_no
inner join flights f
on tf.flight_id = f.flight_id
order by 2 asc

-- The company wants to customize their campaigns to customers depending on the country they are from.
-- Which customers are from Brazil?
-- Write a query to get first_name, last_name, email and the country from all customers from brazil?

select first_name, last_name, email, co.country
from customer c
inner join address a
on c.address_id = a.address_id
inner join city ci
on a.city_id = ci.city_id
inner join country co
on ci.country_id = co.country_id
where ci.country_id = 15
order by 1 asc


-- Which passenger (passenger_name) has spent most amount in their bookings (total_amount)?

select t.passenger_name, sum(b.total_amount) from tickets t
inner join bookings b
on t.book_ref = b.book_ref
group by 1
order by 2 desc

-- Which fare_conditions has ALEKSANDER IVANOV used the most?

select t.passenger_name, s.fare_conditions, count(*) from tickets t
inner join boarding_passes bp
on t.ticket_no = bp.ticket_no
inner join seats s
on bp.seat_no = s.seat_no
where t.passenger_name = 'ALEKSANDR IVANOV'
group by 1, 2


-- Which title has GEORGE LINTON rented the most often?

select cu.first_name, cu.last_name, f.title, count(*) from customer cu
inner join rental re
on cu.customer_id = cu.customer_id
inner join inventory i
on re.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
where cu.first_name = 'GEORGE' and cu.last_name = 'LINTON'
group by 1,2,3
order by 4 desc



