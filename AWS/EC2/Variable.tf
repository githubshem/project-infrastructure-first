####################################################
# Region Variables
####################################################

/* # AWS Region
variable "region" {
  type = string(list)
  default = [
    "us-east-1"
    "us-east-2"
    "ap-southeast-1"
  ]
} */

####################################################
# EC2 Instance Variables
####################################################

# AWS EC2 Instance Type
variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

# AWS EC2 Instance AMI
variable "ami" {
  type        = string
  description = "AMI of EC2 instances"
  default     = "ami-07caf09b362be10b8"
}

# AWS EC2 Instance Name
variable "instance_name" {
  description = "Instance Name"
  type        = list(string)
  default     = [1, 2, 3]
}

####################################################
# Key Pair Variables
####################################################

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key"
}

/* # AWS EC2 Instance Security Group
variable "security_group_id" {
  description = "Security Group"
  type        = string
  default = [

  ]
}

# AWS EC2 Instance Subnet ID
variable "vpc_subnet_id" {
  description = "AMI of EC2 instances"
  type        = string
  default     = ""
} */