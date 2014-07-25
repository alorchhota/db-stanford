/******************** Problem Statement  *************************

You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema: 

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

Your queries will run over a small data set conforming to the schema. View the database. (You can also download the schema and data.) 

1) Find the titles of all movies directed by Steven Spielberg. 
2) Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
3) Find the titles of all movies that have no ratings. 
4) Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
5) Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
6) For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
7) For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
8) For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
9) Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

*/


/******************** Database Preparation  *************************

Use rating.sql

*/

/******************** Query ******************
1) Find the titles of all movies directed by Steven Spielberg.*/

select title
from Movie
where director = 'Steven Spielberg' 

/******************** Query ******************
2) Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/

/* way-1 */
select distinct year
from Movie 
	natural join 
	(select *
	 from Rating
	 where stars = 4 or stars = 5) R45
order by year asc

/* way-2 */
select year 
from Movie
where mID in
	(select mID 
	from Movie
		natural join 
		(select *
		 from Rating
		 where stars = 4 or stars = 5) R45)	
order by year asc

/******************** Query ******************
3) Find the titles of all movies that have no ratings. */

select title 
from Movie
where mID not in (select distinct mID from Rating)

/******************** Query ******************
4) Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */

select name 
from Reviewer
where rID in (select rID from Rating where ratingDate is null)

/******************** Query ******************
5) Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */

select name, title, stars, ratingDate
from (Rating natural join Movie) natural join Reviewer
order by name, title, stars

/******************** Query ******************
6) For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */

select name, title
from Movie 
	natural join
	(select R1.rID as rID, R1.mID as mID
	from Rating R1, Rating R2
	where 	R1.rID = R2.rID 
		and R1.mID = R2.mID
		and R1.ratingDate < R2.ratingDate
		and R1.stars < R2.stars) G
	natural join 
	Reviewer

/******************** Query ******************
7) For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */

select title, maxstars
from 	Movie
	natural join
	(select mID, max(stars) as maxstars
	from Rating
	group by mID) MaxRating
order by title


/******************** Query ******************
8) For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */

select title, spread
from 	(select mID, abs(max(stars) - min(stars)) as spread
	 from Rating
	 group by mID) ratingSpread
	natural join
	Movie
order by spread desc, title


/******************** Query ******************
9) Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */

select A1.st - A2.st
from
(select avg(avgStars) as st
from
	(select mID, avg(stars) as avgStars 
	from Rating
	group by mID) AvgRating
	natural join
	Movie
where year < 1980) A1, 
(select avg(avgStars) as st
from
	(select mID, avg(stars) as avgStars 
	from Rating
	group by mID) AvgRating
	natural join
	Movie
where year > 1980) A2


