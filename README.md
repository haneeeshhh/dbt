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

How to RUN DBT models:

"dbt run" to run the dbt models
"dbt test" to run the dbt test
"dbt build" to run both models and tests


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
ROW_NUMBER() was used to select the most recent record for each customer. Basically assigned ROW_NUMBER() based on the order by loaded_date. For instance,
if there are 3 dates for the customer 1001 --> 6/1/2026, 6/2/2026, 6/3/2026 we assigned ROW_NUMBER() based on latest record
loaded_date    row_number()
6/3/2026            1
6/2/2026            2
6/1/2026            3    did the samething for every customer_id(by using partition by) 

every latest record gets row number 1
so we can extract the latest record by where row_number() = 1 

Handling Missing Customer (1005):
Customer 1005 was missing from the Day 3

Took the MAX(loaded_date) as the latest date and performed a case operation (if loaded_date < latest_date) then missing. which means the record is not available on the day 3. so i marked as missing else present. (models/marts/customer_current.sql)

Tested customer_id(not null, unique)

5. marts/customer_history

Maintains the complete history of customer changes.
Lag() and LEAD() was used to generate:

first used lag() to get loaded date for the changes in the history(valid from)
and used lead() to get the valid to


Tested customer_id(not_null) and valid_from(not_null)
 

Present – Customer exists in the latest data
Missing – Customer is absent from the latest data

The folder Snowflake_sql contains the sql codes that is used to create database, schemas, tables etc.

output folder consists of output images do check out
