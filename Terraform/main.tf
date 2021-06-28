terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

//Creates the variable for the bucket name
variable "bucket_name" {
  description = "The name of the bucket"
  default     = "-example"
}

//Creates the Bucket
resource "aws_s3_bucket" "b" {
  acl    = "private"
  bucket = "terratest${var.bucket_name}"
  tags = {
    Name        = "My bucket"
  }
  versioning {
    enabled = true
  }

  force_destroy = true
}

//Creates locals
locals {
    current_time = timestamp()
}

//Creates first file with timestamp
resource "local_file" "test1" {
    content     = local.current_time
    filename = "test1.txt"
}

//Creates second file with timestamp
resource "local_file" "test2" {
    content     = local.current_time
    filename = "test2.txt"
}

//Creates a Null resource to be a dependency to time_sleep1
resource "null_resource" "previous1" {}

//Sleeps the process for 30 seconds
resource "time_sleep" "wait_30_seconds1" {
  depends_on = [null_resource.previous1]

  create_duration = "30s"
}

//Creates a Null resource to be a dependency for the upload of the first file
resource "null_resource" "next1" {
  depends_on = [time_sleep.wait_30_seconds1]
}

//Uploads the first .text file to the bucket
resource "aws_s3_bucket_object" "file1" {
  bucket = "terratest${var.bucket_name}"
  key    = "test1"
  source = "test1.txt"
  depends_on = [null_resource.next1]
}

//Creates a Null resource to be a dependency to time_sleep2
resource "null_resource" "previous2" {}

//Sleeps the process for 30 seconds
resource "time_sleep" "wait_30_seconds2" {
  depends_on = [null_resource.previous2]

  create_duration = "30s"
}

//Creates a Null resource to be a dependency for the upload of the first file
resource "null_resource" "next2" {
  depends_on = [time_sleep.wait_30_seconds1]
}

//Uploads the second .text file to the bucket
resource "aws_s3_bucket_object" "file2" {
  bucket = "terratest${var.bucket_name}"
  key    = "test2"
  source = "test2.txt"
  depends_on = [null_resource.next2]
}

output "bucket_id" {
  value = aws_s3_bucket.b.id
}