-- # Actor Rating Difference Analysis -
-- # You are given a dataset of actors and the films they have been involved in, including each film's release date and rating. 
-- # For each actor, calculate the difference between the rating of their most recent film and their average rating across 
-- # all previous films (the average rating excludes the most recent one).

-- # Return a list of actors along with their average lifetime rating, the rating of their most recent film, 
-- # and the difference between the two ratings. Round the difference calculation to 2 decimal places. 
-- # If an actor has only one film, return 0 for the difference and their only film’s rating for both the average and latest rating fields.

with recent_movie as(
    select *,
        max(release_date) over (partition by actor_name) as recent_date
        from actor_rating_shift 
)

select actor_name,round(coalesce(
                            avg(case when release_date < recent_date then film_rating end),
                            max(film_rating)
                        ),2) as avg_rating,
    max(case when release_date=recent_date then film_rating end) as recent_rating,
    round(max(case when release_date=recent_date then film_rating end) - round(coalesce(
                                                        avg(case when release_date < recent_date then film_rating end),
                                                        max(film_rating)
                                                    ),2),2) as diff
    from recent_movie
    group by actor_name
    
