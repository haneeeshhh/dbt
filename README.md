dbt Customer History Assignment

Overview:

This project uses dbt and Snowflake to transform daily customer data into analytical tables.

The pipeline raw data, standardizes data, creates a current customer view, tracks changes, and applies data quality checks:

RAW_DAY1
RAW_DAY2
RAW_DAY3
    ↓
raw_customers
    ↓
customer_stg --> test(schema.yml)
    ↓
int_customer_changes
    ↓
customer_current --> test(schema.yml)
customer_history --> test(schema.yml)

Models:

1. raw/raw_customers

Combines all three daily snapshots using UNION ALL to preserve historical records.

2. staging/customer_stg

Standardizes the data by:
Trimming text fields
Converting customer_id to numeric
Converting loaded_date to date
Converting account_balance to numeric
Standardizing region and status

tested customer_id(unique, not null) and loaded_date(not null)

3. intermediate/int_customer_changes

Identifies customer records where one or more attributes changed compared to the previous snapshot using LAG().

4. marts/customer_current

Returns one row per customer representing the latest known state.
ROW_NUMBER() was used to select the most recent record for each customer.

Tested customer_id(not null, unique)

5. marts/customer_history

Maintains the complete history of customer changes.
LEAD() was used to generate:

valid_from
valid_to
is_current

Tested customer_id(not_null) and valid_from(not_null)

output folder consists of output images do check out
