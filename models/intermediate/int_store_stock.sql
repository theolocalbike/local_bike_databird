-- models/intermediate/int_store_stock.sql

with stocks as (

    select *
    from {{ ref('stg_local_bike_database__stocks') }}

),

products as (

    select *
    from {{ ref('stg_local_bike_database__products') }}

),

stores as (

    select *
    from {{ ref('stg_local_bike_database__stores') }}

)

select
    CONCAT(st.store_id, '_', st.product_id) AS store_product_id,
    st.store_id,
    s.store_name,
    s.city as store_city,
    s.state as store_state,

    st.product_id,
    p.product_name,
    p.category_id,
    p.brand_id,

    st.quantity as stock_quantity

from stocks st

left join products p
    on st.product_id = p.product_id

left join stores s
    on st.store_id = s.store_id