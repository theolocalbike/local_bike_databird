select 
CONCAT(order_id, '_', item_id) AS order_item_id,
order_id,
item_id,
product_id,
quantity,
list_price,
discount
from {{ source('local_bike', 'order_items') }}