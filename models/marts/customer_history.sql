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
    V.customer_id,
    V.customer_name,
    V.region,
    V.status,
    V.account_balance,
    V.valid_from,
    V.valid_to,
    CASE
        WHEN valid_to is NULL THEN TRUE
        ELSE FALSE
    END AS is_current,
    curr.customer_state
FROM versions V
LEFT JOIN {{ ref('customer_current') }} curr
    ON V.customer_id = curr.customer_id