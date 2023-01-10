

/*What are the main channel for revenue and amount sold?*/
-- to solve this we are going to join orders, accounts and web_events tables and will group by channels and sum of total to get the amount sold--
 SELECT w.channel  AS ad_channel,
 SUM(o.total_amt_usd) AS usd_amt,
 SUM(o.total) AS amount_sold
 FROM orders o
 JOIN accounts a
 ON a.id = o.account_id
 JOIN web_events w
 ON a.id = w.account_id
 GROUP BY 1 
 ORDER BY 2 DESC;
 
 -- Result: Direct is the most popular and the second is facebook so company may think to invest more time on facebook to increase the sales--
 
 
----------------------------------------------------------------------------------------------------------------------------------------------------

 /*Which region has most sales?*/
 -- to solve this we are joining tables orders, accounts, sales_reps, region and summing the sales made by region--   
 SELECT r.name AS region_names,
 SUM(o.total_amt_usd) AS amount_sold_usd,
 SUM(o.total) AS total_qty
 FROM orders o 
 JOIN accounts a
 ON a.id = o.account_id
 JOIN sales_reps s
 ON a.sales_rep_id = s.id
 JOIN region r 
 ON r.id = s.region_id
 GROUP BY 1
 ORDER BY 2 DESC;
 
 --Result: Northeast being the highest sales made --
 
 
----------------------------------------------------------------------------------------------------------------------------------------------------- 


/* who is the highest sales rep?*/
-- we are joining the 3 tables orders, accounts, sales_reps and sum of total sales made--
SELECT s.name AS sale_rep_name, SUM(o.total_amt_usd) AS sales_made_in_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id 
GROUP BY 1
ORDER BY 2 DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

/* Higest sales_rep accoding to the region*/
-- we are going to create two table also know as CTE to help us find the highest sales representative and which region they belong to--
WITH T1 AS(
	SELECT s.name AS sale_rep_name, 
	SUM(o.total_amt_usd) AS sales_made_in_usd,
	r.name AS region_name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id 
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1, 3 
	ORDER BY 2 DESC),
-- The above table gives us the highest sales made, sales representative and also the region--
   T2 AS (SELECT region_name AS region_name 
		  , MAX(sales_made_in_usd) AS sales_made_in_usd
		   FROM T1
		   GROUP BY 1)
-- The above gives us the maximun sales and the sales representative accocited with max sales--
SELECT T1.region_name, T1.sale_rep_name, T2.sales_made_in_usd
FROM T1 
JOIN T2 
ON T2.sales_made_in_usd = T1.sales_made_in_usd AND T1.region_name = T2.region_name
-- above table join the table T1 and T2 on the region and sales representative from the previous table--


------------------------------------------------------------------------------------------------------------------------------------------------


/*Which account spent the most on paper and what channel they use)*/
WITH T1 AS(
	SELECT a.name AS customer_name, SUM(o.total_amt_usd) AS money_spent,
	W.channel
	FROM orders o
	JOIN accounts a
	ON o.account_id = a.id
	JOIN web_events w
	ON a.id = w.account_id
	GROUP BY 1, 3
	ORDER BY 2 DESC),

   T2 AS (SELECT channel AS channel , MAX(money_spent) AS money_spent
    FROM T1
    GROUP BY 1)
SELECT T2.channel, T1.customer_name, T2.money_spent
FROM T1
JOIN T2
ON T1.channel = T2.channel AND T1.money_spent = T2.money_spent


---------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Which year they have most sales*/

SELECT DATE_PART('years', o.occurred_at) AS years, SUM(total_amt_usd) AS amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1
ORDER BY 1 

-- Sales on 2014, 2015 and 2016 looks fine let check what is happening in 2013 and 2017

SELECT DATE_PART('years', o.occurred_at) AS years,
DATE_PART('months', o.occurred_at) AS months, SUM(total_amt_usd) AS amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN web_events w
ON a.id = w.account_id
WHERE DATE_PART('years', o.occurred_at) IN (2013 , 2017)
GROUP BY 1,2
ORDER BY 1
-- the reason of less sales is because we have limited data of 2013 and 2017--

---------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Which month has the largest sales and the amount*/

SELECT DATE_PART('months', o.occurred_at) AS months, 
SUM(o.total_amt_usd) AS amt_usd,
SUM(o.total) AS amount
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1
ORDER BY 2 DESC

-- DECEMBER is highst months of sales--
-- let see the most sales made on a day in december
WITH T1 AS (SELECT DATE_PART('day', occurred_at) AS days, DATE_PART('months', occurred_at) AS months, SUM(total_amt_usd) AS amt_usd
			   FROM orders 
			   GROUP BY 1,2
			   ORDER BY 3 DESC)
SELECT  days, amt_usd
FROM T1
WHERE months = 12
ORDER BY 2 DESC


/* which paper has great revenue papers?*/
SELECT SUM(gloss_amt_usd) AS gloss_usd, 
SUM(standard_amt_usd) AS standard_usd, 
SUM(poster_amt_usd) AS poster_usd
FROM orders;

/* which paper has most sold paper?*/
SELECT SUM(gloss_qty) AS gloss,
SUM(standard_qty) AS standard 
, SUM(poster_qty) AS poster
FROM orders;

/* Calcualte the retention ratio of sales person and also the customer*/

SELECT COUNT(s.id) as sales_id
FROM sales_reps s
JOIN accounts a
ON sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
WHERE DATE_PART('year', o.occurred_at) = 2014


SELECT a.id, a.name 
FROM sales_reps s
JOIN accounts a
ON sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
WHERE DATE_PART('year', o.occurred_at) = 2016
GROUP BY 2, 1

SELECT a.id, a.name 
FROM sales_reps s
JOIN accounts a
ON sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
WHERE DATE_PART('year', o.occurred_at) = 2015
GROUP BY 2, 1






