-- # You have the marketing_campaign table, which records in-app purchases by users. 
-- # Users making their first in-app purchase enter a marketing campaign, where they see call-to-actions for more purchases. 
-- # Find how many users made additional purchases due to the campaign's success.

-- # The campaign starts one day after the first purchase. 
-- # Users with only one or multiple purchases on the first day do not count, nor do users who later buy only 
-- # the same products from their first day.

with first_date as(
    select user_id,min(created_at) as min_date 
    from marketing_campaign group by user_id
),
first_day_products as(
    select m.user_id,
        m.created_at,
        m.product_id
        from marketing_campaign m join first_date f 
    on m.user_id = f.user_id and m.created_at = f.min_date
)

-- select * from first_day_products

select count(distinct m.user_id)
    from first_day_products f join marketing_campaign m
    on f.user_id=m.user_id 
        and f.product_id != m.product_id 
        and f.created_at != m.created_at
