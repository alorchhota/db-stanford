/* MySQL 5.5.32 editor */
/* http://sqlfiddle.com/#!2/169fb/22 */

/* Delete the tables if they already exist */
drop table if exists Person;
drop table if exists Frequents;
drop table if exists Eats;
drop table if exists Serves;

/* Create the schema for our tables */
create table Person(name text, age int, gender text);
create table Frequents(name text, pizzeria text);
create table Eats(name text, pizza text);
create table Serves(pizzeria text, pizza text, price double);

/* Populate the tables with our data */
insert into Person values('Amy', 16, 'female');
insert into Person values('Ben', 21, 'male');
insert into Person values('Cal', 33, 'male');
insert into Person values('Dan', 13, 'male');
insert into Person values('Eli', 45, 'male');
insert into Person values('Fay', 21, 'female');
insert into Person values('Gus', 24, 'male');
insert into Person values('Hil', 30, 'female');
insert into Person values('Ian', 18, 'male');

insert into Frequents values('Amy', 'Pizza Hut');
insert into Frequents values('Ben', 'Pizza Hut');
insert into Frequents values('Ben', 'Chicago Pizza');
insert into Frequents values('Cal', 'Straw Hat');
insert into Frequents values('Cal', 'New York Pizza');
insert into Frequents values('Dan', 'Straw Hat');
insert into Frequents values('Dan', 'New York Pizza');
insert into Frequents values('Eli', 'Straw Hat');
insert into Frequents values('Eli', 'Chicago Pizza');
insert into Frequents values('Fay', 'Dominos');
insert into Frequents values('Fay', 'Little Caesars');
insert into Frequents values('Gus', 'Chicago Pizza');
insert into Frequents values('Gus', 'Pizza Hut');
insert into Frequents values('Hil', 'Dominos');
insert into Frequents values('Hil', 'Straw Hat');
insert into Frequents values('Hil', 'Pizza Hut');
insert into Frequents values('Ian', 'New York Pizza');
insert into Frequents values('Ian', 'Straw Hat');
insert into Frequents values('Ian', 'Dominos');

insert into Eats values('Amy', 'pepperoni');
insert into Eats values('Amy', 'mushroom');
insert into Eats values('Ben', 'pepperoni');
insert into Eats values('Ben', 'cheese');
insert into Eats values('Cal', 'supreme');
insert into Eats values('Dan', 'pepperoni');
insert into Eats values('Dan', 'cheese');
insert into Eats values('Dan', 'sausage');
insert into Eats values('Dan', 'supreme');
insert into Eats values('Dan', 'mushroom');
insert into Eats values('Eli', 'supreme');
insert into Eats values('Eli', 'cheese');
insert into Eats values('Fay', 'mushroom');
insert into Eats values('Gus', 'mushroom');
insert into Eats values('Gus', 'supreme');
insert into Eats values('Gus', 'cheese');
insert into Eats values('Hil', 'supreme');
insert into Eats values('Hil', 'cheese');
insert into Eats values('Ian', 'supreme');
insert into Eats values('Ian', 'pepperoni');

insert into Serves values('Pizza Hut', 'pepperoni', 12);
insert into Serves values('Pizza Hut', 'sausage', 12);
insert into Serves values('Pizza Hut', 'cheese', 9);
insert into Serves values('Pizza Hut', 'supreme', 12);
insert into Serves values('Little Caesars', 'pepperoni', 9.75);
insert into Serves values('Little Caesars', 'sausage', 9.5);
insert into Serves values('Little Caesars', 'cheese', 7);
insert into Serves values('Little Caesars', 'mushroom', 9.25);
insert into Serves values('Dominos', 'cheese', 9.75);
insert into Serves values('Dominos', 'mushroom', 11);
insert into Serves values('Straw Hat', 'pepperoni', 8);
insert into Serves values('Straw Hat', 'cheese', 9.25);
insert into Serves values('Straw Hat', 'sausage', 9.75);
insert into Serves values('New York Pizza', 'pepperoni', 8);
insert into Serves values('New York Pizza', 'cheese', 7);
insert into Serves values('New York Pizza', 'supreme', 8.5);
insert into Serves values('Chicago Pizza', 'cheese', 7.75);
insert into Serves values('Chicago Pizza', 'supreme', 8.5);


