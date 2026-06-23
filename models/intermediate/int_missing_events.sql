WITH snapshot_date AS (
    SELECT DISTINCT
        loaded_date
    FROM {{ ref('customer_stg') }}
),
date_pairs AS (
    SELECT
        loaded_date AS current_date,
        lead(loaded_date) over (
            ORDER by loaded_date
        ) AS next_date
    FROM snapshot_date
),
current_snapshot AS (
    SELECT
        customer_id,
        customer_name,
        region,
        status,
        account_balance,
        loaded_date
    FROM {{ ref('customer_stg') }}
),
customer_current AS (
    SELECT
        d.current_date,
        d.next_date,

        c.customer_id,
        c.customer_name,
        c.region,
        c.status,
        c.account_balance

    FROM date_pairs d
    JOIN current_snapshot c
        on d.current_date = c.loaded_date
),
missing_check AS (
    SELECT
        cc.*,
        n.customer_id AS next_customer_id
    from customer_current cc
    left join current_snapshot n
        on cc.customer_id = n.customer_id
        AND cc.next_date = n.loaded_date
)
SELECT 
    customer_id,
    customer_name,
    region,
    status,
    account_balance,
    next_date AS loaded_date,
    'Missing' AS customer_state
FROM missing_check
WHERE next_customer_id is NULL
    AND next_date IS NOT NULL
ORDER BY CUSTOMER_ID, loaded_date