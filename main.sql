select movieid from movie
join casting on movieid = movie.id
join actor on actorid = actor.id
where name = 'Julie Andrews'

movieid
171,
1233,
1249


select name from actor 
join casting on actorid = actor.id
where movieid in 
(171,
1233,
1249) and ord =1

name
Julie Andrews
Dudley Moore
Julie Andrews


-- po spojení 
select name from actor 
join casting on actorid = actor.id
where movieid in 
(select movieid from movie
join casting on movieid = movie.id
join actor on actorid = actor.id
where name = 'Julie Andrews'
) and ord =1



select title, name from actor 
    join casting on actorid = actor.id
    join movie on movie.id = movieid
  where movieid in 
      (select movieid from movie
            join casting on movieid = movie.id
            join actor on actorid = actor.id
          where name = 'Julie Andrews'
      ) 
     and ord =1
     
     
     
     
     
     
     select name 
  from actor 
       join casting on actor.id = actorid
       join movie   on movie.id = movieid
  where 
  
SELECT name
 FROM actor 
       JOIN casting ON actor.id = actorid
       JOIN movie   ON movie.id = movieid
  WHERE ord = 1
  GROUP BY name
  HAVING count(*) >= 15
  ORDER BY name 



SELECT title, COUNT(name)
  FROM movie
       JOIN casting ON movie.id = movieid
       JOIN actor ON actor.id = actorid
  WHERE yr = 1978
  GROUP BY title
  ORDER BY COUNT(name) desc, title




SELECT title
       FROM movie
            JOIN casting ON movie.id = movieid
            JOIN actor   ON actor.id = actorid
       WHERE name = 'Art Garfunkel'
       
Result:
title
Catch-22,
Boxing Helena       
       
       
-- # 16. List all the people who have worked with 'Art Garfunkel'.

SELECT name 
  FROM actor 
       JOIN casting ON actor.id = actorid
       JOIN movie   ON movie.id = movieid
  WHERE title IN (
     SELECT title
       FROM movie
            JOIN casting ON movie.id = movieid
            JOIN actor   ON actor.id = actorid
       WHERE name = 'Art Garfunkel')
    AND name != 'Art Garfunkel'
  ORDER BY name
  

-- COALESCE function (to replace null values for any value)
  
SELECT name, COALESCE(mobile, '07986 444 2266')
  FROM teacher
  
SELECT teacher.name, COALESCE(dept.name, 'None')
  FROM teacher 
     LEFT JOIN dept ON teacher.dept=dept.id

-- CASE 

SELECT name, CASE WHEN dept IN (1, 2) THEN 'Sci'
                  ELSE 'Art'
             END
  FROM teacher
  
SELECT teacher.name, CASE WHEN teacher.dept in (1, 2) 
                              THEN 'Sci'
                          WHEN teacher.dept = 3 
                              THEN 'Art'
                              ELSE 'None'
                     END
  FROM teacher LEFT JOIN dept ON dept.id = teacher.dept
  
  
SELECT company, num, COUNT(*)
  FROM route 
  WHERE stop=149 OR stop=53
  GROUP BY company, num
  HAVING COUNT(*) = 2
  
SELECT a.company, a.num, a.stop, b.stop
  FROM route a 
      JOIN route b ON (a.company=b.company AND a.num=b.num)
  WHERE a.stop = 53
  AND b.stop = 149
  
  
SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a 
      JOIN route b     ON (a.company=b.company AND a.num=b.num)
      JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb   ON (b.stop=stopb.id)
  WHERE stopa.name='Craiglockhart'
  AND stopb.name='London Road'
  
SELECT a.company, a.num
  FROM route a
  JOIN route b ON (a.num = b.num)
  WHERE a.stop = 115
  AND b.stop = 137
  GROUP BY a.num, a.company
  
  
  
  
  select DISTINCT bus1.num, bus1.company, bus1.name, bus2.num, bus2.company from
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    -- self join on service id (service id is company and bus number)
    -- this gives me all routs for curret service id
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    -- this gives me starting bus stops with name Craiglockhart
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Craiglockhart')
    -- gives me final route:
    -- list of all the stops for all the buses
    -- which can be reached from Craiglockhart
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus1
 JOIN
  -- next is simillar to query above
  -- this gives me all the stops for all the buses
  -- which can be reached from Lochend
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Lochend')
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus2
    -- join gives me full routes
    -- with transfer stops
    -- that can be reached from both of routes
    ON bus1.name=bus2.name
ORDER BY bus1.num, bus1.company, bus1.name, bus2.num, bus2.company