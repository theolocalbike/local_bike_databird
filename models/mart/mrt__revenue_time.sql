-- models/marts/mart_revenue_time.sql

with sales as (

    select *
    from {{ ref('int_sales_enriched') }}

)

select

    order_date,
    order_year,
    order_month,
    store_name,

    count(distinct order_id) as total_orders,
    count(distinct customer_id) as total_customers,

    sum(quantity) as total_units_sold,
    sum(net_revenue) as net_revenue,
    sum(discount_amount) as total_discount_given,

    sum(net_revenue) / nullif(count(distinct order_id), 0) as avg_order_value

from sales
group by
    order_date,
    order_year,
    order_month,
    store_name