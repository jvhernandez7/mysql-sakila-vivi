insert into sakila_dwh.fact_rental (
  rental_id,
  date_key,
  count_rental
)
select 
    rental_id,
    TO_DAYS(rental_date) as date_key,
    1 as count_rental
from (
    select 
    rental_id,
    rental_date
    from  sakila.rental
)  rental
;