/* ######################################################################### */
/* ############################### Query Answers ########################### */
/* ######################################################################### */

/* #### Question 1 #### */
/* Find all pizzas eaten by at least one female over the age of 20. */
select pizza from
(select * from Person where age>20 AND gender='female') as f NATURAL JOIN Eats;

/* RA Relational Algebra Syntax

\project_{pizza}(
	( \select_{age>20 and gender='female'} Person)
	\join
	Eats
)
*/


/* #### Question 2 #### */
/* Find the names of all females who eat at least one pizza served by Straw Hat. (Note: The pizza need not be eaten at Straw Hat.)  */

select name from
(select * from Person where gender='female') as f 
NATURAL JOIN 
Eats
NATURAL JOIN
(select * from Serves where pizzeria='Straw Hat') as s

/*
\project_{name}(
	(\select_{gender='female'} Person)
	\join
	Eats
	\join
	(\select_{pizzeria='Straw Hat'} Serves)
)
*/


/* #### Question 3 #### */
/* Find all pizzerias that serve at least one pizza for less than $10 that either Amy or Fay (or both) eat. */

select pizzeria from
(select * from Person where name='Amy' or name='Fay') as p 
NATURAL JOIN 
Eats
NATURAL JOIN
(select * from Serves where price<10) as s


/*

\project_{pizzeria}(
	(\select_{name='Amy' or name='Fay'} Person)
	\join
	Eats
	\join
	(\select_{price<10} Serves)
)

*/



/* #### Question 4 #### */
/* Find all pizzerias that serve at least one pizza for less than $10 that both Amy and Fay eat.  */

select pizzeria from
((select * from Person where name='Amy') as p 
NATURAL JOIN 
Eats
NATURAL JOIN
(select * from Serves where price<10) as s)
where pizzeria in 
(
select pizzeria from
((select * from Person where name='Fay') as p 
NATURAL JOIN 
Eats
NATURAL JOIN
(select * from Serves where price<10) as s)
)

/*
\project_{pizzeria}(
	\select_{name='Amy'} Eats
	\join
	(\select_{price<10} Serves)
)
\intersect
\project_{pizzeria}(
	\select_{name='Fay'} Eats
	\join
	(\select_{price<10} Serves)
)
*/



/* #### Question 5 #### */
/* Find the names of all people who eat at least one pizza served by Dominos but who do not frequent Dominos. */

select DISTINCT name from
(Eats
NATURAL JOIN
(select * from Serves where pizzeria='Dominos') as s)
where name NOT IN
(
select name from
(Eats
NATURAL JOIN
(select * from Frequents where pizzeria='Dominos') as s)
)

/*
\project_{name}(
	Eats
	\join 
	\select_{pizzeria='Dominos'}Serves
)
\diff
\project_{name}(
	Eats
	\join 
	\select_{pizzeria='Dominos'} Frequents
)
*/



/* #### Question 6 #### */
/* Find all pizzas that are eaten only by people younger than 24, or that cost less than $10 everywhere they're served.  */


(select DISTINCT pizza
from (select * from Person where age < 24) as p23
NATURAL JOIN Eats
where pizza NOT IN
(select pizza 
from (select * from Person where age >= 24) as p24
NATURAL JOIN Eats))  UNION
(select DISTINCT pizza from Serves
where pizza IN (select pizza from Serves where price<10)
  AND pizza NOT IN (select pizza from Serves where price>=10) )

/*
(\project_{pizza}( \select_{age<24} Person \join Eats)
\diff
\project_{pizza}(\select_{age>=24} Person \join	Eats))
\union
(\project_{pizza}(\select_{price<10} Serves)
\diff
\project_{pizza}(\select_{price>=10} Serves))
*/

















