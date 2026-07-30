-- # Write a query that returns a list of the bottom 2% revenue generating restaurants. Return a list of restaurant IDs and their total revenue from when customers placed orders in May 2020.
-- # You can calculate the total revenue by summing the order_total column. And you should calculate the bottom 2% by partitioning the total revenue into evenly distributed buckets.


with revenue_groups as(
select restaurant_id,
        sum(order_total) as total_revenue
    from doordash_delivery
    where format(customer_placed_order_datetime,'yyyy-MM')='2020-05'
    group by restaurant_id
),
buckets as (
    select restaurant_id,total_revenue,
        ntile(50) over (order by total_revenue) as revenue_bucket
    from revenue_groups
)

select restaurant_id,total_revenue from buckets where revenue_bucket=1
