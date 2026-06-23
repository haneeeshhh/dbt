USE DATABASE CUSTOMER_DB;
USE SCHEMA CUSTOMER_HISTORY;
CREATE OR REPLACE TABLE RAW_DAY1(
    customer_id STRING,
    customer_name STRING,
    region STRING,
    status STRING,
    account_balance STRING,
    loaded_date STRING
);

CREATE OR REPLACE TABLE RAW_DAY2(
    customer_id STRING,
    customer_name STRING,
    region STRING,
    status STRING,
    account_balance STRING,
    loaded_date STRING
);

CREATE OR REPLACE TABLE RAW_DAY3(
    customer_id STRING,
    customer_name STRING,
    region STRING,
    status STRING,
    account_balance STRING,
    loaded_date STRING
);

CREATE OR REPLACE TABLE RAW_DAY4(
    customer_id STRING,
    customer_name STRING,
    region STRING,
    status STRING,
    account_balance STRING,
    loaded_date STRING
);


COPY INTO RAW_DAY1
FROM @CUSTOMER_STAGE/day1.csv
FILE_FORMAT = CSV_FORMAT;

COPY INTO RAW_DAY2
FROM @CUSTOMER_STAGE/day2.csv
FILE_FORMAT = CSV_FORMAT;

COPY INTO RAW_DAY3
FROM @CUSTOMER_STAGE/day3.csv
FILE_FORMAT = CSV_FORMAT;

COPY INTO RAW_DAY4
FROM @CUSTOMER_STAGE/day4.csv
FILE_FORMAT = CSV_FORMAT;

--feteches the customer_current data
SELECT * FROM CUSTOMER_DB.CUSTOMER_HISTORY.CUSTOMER_CURRENT;

--feteches the customer_history
SELECT * FROM CUSTOMER_DB.CUSTOMER_HISTORY.CUSTOMER_HISTORY;


