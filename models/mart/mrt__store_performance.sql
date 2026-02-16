-- models/marts/mart_store_performance.sql

with sales as (

    select *
    from {{ ref('int_sales_enriched') }}

)

select
    order_date,
    store_id,
    store_name,
    store_city,
    store_state,

    count(distinct order_id) as total_orders,
    count(distinct customer_id) as total_customers,

    sum(quantity) as total_units_sold,

    sum(gross_revenue) as gross_revenue,
    sum(net_revenue) as net_revenue,
    sum(discount_amount) as total_discount_given,

    sum(net_revenue) / nullif(count(distinct order_id), 0) as avg_order_value,

    sum(net_revenue) / nullif(count(distinct customer_id), 0) as revenue_per_customer

from sales
group by
    order_date,
    store_id,
    store_name,
    store_city,
    store_state