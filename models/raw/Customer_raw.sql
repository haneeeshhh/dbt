SELECT 
    *,
    'DAY1' AS source_file
FROM {{ source('raw', 'raw_day1')}}

UNION ALL

SELECT
    *,
    'DAY2' AS source_file
FROM {{ source('raw', 'raw_day2')}}

UNION ALL

SELECT
    *,
    'DAY3' AS source_file
FROM {{ source('raw', 'raw_day3')}}