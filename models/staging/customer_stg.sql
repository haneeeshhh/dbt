SELECT
    TO_NUMBER(customer_id) as customer_id,
    TRIM(customer_name) as customer_name,
    INITCAP(TRIM(region)) as region,
    INITCAP(TRIM(status)) as status,
    TO_DECIMAL(account_balance, 18, 2) AS account_balance,
    TO_DATE(loaded_date) AS loaded_date,
    SOURCE_FILE
FROM {{ ref('Customer_raw') }}
