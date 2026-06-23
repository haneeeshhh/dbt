WITH customer_history as (
    SELECT
        customer_id,
        customer_name, 
        LAG(customer_name) OVER(
            PARTITION BY customer_id
            ORDER BY loaded_date 
        ) as prev_name,
        region,
        LAG(region) OVER(
            PARTITION BY customer_id
            ORDER BY loaded_date 
        ) AS prev_region,
        status,
        LAG(status) OVER(
            PARTITION BY customer_id
            ORDER BY loaded_date 
        ) AS prev_status,
        account_balance,
        LAG(account_balance) OVER(
            PARTITION BY customer_id
            ORDER BY loaded_date 
        ) AS prev_account_balance,
        loaded_date,
    FROM {{ ref('customer_stg') }}
)
SELECT
    customer_id,
    customer_name,
    region,
    status,
    account_balance,
    loaded_date
FROM customer_history
WHERE prev_name IS NULL
    or Customer_name IS DISTINCT FROM prev_name
    or region IS DISTINCT FROM prev_region
    or status IS DISTINCT FROM prev_status
    or account_balance IS DISTINCT FROM prev_account_balance