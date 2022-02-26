/*
Using Derek's previous video as an example, create another running total. This time, create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.
*/
select standard_amt_usd,
sum(standard_amt_usd) over (order by occurred_at) as running_total
from orders


/*
Creating a Partitioned Running Total Using Window Functions
Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.

*/

select standard_amt_usd, 
date_trunc('year',occurred_at),
sum(standard_amt_usd) over (partition by date_trunc('year',occurred_at) order by occurred_at) as running_total
from orders

/*
Ranking Total Paper Ordered by Account
Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
*/
select id,
account_id,
total,
rank() over (partition by total order by account_id desc) as total_rank
from orders

/*
Now, create and use an alias to shorten the following query (which is different than the one in Derek's previous video) that has multiple window functions. Name the alias account_year_window, which is more descriptive than main_window in the example above.
*/
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER window_alias AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER window_alias AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER window_alias AS count_total_amt_usd,
       AVG(total_amt_usd) OVER window_alias AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER window_alias AS min_total_amt_usd,
       MAX(total_amt_usd) OVER window_alias AS max_total_amt_usd
FROM orders
WINDOW window_alias AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) 


SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
 ) sub

/*
Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.
*/
select account_id,
occurred_at,
standard_qty,
ntile(4) over (partition by account_id order by standard_qty) as standard_quartile
from orders
order by account_id desc;


/*
Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.
*/
select account_id,
occurred_at,
gloss_qty,
ntile(2) over (partition by account_id order by gloss_qty) as gloss_half
from orders
order by account_id desc;
/*
Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
*/
select account_id,
occurred_at,
total_amt_usd,
ntile(100) over (partition by account_id order by total_amt_usd) as total_percentile
from orders
order by account_id desc;
