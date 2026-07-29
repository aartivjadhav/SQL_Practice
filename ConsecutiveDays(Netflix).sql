-- Find all the users who were active for 3 consecutive days or more.

with unique_records as (
    select distinct user_id,record_date from sf_events
),

grp as(
    select *,row_number() over (partition by user_id order by record_date) as rn,
            dateadd(day,-row_number() over (partition by user_id order by record_date),record_date) as grp
            from unique_records
)

select user_id,count(grp) 
    from grp 
    group by user_id,grp 
    having count(grp) >= 3
