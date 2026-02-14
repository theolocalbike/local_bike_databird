-- models/marts/mart_customer_metrics.sql

with sales as (

    select *
    from {{ ref('int_sales_enriched') }}

)

select

    customer_id,
    customer_city,
    customer_state,

    min(order_date) as first_purchase_date,
    max(order_date) as last_purchase_date,

    count(distinct order_id) as total_orders,
    sum(quantity) as total_units,

    sum(net_revenue) as lifetime_value,

    sum(net_revenue) / nullif(count(distinct order_id), 0) as avg_order_value,

    case 
        when count(distinct order_id) > 1 then 1 
        else 0 
    end as is_repeat_customer

from sales
group by
    customer_id,
    customer_city,
    customer_state