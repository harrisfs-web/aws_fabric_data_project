#!/bin/bash
BUCKET_NAME=iot-uploads-123
FOLDER_NAME = "staging_layer"
data_file="data.csv" #data file

echo "id,timestamp,value" > $data_file #headers

for i in {1..100}; do
    id=$((RANDOM % 10 + 1))
    timestamp=$(date +%s)  
    value=$(printf "%.2f" "$(echo "scale=2; $RANDOM%10000/100" | bc)")

    echo "$id,$timestamp,$value" >> $data_file # append data to file
done

filename="iot-data-$(date +%Y%m%d%H%M%S).csv" # file creation based on timestamp

aws s3 cp $data_file s3://$BUCKET_NAME/$FOLDER_NAME/$filename # S3 upload

rm $data_file
