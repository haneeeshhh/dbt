SELECT
    customer_id,
    valid_from,
    count(*)
FROM {{ ref('customer_history') }}
GROUP BY
    customer_id,
    valid_from
HAVING COUNT(*) > 1