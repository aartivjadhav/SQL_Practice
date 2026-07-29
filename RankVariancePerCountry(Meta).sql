-- Compare the total number of comments made by users in each country during December 2019 and January 2020.
-- For each month, rank countries by their total number of comments in descending order. Countries with the same total should share the same rank, and the next rank should increase by one (without skipping numbers).
-- Return the names of the countries whose rank improved from December to January (that is, their rank number became smaller).

-- Tables
-- fb_comments_count
-- fb_active_users


-- select * from fb_active_users;
with month_comments as(
    select country,
        sum(case when CONVERT(DATE, created_at) >= '2019-12-01' and
                    CONVERT(DATE, created_at) < '2020-01-01' then number_of_comments else 0 end) as dec_comments,
        dense_rank() over (order by sum(case when CONVERT(DATE, created_at) >= '2019-12-01' and
                    CONVERT(DATE, created_at) < '2020-01-01' then number_of_comments else 0 end) desc) as dec_rank,
        sum(case when CONVERT(DATE, created_at) >= '2020-01-01' and
                    CONVERT(DATE, created_at) < '2020-02-01' then number_of_comments else 0 end) as jan_comments,
        dense_rank() over (order by sum(case when CONVERT(DATE, created_at) >= '2020-01-01' and
                    CONVERT(DATE, created_at) < '2020-02-01' then number_of_comments else 0 end) desc) as jan_rank
            from fb_active_users u join fb_comments_count c
                on u.user_id = c.user_id
            WHERE c.created_at >= '2019-12-01' AND c.created_at < '2020-02-01'
            group by country
)

select country from month_comments where jan_rank < dec_rank
