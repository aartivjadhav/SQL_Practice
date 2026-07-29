-- # You're given a dataset of searches for properties on Airbnb. For simplicity, each row represents a unique host.
-- # Your task is to find the city whose hosts collectively list the greatest total number of amenities across all their properties.
-- # Treat amenities as a comma-separated list and count each listed entry as-is, even if the same amenities appear multiple times within the same property's amenities, 
-- # count each occurrence (do not deduplicate).
-- # If multiple cities tie for the highest total, return return all of those cities. Output the name of the city/cities.

with amenities_count as(
    select city,count(value) as c,
        dense_rank()over(order by count(value) desc) as rnk
        from airbnb_search_details cross apply string_split(amenities,',')
        group by city 
)

-- select *,dense_rank()over(order by c desc) as rnk from amenities_count
select city from amenities_count where rnk = 1
