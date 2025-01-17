-- Create table 

 create or replace table emp (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

create or replace file format csv_format
type = csv;

-- Create stage objete to read s3 file.
create or replace stage my_s3_stage
url = 's3://snowflakesmpdata/employee/'
file_format = csv_format;


-- We will be copying the data where we have error values for date columns.

copy into emp
from @my_s3_stage
file_format = (type = csv field_optionally_enclosed_by='"')
--pattern = '.*employees0[1-5].csv'
validation_mode = 'RETURN_ERRORS';

-- Recreate the table with start_date as string.

 create or replace table emp (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date string
);

-- We will change the data type of date column and try to load it again.

copy into emp
from @my_s3_stage
file_format = (type = csv field_optionally_enclosed_by='"')
--pattern = '.*employees0[1-5].csv'
validation_mode = 'RETURN_ERRORS';