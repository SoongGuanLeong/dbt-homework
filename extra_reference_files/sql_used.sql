-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `my-free-tier-16-6.dbt_homework.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://my-free-tier-16-6-dbt-homework/yellow/yellow_tripdata_2019-*.csv.gz',
    'gs://my-free-tier-16-6-dbt-homework/yellow/yellow_tripdata_2020-*.csv.gz'
    ]
);

-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `my-free-tier-16-6.dbt_homework.external_green_tripdata`
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://my-free-tier-16-6-dbt-homework/green/green_tripdata_2019-*.csv.gz',
    'gs://my-free-tier-16-6-dbt-homework/green/green_tripdata_2020-*.csv.gz'
    ]
);

-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `my-free-tier-16-6.dbt_homework.external_fhv_tripdata`
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://my-free-tier-16-6-dbt-homework/fhv/fhv_tripdata_2019-*.csv.gz'
    ]
);
