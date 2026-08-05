-- # Given users' session logs, calculate how many hours each user was active in total across all recorded sessions.
-- # Note: The session starts when state=1 and ends when state=0.

with cust_hours as(
    select *,
        (case when state=0 then datediff(minute,lag(timestamp)over(partition by cust_id order by timestamp),timestamp) end) as hour_diff
    from cust_tracking 
)

select cust_id,sum(hour_diff)/60 as active_hours from cust_hours group by cust_id
