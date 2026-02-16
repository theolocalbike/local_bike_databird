with stock as (
    select *
    from {{ ref('int_store_stock') }}
),

sales as (
    select
        store_id,
        product_id,
        sum(quantity) as total_units_sold,
        min(date(order_date)) as first_order_date,
        max(date(order_date)) as last_order_date
    from {{ ref('int_sales_enriched') }}
    group by store_id, product_id
),

product_coverage as (
    select
        st.store_id,
        st.store_name,
        st.product_id,
        st.product_name,
        st.stock_quantity,
        coalesce(s.total_units_sold, 0) as total_units_sold,
        
        -- Nombre de jours sur lesquels il y a eu des ventes
        case 
            when s.first_order_date is not null and s.last_order_date is not null
            then date_diff(s.last_order_date, s.first_order_date, day) + 1
            else null
        end as days_of_sales,
        
        -- Moyenne quotidienne des ventes
        case
            when s.total_units_sold is null
                 or date_diff(s.last_order_date, s.first_order_date, day) + 1 < 1
            then null
            else cast(s.total_units_sold as float64) / (date_diff(s.last_order_date, s.first_order_date, day) + 1)
        end as average_daily_sales,
        
        -- Stock coverage final
        case
            when s.total_units_sold is null
                 or s.total_units_sold = 0
                 or date_diff(s.last_order_date, s.first_order_date, day) + 1 < 7
            then null
            else st.stock_quantity / 
                 (cast(s.total_units_sold as float64) /
                  (date_diff(s.last_order_date, s.first_order_date, day) + 1))
        end as stock_coverage_days
    from stock st
    left join sales s
        on st.store_id = s.store_id
        and st.product_id = s.product_id
)

select *
from product_coverage
order by store_id, product_id

