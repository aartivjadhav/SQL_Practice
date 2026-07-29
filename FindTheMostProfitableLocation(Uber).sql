-- # Find the most profitable location. Write a query that calculates the average signup duration in days and the average transaction amount for each location. 
-- # Then, calculate the ratio of average transaction amount to average duration.
-- # Your output should include the location, average signup duration (in days), average transaction amount, and the ratio. Sort the results by ratio in descending order.

with avg_days_amount as(    
    select location, 
            avg(amt*1.0) as avg_amt,
            avg(datediff(day,signup_start_date,signup_stop_date)*1.0) as avg_durations
        from transactions t join signups s on t.signup_id=s.signup_id
        group by location
)

select *,avg_amt/nullif(avg_durations,0) as ratio 
    from avg_days_amount
    order by ratio desc

