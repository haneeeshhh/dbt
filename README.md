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

project setup:
Download the raw CSV files from the folder csv_files
day1.csv
day2.csv
day3.csv

Open snowflake and create warehouse(customer_hw), database(customer_db), schema(customer_history), stage. upload the csv files into the snowflake stage.
Now create 3 tables with the name raw_day1, raw_day2, raw_day3
In dbt, create connection with snowflake and load the tables 

How to RUN DBT models:

"dbt run" to run the dbt models
"dbt test" to test the model
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


5. marts/customer_history

Maintains the complete history of customer changes.
Lag() and LEAD() was used to generate:

first used lag() to get loaded date for the changes in the history(valid from)
and used lead() to get the valid to

Also added the new column where it shows whether the person is 

Present – Customer exists in the latest data
Missing – Customer is absent from the latest data


The folder Snowflake_sql contains the sql codes that is used to create database, schemas, tables etc.

dbt Tests:

customer_stg:
customer_id not null
Ensures every record has a valid customer identifier.
loaded_date not null
Ensures every record belongs to a valid snapshot date.
status accepted values
Restricts status values to:
  Active
  Inactive
This helps detect unexpected source values.
customer_current
customer_id unique
Ensures only one current record exists per customer.
customer_id not null
Ensures all current customers have valid identifiers.
customer_history
customer_id not null
Ensures all historical records belong to a customer.
valid_from not null
Ensures every history version has a start date.
One current version per customer (custom test)
Verifies that a customer cannot have more than one record with is_current = TRUE.
No duplicate history versions (custom test)
Verifies that the same customer version is not stored multiple times for the same valid_from date.

output folder consists of output images do check out
