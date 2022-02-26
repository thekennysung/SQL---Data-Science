/*
Try pulling all the data from the accounts table, and all the data from the orders table.
*/

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/*
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/

select orders.standard_qty, orders.gloss_qty, orders.poster_qty, 
accounts.website, accounts.primary_poc 
from accounts join orders
on accounts.id = orders.account_id;

/*
Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.


*/
select a.name, we.occurred_at, a.primary_poc, we.channel
from accounts as a
join web_events as we
on a.id = we.account_id
where a.name = 'Walmart';

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
select r.name, sr.name, a.name
from accounts as a
join sales_reps as sr
on a.sales_rep_id = sr.id
join region as r
on sr.region_id = r.id
order by a.name;

/*
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for the Midwest region. Your final table should include three columns: the region name, 
the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
select r.name, sr.name, a.name
from region r
join sales_reps sr
on r.id = sr.region_id
join accounts a
on sr.id = a.sales_rep_id
where r.name = 'Midwest'
order by a.name;

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/
select r.name, sr.name, a.name
from region r
join sales_reps sr
on r.id = sr.region_id
join accounts a
on sr.id = a.sales_rep_id
where r.name = 'Midwest'
and sr.name like 'S%'
order by a.name;
/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/
select r.name, sr.name, a.name
from region r
join sales_reps sr
on r.id = sr.region_id
join accounts a
on sr.id = a.sales_rep_id
where r.name = 'Midwest'
and sr.name like '% K%'
order by a.name;
/*
Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100. 
Your final table should have 3 columns: region name, account name, and unit price. 
In order to avoid a division by zero error, 
adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/
select r.name, a.name, o.total_amt_usd/(o.total + 0.01) unitPrice
from orders o
join accounts a 
on o.account_id = a.id
join sales_reps sr
on sr.id = a.sales_rep_id
join region r
on r.id = sr.region_id
where o.standard_qty > 100;
/*
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the smallest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/
select r.name, a.name, o.total_amt_usd/(o.total + 0.01) unitPrice
from orders o
join accounts a 
on o.account_id = a.id
join sales_reps sr
on sr.id = a.sales_rep_id
join region r
on r.id = sr.region_id
where o.standard_qty > 100
and o.poster_qty > 50
order by unitPrice;
/*
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/
select r.name, a.name, o.total_amt_usd/(o.total + 0.01) unitPrice
from orders o
join accounts a 
on o.account_id = a.id
join sales_reps sr
on sr.id = a.sales_rep_id
join region r
on r.id = sr.region_id
where o.standard_qty > 100
and o.poster_qty > 50
order by unitPrice desc;
/*
What are the different channels used by account id 1001? 
Your final table should have only 2 columns: account name and the different channels. 
You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/
select distinct a.name, we.channel
from accounts a
join web_events we 
on we.account_id = a.id
where a.id = 1001;
/*
Find all the orders that occurred in 2015. 
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;

/*
Union
*/
























