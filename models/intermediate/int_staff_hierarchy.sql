-- models/intermediate/int_staff_hierarchy.sql

with staffs as (

    select *
    from {{ ref('stg_local_bike_database__staffs') }}

)

select

    s.staff_id,
    s.first_name,
    s.last_name,
    s.email,
    s.store_id,
    s.manager_id,

    m.first_name as manager_first_name,
    m.last_name as manager_last_name

from staffs s

left join staffs m
    on s.manager_id = m.staff_id