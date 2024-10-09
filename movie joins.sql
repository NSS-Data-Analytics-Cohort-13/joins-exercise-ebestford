SELECT *
FROM distributors;

SELECT *
FROM rating;

SELECT *
FROM revenue;

SELECT *
FROM specs;

--1)Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT sp.film_title AS film_title, sp.release_year AS release_year, re.worldwide_gross AS worldwide_gross
FROM specs AS sp
INNER JOIN revenue AS re
ON sp.movie_id=re.movie_id
ORDER BY worldwide_gross;
--Semi-Tough, 1977 37187139

--2. What year has the highest average imdb rating?
SELECT sp.release_year, ROUND(AVG(imdb_rating),1) AS avg_imdb_rating
FROM specs AS sp
INNER JOIN rating AS r
ON sp.movie_id=r.movie_id
GROUP BY release_year
ORDER BY avg_imdb_rating DESC;
--1991 7.5

--3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT re.worldwide_gross AS worldwide_gross, dis.company_name AS company_name, sp.mpaa_rating AS mpaa_rating, sp.film_title AS film_title
FROM specs AS sp
INNER JOIN distributors AS dis
ON sp.domestic_distributor_id=dis.distributor_id
INNER JOIN revenue AS re
ON re.movie_id=sp.movie_id
WHERE mpaa_rating ='G' 
ORDER BY worldwide_gross DESC;
--Toy Story 4, Walt Disney

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT dis.distributor_id AS distributor_id, dis.company_name AS company_name, COUNT (movie_id) AS movie_count
FROM distributors AS dis
LEFT JOIN specs AS sp
ON sp.domestic_distributor_id = dis.distributor_id
GROUP BY dis.distributor_id, dis.company_name
ORDER BY movie_count DESC;

--WHERE sp.movie_id IS NOT NULL OR sp.movie_id IS NULL ---could include this in query but not necessary still returns same answer without


--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT dis.company_name AS company_name, ROUND(AVG (film_budget))::MONEY AS avg_film_budget
FROM specs AS sp
INNER JOIN distributors AS dis
ON dis.distributor_id= sp.domestic_distributor_id
INNER JOIN revenue AS re
ON sp.movie_id=re.movie_id
GROUP BY dis.company_name
ORDER BY avg_film_budget DESC
LIMIT 5;
---::MONEY converting to dollars

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT dis.company_name AS distributors, sp.film_title, dis.headquarters AS headquarters, imdb_rating
FROM distributors AS dis
INNER JOIN specs AS sp
ON dis.distributor_id= sp.domestic_distributor_id
INNER JOIN rating AS r
ON sp.movie_id=r.movie_id
WHERE dis.headquarters NOT ILIKE '%CA'
ORDER BY imdb_rating DESC;
--Two movies, highest imdb "Dirty Dancing"


--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	CASE WHEN length_in_min >=0 AND length_in_min <=120 THEN 'Under 2 Hours' 
	ELSE 'Over 2 Hours'
	END AS length_range, 
	AVG(r.imdb_rating) as avg_rating
FROM specs as s
LEFT JOIN rating as r
USING(movie_id)
GROUP BY length_range
ORDER BY avg_rating DESC;
--This is the answer, below is figuring it out


--120 minutes and up
SELECT sp.length_in_min AS length_in_min, AVG(imdb_rating) AS avg_imdb_rating
FROM specs AS sp
LEFT JOIN rating AS r
ON sp.movie_id=r.movie_id 
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




