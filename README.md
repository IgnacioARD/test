# **Technical Assessment**

## About the project

This project consists of a terraform code for deploying a AWS S3 Bucket that contains 2 .text files which have a timestamp of the running time as their content and a terratest code to test the code mentioned before.

This repository also has GitHub actions implemented, which means that every code that requests a pull to the main branch will be tested by running the terratest code.

## Usage
  
  * Prerequisites:
    1. Have Go installed, v1.13+
    2. Have terraform CLI installed, v1
    3. AWS CLI installed and configured with your own AWS credentials

  * Running Terraform without testing:
    1. Open CLI in the *Terraform* directory and 
    2. run **terraform init** command
    3. run **terraform apply** command

  * Running terratest to test the terraform code:
    1. Open CLI in the *test* direcotry 
    2. Configure dependencies by running *go mod init "<MODULE_NAME>"* command
    3. Run the test by running *go test -v* command

