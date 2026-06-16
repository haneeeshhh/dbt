WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY loaded_date DESC
            )AS ranking
    FROM {{ ref('customer_stg') }}
),

customer_current AS(
    SELECT
        customer_id,
        customer_name,
        region,
        status,
        account_balance,
        loaded_date
    FROM ranked
    WHERE ranking = 1
),
latest_snapshot AS(
    SELECT MAX(loaded_date) as latest_date
    FROM {{ ref('customer_stg') }}
)
SELECT
    C.customer_id,
    C.customer_name,
    C.region,
    C.status,
    C.account_balance,
    C.loaded_date,
    CASE
        WHEN C.loaded_date < 
            (SELECT latest_date FROM latest_snapshot) THEN 'MISSING'
        ELSE 'PRESENT'
    END AS customer_state
FROM customer_current C