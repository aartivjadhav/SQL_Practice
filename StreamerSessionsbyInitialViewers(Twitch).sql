-- # Return the number of streamer sessions for each user whose very first session was as a viewer.
-- # Include the user ID and count of streamer sessions for users whose earliest session (by session_start) was a 'viewer' session, regardless of whether they ever had a streamer session later. 
-- # Sort the results by streamer session count in descending order, then by user ID in ascending order.

with row_num as (select *,
    row_number() over (partition by user_id order by session_start asc) as rn
    from twitch_sessions 
    ),
initial_session as(
select * from row_num
    where rn = 1 and session_type = 'viewer'
)

select i.user_id,coalesce(count(t.user_id), 0) as streamer_session_count
    from initial_session i left join twitch_sessions t
    on i.user_id = t.user_id and t.session_type = 'streamer'
    group by i.user_id
    order by streamer_session_count desc, i.user_id asc
