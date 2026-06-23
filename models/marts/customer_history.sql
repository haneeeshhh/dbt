WITH all_events as(
    SELECT
        customer_id,
        customer_name,
        region,
        status,
        account_balance,
        loaded_date,
        'Present' as customer_state
    FROM {{ ref('int_customer_changes') }}
    UNION ALL
    SELECT
        customer_id,
        customer_name,
        region,
        status,
        account_balance,
        loaded_date,
        customer_state
    FROM {{ ref('int_missing_events') }}
),
versions AS (
    SELECT
        customer_id,
        customer_name,
        region,
        status,
        account_balance,
        customer_state,
        loaded_date AS valid_from,

        LEAD(loaded_date) over(
            PARTITION BY customer_id
            ORDER BY loaded_date
        ) AS valid_to
    FROM all_events
)
SELECT
    customer_id,
    customer_name,
    region,
    status,
    account_balance,
    customer_state,
    valid_from,
    valid_to,
    CASE
        WHEN valid_to IS NULL THEN TRUE
        ELSE FALSE
    END AS is_current
FROM versions
order by customer_id, valid_from