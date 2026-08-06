-- # You work as a data analyst for an e-commerce platform. The sales team needs to understand the net revenue performance of Product ID 'PROD-2891' in the US market 
-- # for purchases made during a recent two-week period. The dataset contains purchases and refunds. Refunds link to their original purchase via the original_transaction_id field.
-- # Calculate daily net revenue for April 15-28, 2025. Include completed purchases of PROD-2891 made in the US during that period, and 
-- # any completed refunds linked to those purchases, regardless of when the refund was processed or which country is recorded on the refund row. Show zero for days with no activity. 
-- # Return transaction_date and daily_net_revenue.

WITH total_purchases AS (
    SELECT 
        transaction_id,
        transaction_date,
        amount
    FROM product_sales 
    WHERE product_id = 'PROD-2891' 
        AND country = 'US' 
        AND type = 'purchase'
        AND status = 'completed'
        AND transaction_date BETWEEN '2025-04-15' AND '2025-04-28'
),

refunds AS (
    SELECT 
        r.transaction_date,
        r.amount AS amount
    FROM product_sales r
    JOIN total_purchases p
        ON r.original_transaction_id = p.transaction_id
    WHERE r.type = 'refund'
        AND r.status = 'completed'
),

revenue AS (
    SELECT 
        transaction_date,
        SUM(amount) AS daily_net_revenue
    FROM (
        SELECT transaction_date, amount
        FROM total_purchases
        
        UNION ALL
        
        SELECT transaction_date, amount
        FROM refunds
    ) t
    GROUP BY transaction_date
),

date_range AS (
    SELECT 
        CAST('2025-04-15' AS DATE) AS start_date,
        CAST('2025-04-28' AS DATE) AS end_date
),

dates AS (
    SELECT start_date AS calendar_date, end_date
    FROM date_range

    UNION ALL

    SELECT 
        DATEADD(day,1,calendar_date),
        end_date
    FROM dates
    WHERE calendar_date < end_date
)

SELECT 
    d.calendar_date AS transaction_date,
    COALESCE(r.daily_net_revenue,0) AS daily_net_revenue
FROM dates d
LEFT JOIN revenue r
    ON d.calendar_date = r.transaction_date
ORDER BY d.calendar_date
OPTION (MAXRECURSION 0);
