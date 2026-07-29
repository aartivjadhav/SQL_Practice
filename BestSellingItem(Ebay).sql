-- Find the best-selling item for each month (no need to separate months by year). The best-selling item is determined by the highest total sales amount, 
-- calculated as: total_paid = unitprice * quantity. A negative quantity indicates a return or cancellation (the invoice number begins with 'C'. To calculate sales, ignore returns and cancellations. 
-- Output the month, description of the item, and the total amount paid.

with product_ranking as (
    select month(invoicedate) as months,description, sum(quantity*unitprice) as total_paid,
        rank() over(partition by month(invoicedate) order by sum(quantity*unitprice) desc) as prod_rank
        from online_retail
        where invoiceno not like 'C%'
        group by month(invoicedate),description
)

select months,description,total_paid from product_ranking where prod_rank=1
