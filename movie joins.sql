SELECT *
FROM distributors;

SELECT *
FROM rating;

SELECT *
FROM revenue;

SELECT *
FROM specs;

--1)Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT film_title, release_year, worldwide_gross
FROM specs
INNER JOIN revenue
USING (movie_id)
ORDER BY worldwide_gross;

--2. What year has the highest average imdb rating?
SELECT release_year, AVG(imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY release_year
ORDER BY avg_imdb_rating DESC;


--3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT re.worldwide_gross AS worldwide_gross, dis.company_name AS company_name, sp.mpaa_rating AS mpaa_rating, sp.film_title AS film_title
FROM specs AS sp
FULL JOIN distributors AS dis
ON sp.release_year=dis.year_founded
FULL JOIN revenue AS re
ON re.movie_id=sp.movie_id
WHERE mpaa_rating ='G' AND dis.company_name IS NOT NULL
ORDER BY worldwide_gross DESC;
--The Lion King, Fox Searchlight Picture and Dreamworks

SELECT dis.company_name AS company_name, sp.film_title AS film_title
FROM specs AS sp
LEFT JOIN distributors AS dis
ON sp.release_year = dis.year_founded
WHERE film_title = 'Toy Story 4'
--Toy story came up as highest gross movie, but once I added distributors table, and asked for no null values, the title was dropped and replaced with lion king

SELECT sp.film_title AS film_title, sp.mpaa_rating AS mpaa_rating, re.worldwide_gross AS worldwide_gross
FROM specs AS sp
FULL JOIN revenue AS re
USING (movie_id)
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC;
--Answer with toy story 
--Gives me a different answer but doesn't include company name..

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT dis.distributor_id AS distributor_id, dis.company_name AS company_name, COUNT (film_title)
FROM specs AS sp
FULL JOIN distributors AS dis
ON sp.domestic_distributor_id = dis.distributor_id
GROUP BY dis.distributor_id, dis.company_name;

--5. Write a query that returns the five distributors with the highest average movie budget.
SELECT dis.company_name AS company_name, ROUND(AVG (film_budget),0) AS avg_film_budget
FROM distributors AS dis
FULL JOIN revenue AS re
ON dis.distributor_id= re.movie_id
GROUP BY dis.company_name
ORDER BY avg_film_budget DESC
LIMIT 5;

--null values coming up for budget, wondering where the disconnect is

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT dis.company_name AS distributors, COUNT(sp.film_title) AS movie_count, dis.headquarters AS headquarters
FROM distributors AS dis
FULL JOIN specs AS sp
ON dis.distributor_id= sp.domestic_distributor_id
WHERE dis.headquarters NOT ILIKE '%CA'
GROUP by dis.company_name, dis.headquarters
--2 companies,

SELECT COUNT (film_title) AS movie_count, imdb_rating, headquarters
FROM distributors
FULL JOIN specs
ON distributor_id= domestic_distributor_id
WHERE headquarters <> 'CA'
SELECT COUNT(film_title) AS movie_count, MAX(imdb_rating) AS highest_imdb_rating
FULL JOIN specs
FROM rating
INNER JOIN specs
GROUP BY movie_count
USING (movie_id)
ORDER BY imbd_rating DESC


--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

--120 minutes and up
SELECT length_in_min, AVG(imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
USING (movie_id)
WHERE length_in_min >= 120
GROUP BY length_in_min
ORDER BY avg_imdb_rating DESC;
--8.9

--120 minutes and below
SELECT length_in_min, AVG(imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
USING (movie_id)
WHERE length_in_min <= 120
GROUP BY length_in_min
ORDER BY avg_imdb_rating DESC;
--7.6





