select
CONCAT(store_id, '_', product_id) AS stocks_id,
store_id,
product_id,
quantity

from {{ source('local_bike', 'stocks') }}