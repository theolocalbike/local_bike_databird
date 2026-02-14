-- models/marts/mart_stock_analysis.sql

with stock as (

    select *
    from {{ ref('int_store_stock') }}

),

sales as (

    select
        store_id,
        product_id,
        sum(quantity) as total_units_sold
    from {{ ref('int_sales_enriched') }}
    group by 1,2

)

select

    st.store_id,
    st.store_name,
    st.product_id,
    st.product_name,

    st.stock_quantity,

    coalesce(s.total_units_sold, 0) as total_units_sold,

    case 
        when st.stock_quantity = 0 then null
        else coalesce(s.total_units_sold, 0) / st.stock_quantity
    end as sales_to_stock_ratio

from stock st

left join sales s
    on st.store_id = s.store_id
    and st.product_id = s.product_id