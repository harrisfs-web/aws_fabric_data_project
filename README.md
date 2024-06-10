## Project Details

The goal was to create an end-to-end data engineering project that combines cloud environments from both AWS and Microsoft as well as other sources.
The steps include data generation, stagind and storing, security considerations, ETL pipelines, BI reports and more.

The main goal is to create simple solutions/examples to demonstrate capabilities of those solutions without going too much in-depth in any of the steps.

** The decision to not include the .pbix file is due to the work put behind it and the valuable calculations and queries included**

## Project Architecture
![alt text](<AWS_Fabric Project.png>)

## Sources/Connections

#### AWS Side:
* Source 1: Static web-page with file upload form for third-party file sharing. The authentification is completed using pre-signed URLs using the AWS CLI with a short-expiration time
* Source 2: IoT device emulator using an EC2 instance uploading data in a constant interval. Using a Lambda function triggered at each csv upload in the staging layer a simple transformation is performed to prepare the data for further use

#### On-Premise:
* Source 3: MySQL server running on a local server using pre-existing (sakila & world) and new schemas (e-commerce) while creating various view
* Source 4: Files from local storage

#### Web APIs:
* Source 5: Load weather data from publicly available API

#### Microsoft Fabric side:
* Connection 1: S3 shortcut to the bucket containing the static web page uploads from external users
* Connection 2: S3 shortcut to the bucket containing the simulated IoT data generated using EC2
* Connection 3: On-Premise Data Gateway + Dataflow (Gen 2) to load data from the MySQL server and the local files
* Connection 4: Dataflow (Gen 2) to load data from the weather API connection

Notes:
- Using IAM to comply with Principle of Least Privilege and CloudWatch to monitor the service logs
- On-premise database is introduced to simulate a hybric cloud environment
- Use of Figma UI templates to create the canvas for the Power BI report


## Command Prompt Snippets
#### CLI actions - create pre-signed URLs:
aws configure
aws s3 presign s3://s3.static-upload.io/file-name --expires-in 3600

#### bash script - IoT simulation script scheduling:
ssh connect:
ssh -i "ec2-ssh-url-here"

Make file executable: chmod +x iot_data_gen.sh
Run script once: ./iot_data_gen.sh
Run every X minutes: crontab -e and then */30 * * * * /home/ec2-user/bash_code/iot_data_gen.sh

For cron:
sudo yum install cronie -y
sudo systemctl start crond
sudo systemctl enable crond
sudo systemctl status crond
