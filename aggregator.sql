/*
Find the total amount of poster_qty paper ordered in the orders table.

Find the total amount of standard_qty paper ordered in the orders table.

Find the total dollar amount of sales using the total_amt_usd in the orders table.
*/
select sum(poster_qty)totalPoster, 
sum(standard_qty) totalStandard, 
sum(total_amt_usd) totalUSD
from orders;

/*
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.
*/
select sum(standard_amt_usd), 
sum(gloss_amt_usd), 
sum(standard_amt_usd + gloss_amt_usd)
from orders
group by id;

/*
Find the standard_amt_usd per unit of standard_qty paper. 
Your solution should use both an aggregation and a mathematical operator.
*/
select sum(standard_amt_usd)/sum(standard_qty) USDperUnit
from orders;

/*
When was the earliest order ever placed? You only need to return the date.
*/
select max(occurred_at) from orders;

/*
Try performing the same query as in question 1 without using an aggregation function.
*/
select occurred_at 
from orders
order by occurred_at desc;

/*
When did the most recent (latest) web_event occur?
*/
select max(occurred_at) from web_events;

/*
Try to perform the result of the previous query without using an aggregation function.
*/
select occurred_at 
from web_events
order by occurred_at desc;

/*
Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
*/
select avg(standard_qty),
avg(gloss_qty),
avg (poster_qty),
avg(standard_amt_usd),
avg(gloss_amt_usd),
avg(poster_amt_usd)
from orders;
/*
Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
/*
Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
*/

select a.name, max(o.occurred_at)
from accounts a
join orders o
on a.id = o.account_id
group by a.name;

/*
Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
*/

select a.name, max(o.total_amt_usd)
from accounts a
join orders o
on a.id = o.account_id
group by a.name;

/*
Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.
*/

select we.channel, a.name, max(we.occurred_at)
from accounts a
join web_events we
on a.id = we.account_id
group by we.channel, a.name;

/*
Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.
*/

select we.channel, COUNT(we.channel)
from web_events we
group by we.channel;

/*
Who was the primary contact associated with the earliest web_event?

*/

select a.primary_poc, max(we.occurred_at)
from accounts a
join web_events we
on a.id = we.account_id
group by a.primary_poc
LIMIT 1;


--What was the smallest order placed by each account in terms of total usd. 
--Provide only two columns - the account name and the total usd. 
--Order from smallest dollar amounts to largest.

select a.name, min(o.total_amt_usd) mintotal 
from accounts a
join orders o
on a.id = o.account_id
group by a.name
order by mintotal;


--Find the number of sales reps in each region. 
--Your final table should have two columns - the region and the number of sales_reps. 
--Order from fewest reps to most reps.

select r.name, count(sr.name) nSR
from region r
join sales_reps sr
on sr.region_id = r.id
group by r.name
order by nSR;


--Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.
select r.name, we.channel, count(we.channel) occurrances
from region r
join sales_reps sr
on r.id = sr.region_id
join accounts a
on sr.id = a.sales_rep_id
join web_events we
on a.id = we.account_id
group by r.name, we.channel
order by occurrances desc;

--Use DISTINCT to test if there are any accounts associated with more than one region.
select distinct a.id, r.name
from accounts a
join sales_reps sr
on sr.id = a.sales_rep_id
join region r
on sr.region_id = r.id;


--How many accounts have more than 20 orders?
select a.id, sum(o.total)
from accounts a
join orders o
on a.id = o.account_id
group by a.id
having sum(o.total) > 20;

--Which accounts used facebook as a channel to contact customers more than 6 times?
select a.id, we.channel, count(we.channel)
from accounts a
join web_events we
on we.account_id = a.id
group by a.id, we.channel
having we.channel = 'facebook'
and count(we.channel) > 6;



--Find the sales in terms of total dollars for all orders in each year, 
--ordered from greatest to least.
--Do you notice any trends in the yearly sales totals?
select date_trunc('year',occurred_at), sum(total_amt_usd)
from orders
group by 1
order by 2 desc;

/*
Write a query to display for each order, the account ID, total amount of the order, 
and the level of the order - ‘Large’ or ’Small’ - depending on if the order is 
$3000 or more, or smaller than $3000.
*/
select o.*, a.id, o.total_amt_usd, 
case when o.total_amt_usd >= 3000
	then 'Large'
    when o.total_amt_usd < 3000
    then 'Small'
    else 'it equals 3000'
    end as level
from orders o
join accounts a
on a.id = o.account_id;
/*
Write a query to display the number of orders in each of three categories, 
based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/
select id, total, 
case when total >= 2000
then 'At Least 2000'
when total between 1000 and 2000
then 'Between 1000 and 2000'
when total<= 1000
then 'Less than 1000'
end
from orders
order by total;
/*
We would like to understand 3 different levels of customers based on the 
amount associated with their purchases. The top level includes anyone with a 
Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, 
and the level. Order with the top spending customers listed first.
*/
Select a.name, sum(o.total_amt_usd),
case when sum(o.total_amt_usd) > 200000
then 'Top'
when sum(o.total_amt_usd) between 100000 and 200000
then 'Mid'
when sum(o.total_amt_usd) < 100000
then 'Bottom'
else 'Error'
end
from orders o
join accounts a
on o.account_id = a.id
group by a.name
order by sum(o.total_amt_usd) desc;
/*
We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. 
Order with the top spending customers listed first.
*/
Select a.name, sum(o.total_amt_usd),
case when sum(o.total_amt_usd) > 200000
then 'Top'
when sum(o.total_amt_usd) between 100000 and 200000
then 'Mid'
when sum(o.total_amt_usd) < 100000
then 'Bottom'
else 'Error'
end
from orders o
join accounts a
on o.account_id = a.id
where o.occurred_at > '2015-12-31'
group by a.name
order by sum(o.total_amt_usd) desc;
/*
We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. 
Place the top sales people first in your final table.
*/
select sr.name, sum(o.total),
case when sum(o.total) > 200
then 'top'
else 'not'
end
from orders o
join accounts a
on o.account_id = a.id
join sales_reps sr
on a.sales_rep_id = sr.id
group by sr.name
order by sum(o.total);
/*
The previous didn't account for the middle, nor the dollar amount 
associated with the sales. Management decides they want to see these 
characteristics represented as well. 
We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, 
total sales across all orders, and a column with top, middle, 
or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!
*/
select sr.name, sum(o.total), sum(o.total_amt_usd),
case when sum(o.total) > 200 
or sum(total_amt_usd) > 750000
then 'top'
when sum(o.total) > 150
or sum(total_amt_usd) > 500000
then 'middle'
else 'low'
end
from orders o
join accounts a
on o.account_id = a.id
join sales_reps sr
on a.sales_rep_id = sr.id
group by sr.name
order by sum(o.total_amt_usd);