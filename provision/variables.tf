# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    us-east-1 = "us-east-1a"
    us-west-1 = "us-west-1a"
  }
}

# AMIs optimized for use with ECS Container Service
# Note: changes occur regularly to the list of recommended AMIs.  Verify at
# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
variable "ecsAmi" {
  description = "optimized ECS AMIs"
  default = {
    us-east-1 = "ami-d15a75c7"
    us-west-1 = "ami-bb473cdb"
  }
}

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to login to the box"
  default = "demo-key"
}

########################### AMI VPC Config ##################################

variable "ami_vpc" {
  description = "VPC for building AMIs"
}

variable "ami_network_cidr" {
  description = "Uber IP addressing for AMI Network"
}

variable "ami_public_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

########################### Test VPC Config ################################

variable "test_vpc" {
  description = "VPC for Test environment"
}

variable "test_network_cidr" {
  description = "IP addressing for Test Network"
}

variable "test_public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "test_public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

########################### Prod VPC Config ################################

variable "prod_vpc" {
  description = "VPC for Prod environment"
}

variable "prod_network_cidr" {
  description = "IP addressing for Prod Network"
}

variable "prod_public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}
variable "prod_public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}
