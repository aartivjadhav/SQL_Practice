-- # You have been asked to investigate whether there is a correlation between the average total order value and 
-- # the average time in minutes between placing an order and having it delivered per restaurant.
-- # You have also been told that the column order_total represents the gross order total for each order. 
-- # Therefore, you'll need to calculate the net order total. This is done by adding the tip_amount and subtracting both the discount_amount and refunded_amount from the order_total.
-- # Make sure correlation is rounded to 2 decimals.

with avg_calculations as(
select 
        restaurant_id,
        avg(order_total+tip_amount-discount_amount-refunded_amount) as avg_total_amt,
        avg(datediff(minute,customer_placed_order_datetime,delivered_to_consumer_datetime)) as avg_delivery_time
    from delivery_details
    group by restaurant_id
)


SELECT 
    ROUND(
        (
            COUNT_BIG(*) * SUM(CAST(avg_total_amt AS FLOAT) * avg_delivery_time)
            - SUM(avg_total_amt) * SUM(avg_delivery_time)
        )
        /
        NULLIF(
            SQRT(
                (
                    COUNT_BIG(*) * SUM(CAST(avg_total_amt AS FLOAT) * avg_total_amt)
                    - POWER(SUM(avg_total_amt),2)
                )
                *
                (
                    COUNT_BIG(*) * SUM(CAST(avg_delivery_time AS FLOAT) * avg_delivery_time)
                    - POWER(SUM(avg_delivery_time),2)
                )
            ),
            0
        ),
        2
    ) AS correlation
FROM avg_calculations;

