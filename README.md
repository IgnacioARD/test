# **Technical Assessment**

## About the project

This project consists of a terraform code for deploying a AWS S3 Bucket that contains 2 .text files which have a timestamp of the running time as their content and a terratest code to test the code mentioned before.

This repository also has GitHub actions implemented, which means that every code that requests a pull to the main branch will be tested by running the terratest code.

## Usage
  
  * Prerequisites:
    1. Have Go installed, v1.13+
    2. Have terraform CLI installed, v1

