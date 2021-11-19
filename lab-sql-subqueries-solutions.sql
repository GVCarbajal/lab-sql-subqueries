use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

select count(inventory_id) copies from inventory 
where film_id = (select film_id from film where title = "HUNCHBACK IMPOSSIBLE");


-- List all films whose length is longer than the average of all the films.

select * from film where length > (select avg(length) from film) order by length desc;


-- Use subqueries to display all actors who appear in the film Alone Trip.

select first_name, last_name from actor
where actor_id in 
(select actor_id from film_actor where film_id = 
(select film_id from film where title = "ALONE TRIP"));


/* Sales have been lagging among young families, and you wish to target all family movies 
for a promotion. Identify all movies categorized as family films. */

select title from film
where film_id in
(select film_id from film_category where category_id = (
select category_id from category where name = "Family"));


-- Get name and email from customers from Canada using subqueries. Do the same with joins.

-- SUBQUERRIES
select first_name, last_name, email from customer where address_id in (
select address_id from address where city_id in
(select city_id from city where country_id = ( 
select country_id from country where country = "Canada")));

-- jOINS
select first_name, last_name, email from customer c
join address a on c.address_id = a.address_id
join city m on a.city_id = m.city_id
join country p on m.country_id = p.country_id
where country = "Canada";


-- Which are films starred by the most prolific actor?

select title from film f join film_actor a on f.film_id = a.film_id
where a.actor_id = (select a.actor_id from actor a join film_actor f on a.actor_id = f.actor_id
group by a.actor_id order by count(f.film_id) desc limit 1);


/* Films rented by most profitable customer. You can use the customer table and payment table 
to find the most profitable customer ie the customer that has made the largest sum of payments */

select title from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
where customer_id = (
select customer_id from payment group by customer_id order by sum(amount) desc limit 1);


-- Customers who spent more than the average payments.

select first_name, last_name, email from customer
where customer_id in (select customer_id from payment group by customer_id
having sum(amount) > (select avg(paid) from customer c
join (select customer_id, sum(amount) paid from payment group by customer_id) a
on c.customer_id = a.customer_id));