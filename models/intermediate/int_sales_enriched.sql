-- models/intermediate/int_sales_enriched.sql

with order_items as (

    select *
    from {{ ref('stg_sales_database__order_items') }}

),

orders as (

    select *
    from {{ ref('stg_sales_database__orders') }}

),

customers as (

    select *
    from {{ ref('stg_sales_database__customers') }}

),

stores as (

    select *
    from {{ ref('stg_sales_database__stores') }}

),

staffs as (

    select *
    from {{ ref('stg_sales_database__staffs') }}

),

products as (

    select *
    from {{ ref('stg_production_database__products') }}

),

categories as (

    select *
    from {{ ref('stg_production_database__categories') }}

),

brands as (

    select *
    from {{ ref('stg_production_database__brands') }}

)

select

    -- Grain
    oi.order_id,
    oi.item_id,

    -- Dates
    o.order_date,
    o.shipped_date,
    extract(year from o.order_date) as order_year,
    extract(month from o.order_date) as order_month,
    extract(day from o.order_date) as order_day,

    -- Customer
    o.customer_id,
    c.city as customer_city,
    c.state as customer_state,

    -- Store
    o.store_id,
    s.store_name,
    s.city as store_city,
    s.state as store_state,

    -- Staff
    o.staff_id,
    st.first_name as staff_first_name,
    st.last_name as staff_last_name,
    st.manager_id,

    -- Product
    oi.product_id,
    p.product_name,
    p.model_year,
    p.category_id,
    cat.category_name,
    p.brand_id,
    b.brand_name,

    -- Pricing
    oi.quantity,
    oi.list_price,
    oi.discount,

    -- Calculations
    (oi.quantity * oi.list_price) as gross_revenue,
    (oi.quantity * oi.list_price * (1 - oi.discount)) as net_revenue,
    (oi.quantity * oi.list_price * oi.discount) as discount_amount

from order_items oi

left join orders o
    on oi.order_id = o.order_id

left join customers c
    on o.customer_id = c.customer_id

left join stores s
    on o.store_id = s.store_id

left join staffs st
    on o.staff_id = st.staff_id

left join products p
    on oi.product_id = p.product_id

left join categories cat
    on p.category_id = cat.category_id

left join brands b
    on p.brand_id = b.brand_id