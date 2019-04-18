USE sakila;

-- 1a, Display first and last names

SELECT 
    first_name, last_name
FROM
    actor;
    
-- 1b, Put first and last names
-- in single column named 'Actor Name'

SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM
    actor;

-- 2a, Find actor named 'Joe'

SELECT 
    *
FROM
    actor
WHERE
    first_name = 'Joe';
    
-- 2b, Find all actors with 'GEN' in last name

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
    
-- 2c, Find all actors with 'LI' in last name

SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%';
    
-- 2d, Display 'country_id' and 'country' for
-- Afghanistan, Bangladesh, and China

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    
-- 3a, Create column named 'description'

alter table actor
add column description blob after last_name;

-- 3b, Delete column named 'description'

alter table actor
drop column description;

-- 4a, List all unique last names
-- and sort by their count

SELECT 
    last_name, COUNT(*) AS count
FROM
    actor
GROUP BY last_name
ORDER BY count DESC;

-- 4b, List all occurences of actors with
-- same last name (that are greater than 1)
	
SELECT 
    last_name, COUNT(*) AS count
FROM
    actor
GROUP BY last_name
HAVING count > 1
ORDER BY count DESC;

-- 4c, Change Groucho Williams to Harpo Williams

UPDATE actor 
SET 
    first_name = 'Harpo'
WHERE
    first_name = 'Groucho'
        AND last_name = 'Williams';
        
-- 4d, Change Harpo Williams back to Groucho

UPDATE actor 
SET 
    first_name = 'Groucho'
WHERE
    first_name = 'Harpo';

-- 5a, Query schema of 'address' table
 
show create table address;

-- 6a, Create join of 'address' and 'staff' tables
-- to display first and last name of staff
-- along with their address 

SELECT 
    first_name, last_name, address
FROM
    staff
        LEFT JOIN
    (address) ON address.address_id = staff.address_id;
    
-- 6b, Create join of 'payment' and 'staff' tables
-- to display first and last name of staff
-- along with their total purchases for Aug. '05 

SELECT 
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS total_purchases
FROM
    staff,
    payment
WHERE
    staff.staff_id = payment.staff_id
        AND payment.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.first_name , staff.last_name
ORDER BY total_purchases DESC;

-- 6c, List each film and the number of actors
-- listed for that film

SELECT 
    film.film_id,
    film.title,
    COUNT(film_actor.film_id) AS total_actors
FROM
    film,
    film_actor
WHERE
    film.film_id = film_actor.film_id
GROUP BY film.film_id , film.title
ORDER BY total_actors DESC;

-- 6d, Find count of copies of the film
-- 'Hunchback Impossible' (film_id 439) in inventory

SELECT 
    COUNT(inventory.film_id) AS total_copies
FROM
    inventory
WHERE
    inventory.film_id = 439;
    
-- 6e, List the total paid, by customer, and list
-- the customers alphabetically

SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_purchases
FROM
    customer,
    payment
WHERE
    customer.customer_id = payment.customer_id
GROUP BY customer.first_name , customer.last_name
ORDER BY customer.last_name ASC;

-- 7a, Display the titles of movies starting
-- with the letters K and Q whose language is English

SELECT 
    title, language_id
FROM
    film
WHERE
    title LIKE 'K%'
        OR title LIKE 'Q%'
        AND language_id = 1;
        
-- 7b, Display all actors who appear in
-- the film Alone Trip

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    EXISTS( SELECT 
            film_actor.film_id
        FROM
            film_actor
        WHERE
            film_actor.actor_id = actor.actor_id
            and film_actor.film_id = 17);

-- 7c, Display names and emails
-- of customers from Canada

SELECT 
    customer.first_name,
    customer.last_name,
    customer.email,
    country.country
FROM
    customer
        JOIN
    address ON address.address_id = customer.address_id
        JOIN
    city ON city.city_id = address.city_id
		JOIN
    country ON country.country_id = city.country_id
		WHERE
	country.country like 'canada';
    
-- 7d, Identify all movies categorized
-- as Family films

SELECT 
    film.title,
    category.name as category
FROM
    film
        JOIN
    film_category ON film_category.film_id = film.film_id
		JOIN
	category on category.category_id = film_category.category_id
		WHERE
	category.name like 'family';
    
-- 7e, Display the most frequently rented movies
-- in descending order

SELECT 
    film.title,
    count(rental.inventory_id) as rental_count
FROM
    film
        JOIN
    inventory ON inventory.film_id = film.film_id
		JOIN
	rental on rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC;

-- 7f, Display how much business, in dollars,
--  each store brought in

SELECT 
    store.store_id,
    sum(payment.amount) as revenue
FROM
    store
        JOIN
    customer ON customer.store_id = store.store_id
		JOIN
	payment on payment.customer_id = customer.customer_id
GROUP BY store.store_id
ORDER BY revenue DESC;

-- 7g, Write a query to display each store
-- by its store ID, city, and country

SELECT 
    store.store_id,
    city.city,
    country.country
FROM
    store
        JOIN
    address ON address.address_id = store.address_id
		JOIN
	city on city.city_id = address.city_id
		JOIN
	country on country.country_id = city.country_id
GROUP BY store.store_id;

-- 7h, List the top five movie genres by revenue
-- in descending order

SELECT
    category.name as genre,
    sum(payment.amount) as revenue
FROM
	category
		JOIN
	film_category on film_category.category_id = category.category_id
		JOIN
	inventory on inventory.film_id = film_category.film_id
		JOIN
	rental ON rental.inventory_id = inventory.inventory_id
		JOIN
    payment on payment.rental_id = rental.rental_id
GROUP BY genre
ORDER BY revenue DESC LIMIT 5;

-- 8a, Create a view from previous query

CREATE VIEW top_5_genres_by_revenue AS
    SELECT 
        category.name AS genre, SUM(payment.amount) AS revenue
    FROM
        category
            JOIN
        film_category ON film_category.category_id = category.category_id
            JOIN
        inventory ON inventory.film_id = film_category.film_id
            JOIN
        rental ON rental.inventory_id = inventory.inventory_id
            JOIN
        payment ON payment.rental_id = rental.rental_id
    GROUP BY genre
    ORDER BY revenue DESC
    LIMIT 5;
		
-- 8B, Display view

SELECT 
    *
FROM
    top_5_genres_by_revenue;

-- 8c, Drop view

DROP VIEW top_5_genres_by_revenue;