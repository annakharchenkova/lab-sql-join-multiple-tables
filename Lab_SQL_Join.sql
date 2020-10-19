/*
# Lab | SQL Join

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals.

### Instructions

1. List number of films per `category`.
2. Display the first and last names, as well as the address, of each staff member.
3. Display the total amount rung up by each staff member in August of 2005.
4. List each film and the number of actors who are listed for that film.
5. Using the tables `payment` and `customer` and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
*/

use sakila;
#1. List number of films per `category`.
select c.category_id, c.name, count(fc.film_id) from category as c
join film_category as fc on c.category_id = fc.category_id
group by c.category_id, c.name;

#2. Display the first and last names, as well as the address, of each staff member.
select s.first_name, s.last_name, a.address, a.district from staff as s
join address as a on a.address_id = s.address_id;

#3. Display the total amount rung up by each staff member in August of 2005.
#rent out, not rung up
select s.first_name, count(r.rental_id) from staff as s
join rental as r 
on r.staff_id = s.staff_id
where r.rental_date >=  20050801 and r.rental_date <= 20050831
group by s.staff_id;

#4. List each film and the number of actors who are listed for that film.
select f.title, count(fa.actor_id) from film as f
join film_actor as fa 
on f.film_id = fa.film_id
group by f.title;

#5. Using the tables `payment` and `customer` and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

select c.customer_id, c.first_name, c.last_name, sum(p.amount) from customer as c
join payment as p
on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name
order by c.last_name asc;


/*
Lab | SQL Joins on multiple tables

In this lab, you will be using the Sakila database of movie rentals.

Instructions

1. Write a query to display for each store its store ID, city, and country.
2. Write a query to display how much business, in dollars, each store brought in.
3. What is the average running time of films by category?
4. Which film categories are longest?
5. Display the most frequently rented movies in descending order.
6. List the top five genres in gross revenue in descending order.
7. Is "Academy Dinosaur" available for rent from Store 1?
*/


use sakila;
#1. Write a query to display for each store its store ID, city, and country.
select s.store_id, ct.city, ctr.country from store as s
join address as a on a.address_id = s.address_id
join city as ct on ct.city_id = a.city_id
join country as ctr on ct.country_id = ctr.country_id;

#2. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) from store as s
join payment as p on p.staff_id = s.manager_staff_id
group by s.store_id; 

#3. What is the average running time of films by category?
select c.name, avg(f.length) from category as c
join film_category as fc on fc.category_id = c.category_id
join film as f on fc.film_id = f.film_id
group by c.name;

#4. Which film categories are longest?
select c.name, round(avg(f.length),0) from category as c
join film_category as fc on fc.category_id = c.category_id
join film as f on fc.film_id = f.film_id
group by c.name
order by avg(f.length) desc;

#5. Display the most frequently rented movies in descending order.
select f.title, count(r.rental_id) as amount_rented from film as f
join inventory as i on i.film_id = f.film_id
join rental as r on r.inventory_id = i.inventory_id
group by f.title
order by count(r.rental_id) desc;

#6. List the top five genres in gross revenue in descending order.
select c.name, sum(p.amount) from category c
join film_category as f on f.category_id = c.category_id
join inventory as i on i.film_id = f.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id
group by c.category_id 
order by sum(p.amount) desc;


#7. Is "Academy Dinosaur" available for rent from Store 1?
select f.title, count(i.inventory_id) from film as f
join inventory as i on f.film_id = i.film_id
where i.store_id = 1 and f.title = "ACADEMY DINOSAUR"
group by f.title 
;

