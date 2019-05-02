USE sakila;

# 1a Display the first and last names of all actors from the table "Actor"

SELECT a.first_name, a.last_name 
FROM actor as a;

# 1b Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT upper(first_name), 
upper(last_name), 
CONCAT(first_name, last_name) as ActorName
FROM actor; 

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM Actor 
WHERE first_name = "Joe";

# 2b. Find all actors whose last name contain the letters `GEN`:

SELECT * 
FROM Actor
WHERE last_name like "%gen%";

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

SELECT * 
FROM actor
WHERE last_name like "%li%"
ORDER BY last_name, first_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` 
#(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER table Actor
ADD description blob; 	

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

ALTER table Actor
DROP column description; 	

# 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name 
FROM actor
GROUP BY last_name;

SELECT count(distinct last_name) as Count from actor;

# 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors

SELECT * 
FROM actor
WHERE last_name IN (
'akroyd', 'allen', 'bailey', 'bening', 'berry', 'bolger', 'brody', 'chase', 'crawford',
'cronyn', 'davis', 'dean', 'dee', 'degeneres', 'dench', 'depp', 'dukakis', 'fawcett', 'garland',
'gooding', 'guiness', 'hackman', 'harris', 'hoffman', 'hopkins', 'hopper', 'jackman', 'johansson', 
'keitel', 'kilmer', 'mcconaughey', 'mckellen', 'mcqueen', 'monroe', 'mostel', 'neeson', 'nolte',
'olivier', 'paltrow', 'peck', 'penn', 'silverstone', 'streep', 'tandy', 'temple', 'torn', 'tracy',
'wahlberg', 'west', 'williams', 'willis' , 'winslet', 'wood', 'zellweger'
)
ORDER BY last_name;

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`.  
#Write a query to fix the record.

UPDATE actor
SET first_name = replace(first_name, 'GROUCHO', 'HARPO')
WHERE first_name = 'GROUCHO';

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, 
# if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET first_name = replace(first_name, 'HARPO', 'GROUCHO')
WHERE first_name = 'HARPO';

# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE table Address;

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
# Use the tables `staff` and `address`:

SELECT s.first_name, s.last_name, a.address 
FROM staff s
JOIN address a on a.address_id = s.staff_id;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
# Use tables `staff` and `payment`.

SELECT p.amount, p.staff_id, s.first_name, s.last_name 
FROM payment p
JOIN staff s on p.staff_id = s.staff_id
GROUP BY s.first_name;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT * 
FROM film f
INNER JOIN film_actor fa on f.film_id=fa.film_id
GROUP BY actor_id;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT count(i.inventory_id)
FROM inventory i
	JOIN film f ON f.film_id=i.film_id
WHERE f.title = "Hunchback Impossible";

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
#List the customers alphabetically by last name:

SELECT first_name, last_name, sum(amount)
FROM customer c
	INNER JOIN payment p
		ON c.customer_id = p.customer_id
GROUP BY first_name, last_name      
ORDER BY last_name;


# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters `K` and `Q` have also 
#soared in popularity. Use subqueries to display the titles of movies starting with the 
#letters `K` and `Q` whose language is English.

SELECT * 
FROM film f
	INNER JOIN language l 
		ON l.language_id=f.language_id
WHERE name = 'English' and title like 'Q%' or title like 'K%';

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.


SELECT a.first_name, a.last_name 
FROM actor a
	INNER JOIN film_actor fa
		ON a.actor_id = fa.actor_id
	INNER JOIN film f
		ON f.film_id = fa.film_id
WHERE title = 'Alone Trip';


#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT C.first_name, C.last_name, C.email, co.country, ci.city_id
FROM country co
	INNER JOIN city ci 
		ON co.country_id=ci.country_id
	INNER JOIN Address A 
		ON A.city_id=ci.city_id
	INNER JOIN Customer C 
		ON c.address_id=A.address_id
WHERE country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

SELECT c.name, f.title
FROM category c
	INNER JOIN film_category fc 
		ON c.category_id=fc.category_id
	INNER JOIN film f 
    ON f.film_id=fc.film_id
WHERE name = 'Family';

#7e. Display the most frequently rented movies in descending order.


SELECT f.film_id, f.title, sum(p.amount)
FROM film f
	JOIN rental r 
		ON f.film_id=r.rental_id
	JOIN payment p 
		ON p.rental_id=r.rental_id
	GROUP BY f.title, f.film_id
	ORDER BY p.amount desc;

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT c.customer_id, sum(p.amount), s.store_id
FROM store s 
	JOIN customer c 
		ON s.store_id = c.store_id
    JOIN payment p    
		ON c.customer_id = p.customer_id
	GROUP BY p.amount; 


#7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, c.city, co.country
FROM store s
	JOIN address a 
		ON s.address_id=a.address_id
	JOIN city c 
		ON c.city_id=a.city_id
	JOIN country co 
		ON co.country_id=c.country_id;


#7h. List the top five genres in gross revenue in descending order. (**Hint**: 
#you may need to use the following tables: category, film_category, inventory, payment, and rental.)

CREATE temporary table TopFive
SELECT c.name, sum(amount) 
FROM film_category as fc
	JOIN category c 
		ON fc.category_id=c.category_id
	JOIN inventory i 
		ON i.film_id=fc.film_id
	JOIN rental r 
		ON r.inventory_id=i.inventory_id
	JOIN payment p 
		ON p.rental_id=r.rental_id
	GROUP BY c.name
	ORDER BY Sum(amount) desc;


#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
#by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you 
#can substitute another query to create a view.

CREATE View TopGenre as 
SELECT * 
FROM TopFive

#8b. How would you display the view that you created in 8a?


#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. 

DROP #TopFive