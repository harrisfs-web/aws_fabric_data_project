import boto3
import csv
from io import StringIO

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = 'iot-uploads-123'
    
    # get file name from staging layer
    key = event['Records'][0]['s3']['object']['key']

    if not key.startswith("staging_layer/"):
        return {'statusCode': 400, 'body': 'Incorrect folder'}

    response = s3.get_object(Bucket=bucket_name, Key=key)
    new_data = response['Body'].read().decode('utf-8')
    
    new_csv = csv.DictReader(StringIO(new_data)) # read csv to dict
    
    main_csv_key = 'storage_layer/main.csv'
    
    # create or update the main file in the storage layer
    try:
        response = s3.get_object(Bucket=bucket_name, Key=main_csv_key)
        existing_data = response['Body'].read().decode('utf-8')
        writer_mode = 'a'
    except s3.exceptions.NoSuchKey:
        existing_data = ''
        writer_mode = 'w'
    
    with StringIO(existing_data) as existing_csv:
        reader = csv.DictReader(existing_csv)
        fieldnames = reader.fieldnames if reader.fieldnames else new_csv.fieldnames
        combined_csv = StringIO()
        writer = csv.DictWriter(combined_csv, fieldnames=fieldnames)
        writer.writeheader()
        if existing_data:
            for row in reader:
                writer.writerow(row)
        for row in new_csv:
            writer.writerow(row)
    
        s3.put_object(Bucket=bucket_name, Key=main_csv_key, Body=combined_csv.getvalue().encode('utf-8')) # write back to s3

    return {'statusCode': 200, 'body': 'process successful'}
