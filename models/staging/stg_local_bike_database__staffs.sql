select 
staff_id,
first_name,
last_name,
email,
phone,
active,
store_id,
SAFE_CAST(manager_id as INT64) as manager_id
from {{ source('local_bike', 'staffs') }}