/*
The average amount of standard paper sold on the first month that any order was placed in the orders table (in terms of quantity).
*/
select date_trunc('month', min(occurred_at)), avg(standard_qty) standard, avg(gloss_qty) gloss, avg(poster_qty) poster, sum(total_amt_usd) total
from orders
where date_trunc('month',occurred_at) =
(select date_trunc('month', min(occurred_at))
from orders);


/*
The average amount of gloss paper sold on the first month that any order was placed in the orders table (in terms of quantity).
*/
select date_trunc('month', min(occurred_at)), avg(standard_qty) standard, avg(gloss_qty) gloss, avg(poster_qty) poster, sum(total_amt_usd) total
from orders
where date_trunc('month',occurred_at) =
(select date_trunc('month', min(occurred_at))
from orders);




/*
The average amount of poster paper sold on the first month that any order was placed in the orders table (in terms of quantity).
*/
select date_trunc('month', min(occurred_at)), avg(standard_qty) standard, avg(gloss_qty) gloss, avg(poster_qty) poster, sum(total_amt_usd) total
from orders
where date_trunc('month',occurred_at) =
(select date_trunc('month', min(occurred_at))
from orders);




/*
The total amount spent on all orders on the first month that any order was placed in the orders table (in terms of usd).
*/

select date_trunc('month', min(occurred_at)), avg(standard_qty) standard, avg(gloss_qty) gloss, avg(poster_qty) poster, sum(total_amt_usd) total
from orders
where date_trunc('month',occurred_at) =
(select date_trunc('month', min(occurred_at))
from orders);






















 /*
Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

select t3.region, t3.rep, t3.total
from
(select region, max(total) max_total
from
  (select r.name region, sr.name rep, sum(o.total_amt_usd) total
  from region r
  join sales_reps sr
  on r.id = sr.region_id
  join accounts a
  on sr.id = a.sales_rep_id
  join orders o 
  on a.id = o.account_id
  group by r.name, sr.name
  order by total desc) t1
group by region) t2
join
(select r.name region, sr.name rep, sum(o.total_amt_usd) total
  from region r
  join sales_reps sr
  on r.id = sr.region_id
  join accounts a
  on sr.id = a.sales_rep_id
  join orders o 
  on a.id = o.account_id
  group by r.name, sr.name
  order by total desc) t3
  on t2.region = t3.region
  and t2.max_total = t3.total;


--OR using a WITH statement

with cte AS (select r.name region, sr.name rep, sum(o.total_amt_usd) total
  from region r
  join sales_reps sr
  on r.id = sr.region_id
  join accounts a
  on sr.id = a.sales_rep_id
  join orders o 
  on a.id = o.account_id
  group by r.name, sr.name
  order by total desc)
select cte.region, cte.rep, cte.total
from
(select region, max(total) max_total
from cte
group by region) t2
join cte
  on t2.region = cte.region
  and t2.max_total = cte.total;


 /*
For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);
