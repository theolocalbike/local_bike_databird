-- models/intermediate/int_store_stock.sql

with stocks as (

    select *
    from {{ ref('stg_production_database__stocks') }}

),

products as (

    select *
    from {{ ref('stg_production_database__products') }}

),

stores as (

    select *
    from {{ ref('stg_sales_database__stores') }}

)

select

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