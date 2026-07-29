-- # Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase amount and date purchased. 
-- # Do not include returns which are represented by negative purchase values. 
-- # Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month.

-- # A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the current month 
-- # and previous two months. The first two months will not be a true 3-month rolling average since we are not given data from last year.
-- # Assume each month has at least one purchase.

with avg_revenue as(
select FORMAT(created_at, 'yyyy-MM') as months,
        sum(purchase_amt) avg_total_revenue 
    from amazon_purchases where purchase_amt>0
    group by FORMAT(created_at, 'yyyy-MM')
)

select *, 
    avg(avg_total_revenue) over (order by months rows between 2 preceding and current row) as rolling_avg 
    from avg_revenue
