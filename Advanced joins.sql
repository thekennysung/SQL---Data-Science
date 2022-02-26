/*
Say you're an analyst at Parch & Posey and you want to see:

each account who has a sales rep and each sales rep that has an account 
(all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account 
(some of the columns in these returned rows will be empty)
This type of question is rare, but FULL OUTER JOIN is perfect for it. In the following SQL Explorer, 
write a query with FULL OUTER JOIN to fit the above described Parch & Posey scenario 
(selecting all of the columns in both of the relevant tables, accounts and sales_reps) 
then answer the subsequent multiple choice quiz.
*/

select * 
from accounts a
full outer join sales_reps sr
on a.sales_rep_id = sr.id;

/*
Inequality JOINs
The query in Derek's video was pretty long. Let's now use a shorter query to showcase the power of joining with comparison operators.

Inequality operators (a.k.a. comparison operators) don't only need to be date times or numbers, they also work on strings! You'll see how this works by completing the following quiz, which will also reinforce the concept of joining with comparison operators.

In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:

accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), and the sales representative's name (e.g. Samuel Racine). Then answer the subsequent multiple choice question.

*/
select a.name as company,
a.primary_poc as point_of_contact,
sr.name assales_rep_name,
from accounts a
left join sales_reps sr
on a.sales_rep_id = sr.id
and a.primary_poc < sr.name;

/*
Self JOINs
One of the most common use cases for self JOINs is in cases where two events occurred, one after another. As you may have noticed in the previous video, using inequalities in conjunction with self JOINs is common.
Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the same interval analysis except for the web_events table. Also:
change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
add a column for the channel variable in both instances of the table in your query
*/
SELECT we1.id AS we1_id,
       we1.account_id AS we1_account_id,
       we1.channel AS we1_channel,
       we1.occurred_at AS we1_occurred_at,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.channel AS we2_channel,
       we2.occurred_at AS we2_occurred_at
  FROM web_events we1
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we2.occurred_at > we1.occurred_at
  AND we2.occurred_at <= we1.occurred_at + INTERVAL '1 days'
ORDER BY we1.account_id, we1.occurred_at;

/*
Pretreating Tables before doing a UNION
Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney. Inspect the results then answer the subsequent quiz.
*/
select * 
from accounts
where name = 'Walmart'
union all
select * 
from accounts
where name = 'Disney';

/*
Performing Operations on a Combined Dataset
Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and name it double_accounts. 
Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name.
*/
with double_accounts as (
  select * from accounts
  union all
  select * from accounts)
select name,
count(*)
from double_accounts
group by name;


/*
Expert Tip
If you’d like to understand this a little better, you can do some extra research on cartesian products. It’s also worth noting that the FULL JOIN and COUNT above actually runs pretty fast—it’s the COUNT(DISTINCT) that takes forever.
*/

select coalesce(orders.date, web_events.date) as date,
	orders.active_sales_reps,
    orders.orders,
    web_events.web_visits
from(
select date_trunc('day', o.occurred_at) as date,
	count(a.sales_rep_id) as active_sales_reps,
    count(o.id) as orders
  from accounts a
  join orders o
   on o.account_id = a.id
group by 1
) orders

full join

(
select date_trunc('day', we.occurred_at) as date,
	count(we.id) as web_visits
 from web_events we
group by 1
) web_events

on web_events.date = orders.date
order by 1 desc;