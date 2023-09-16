use sakila;
-- 1 unir los datos
with datos_alquiler as (
SELECT
        film_id
        ,title
        ,category.name AS category
        ,rental.rental_date
        ,year(rental.rental_date) rental_year
        ,month(rental.rental_date) rental_month
        ,dayofmonth(rental.rental_date) rental_day
    FROM inventory
        LEFT JOIN rental USING(inventory_id)
        LEFT JOIN film USING(film_id)
        LEFT JOIN film_category USING(film_id)
        LEFT JOIN category USING(category_id)
),
-- 2. agrupar por año y mes 
datos_alquiler_anno_mes as (
    select 
    title
    ,rental_year
    ,rental_month
    ,count(*) as rental_times
    from datos_alquiler
    group by 
    title
    ,rental_year
    ,rental_month
),
-- 3. pasar filas a columnas
datos_alquiler_por_mes as (
    select 
    title,
    sum(case when rental_year=2005 and rental_month=5 then rental_times else 0 end)may2005,
    sum(case when rental_year=2005 and rental_month=6 then rental_times else 0 end)jun2005
    from datos_alquiler_anno_mes
    group by title
),
-- 4. calcular diferencias y porcentajes de crecimiento
datos_alquiler_corporativo_mes as (
    select 
    title,
    may2005,
    jun2005,
    (jun2005 - may2005) as diffjun2005,
    ((jun2005 - may2005)/may2005) as porcjun2005
    from datos_alquiler_por_mes
)
select * 
from datos_alquiler_corporativo_mes
LIMIT 5;