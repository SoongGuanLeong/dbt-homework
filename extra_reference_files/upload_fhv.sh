green#!/bin/bash

BUCKET="gs://my-free-tier-16-6-dbt-homework/fhv"

for year in 2019; do
  for month in {01..12}; do
    if [[ "$year$month" > "201912" ]]; then break; fi

    FILE="fhv_tripdata_${year}-${month}.csv.gz"
    URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/$FILE"

    echo "⬇️  Downloading $FILE"
    wget -q $URL || { echo "❌ $FILE not found"; continue; }

    echo "☁️  Uploading to $BUCKET"
    gsutil cp $FILE $BUCKET

    rm $FILE
  done
done
