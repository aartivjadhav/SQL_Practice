-- # Select the most popular client_id based on the number of users who individually have at least 50% of their events from the following list: 
-- # 'video call received', 'video call sent', 'voice call received', 'voice call sent'.

-- calculate 50% of events for individual users
with user_events as(    
select user_id, (cast (count(case when event_type in ('video call received','video call sent', 'voice call received','voice call sent') then event_id end) as float)) /count(event_id) as events_ratio
    from fact_events
    group by user_id)
    
-- find the top client
select top 1 client_id,
        count(distinct f.user_id) as popular_client
        from user_events u join fact_events f on u.user_id=f.user_id where events_ratio>=0.5
    group by client_id
    order by popular_client desc
