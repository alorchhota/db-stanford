/******************** Problem Statement  *************************

You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema: 

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

Your queries will run over a small data set conforming to the schema. View the database. (You can also download the schema and data.) 

1) Find the names of all reviewers who rated Gone with the Wind. 
2) For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
3) Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
4) Find the titles of all movies not reviewed by Chris Jackson. 
5) For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
6) For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
7) List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
8) Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
9) Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
10) Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
11) Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
12) For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 


*/


/******************** Database Preparation  *************************

Use rating.sql

*/

/******************** Query ******************
1) Find the names of all reviewers who rated Gone with the Wind. */

select distinct name
from	(select * from Movie where title="Gone with the Wind") M 
	natural join Rating 
	natural join Reviewer

/******************** Query ******************
2) For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.  */

select name, title, stars
from  	Movie natural join Rating natural join Reviewer
where name = director

/******************** Query ******************
3) Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)  */

select name as name from Reviewer
union
select title as name from Movie
order by name

/******************** Query ******************
4) Find the titles of all movies not reviewed by Chris Jackson.  */

select title
from Movie
where mID not in 
	(select mID
	from (select rID from Reviewer where name = 'Chris Jackson') Chris  natural join Rating)

/******************** Query ******************
5) For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */

/******************** Query ******************
6) For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */

/******************** Query ******************
7) List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.  */

/******************** Query ******************
8) Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)  */

/******************** Query ******************
9) Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)  */

/******************** Query ******************
10) Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)  */

/******************** Query ******************
11) Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)  */

/******************** Query ******************
12) For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 


