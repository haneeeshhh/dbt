Output Files
The project generate the following output models after running dbt build.

customer_current.csv:
Contains the latest data of every customer with their current details.
Features:
* One record per customer
* Latest customer information
* Customer state - Present/Missing

customer_history.csv:
Contains the complete history with version tracking.
Features:
* Tracks attribute changes over time
* Records missing customer events
* include valid_from, valid_to, and is_current columns
* Maintains historical versions of each customer
