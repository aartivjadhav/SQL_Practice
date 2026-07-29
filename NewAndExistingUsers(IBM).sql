-- # Calculate the share of new and existing users for each month in the table. Output the month, share of new users, and share of existing users as a ratio.
-- # New users are defined as users who started using services in the current month (there is no usage history in previous months). 
-- # Existing users are users who used services in the current month, and who also used services in any prior month of 2020.
-- # Assume that the dates are all from the year 2020 and that users are contained in user_id column.

with is_new_flag as(
    select user_id, month(time_id) as months,
        case when month(time_id) = min(month(time_id)) over (partition by user_id)
                then 1 else 0 end as is_new
    from fact_events
    group by month(time_id),user_id
)

select months,
        1.0*sum(case when is_new = 0 then 1 else 0 end)/count(is_new) as existing_user,
        1.0*sum(case when is_new = 1 then 1 else 0 end)/count(is_new) as new_user
        -- count(is_new) as total
    from is_new_flag group by months
