 use sakila;

with ventas_por_tienda as (
    select 
        st.store_id,
        concat(a.address, ', ', ci.city) as store,
        ci.city,
        co.country,
        concat(sf.last_name, ' ', sf.first_name ) staff,
        --sf.first_name,
        p.amount,
        year(p.payment_date) year,
        month(p.payment_date) month,
        dayofmonth(p.payment_date) as day
    from store as st
        join address as a using (address_id)
        join city as ci using (city_id)
        join country as co using (country_id)
        join staff as sf using (store_id)
        join payment as p using (staff_id)
       
), ventas_por_tienda_por_ano_mes as (
    select
        store,
        year,   
        month,
        sum(amount) amount
    from ventas_por_tienda    
    group by 
        store,
        year,
        month
),
-- colocar las sumas de los meses en columna
ventas_por_tienda_por_mes as(
select
store,
sum(case when year=2005 and month=5 then amount else 0 end)may2005,
sum(case when year=2005 and month=6 then amount else 0 end)jun2005,
sum(case when year=2005 and month=7 then amount else 0 end)jul2005
from ventas_por_tienda_por_ano_mes
group by store
),
-- calcula las diferencias
ventas_por_tienda_comparativa as(
 select 
 store,
 may2005,  
 jun2005,
 (jun2005 - may2005) as diffjun2005,
 jul2005,
 (jul2005 - jun2005) as diffjul2005
 from ventas_por_tienda_por_mes
)
select *
from ventas_por_tienda_comparativa
limit 5; 

