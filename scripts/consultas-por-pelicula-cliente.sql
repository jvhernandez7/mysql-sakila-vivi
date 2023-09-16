 use sakila;

-- 1. obtener datos
with datos as (
SELECT
    film_id
    ,title
    ,category.name AS category
    ,concat(first_name, ' ', last_name) customer
    ,rental_date
    FROM inventory
    LEFT JOIN rental USING(inventory_id)
    LEFT JOIN film USING(film_id)
    LEFT JOIN film_category USING(film_id)
    LEFT JOIN category USING(category_id)
    LEFT JOIN customer USING (customer_id)
),
datos_con_fecha as (
    select 
    customer,
    category
    ,year(rental_date) rental_year
    ,month(rental_date) rental_month
    ,count(*) as rental_times
    from datos
    group by 
    customer,
    category,
    rental_year,
    rental_month
),
-- 3. transponer año mes
datos_con_meses_en_colomnas as (
    select
    customer,
    category,
    sum(case when rental_year=2005 and rental_month=5 then rental_times else 0 end) as may2005, 
    sum(case when rental_year=2005 and rental_month=6 then rental_times else 0 end) as jun2005
    from datos_con_fecha
    group by 
    customer,
    category
),
-- 4. calcular diferencias y crecimientos
datos_comparativos as (
    select 
    customer,
    category,
    may2005,
    jun2005,
    (jun2005 - may2005) diffjun2005,
    ((jun2005 - may2005)/may2005) as porcjun2005
    from datos_con_meses_en_colomnas
)
select * from datos_comparativos
limit 10;