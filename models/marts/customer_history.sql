WITH versions as(
    SELECT
    customer_id,
    customer_name,
    region,
    status,
    account_balance,
    loaded_date as valid_from,
    lead(loaded_date) over(
        PARTITION BY customer_id
        ORDER BY loaded_date
    ) AS valid_to
    FROM {{ ref('int_customer_changes') }}
)
SELECT
    customer_id,
    customer_name,
    region,
    status,
    account_balance,
    valid_from,
    valid_to,
    CASE
        WHEN valid_to is NULL THEN TRUE
        ELSE FALSE
    END AS is_current
FROM versions