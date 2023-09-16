 use sakila;

 select 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address_id,
    a.district,
    ci.city_id,
    ci.city,
    co.country_id,
    co.country
 from customer as c
    inner join address as a
    on c.address_id = a.address_id
    inner join city as ci using(city_id)
    inner join country as co using (country_id)
    inner join store as s using (store_id)
 limit 5;