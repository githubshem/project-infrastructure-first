################################################################################
# AWS
# Region: us-east 1
################################################################################

provider "aws" {
  alias  = "east_2"
  region = "us-east-2"
}

################################################################################
# VPC
################################################################################

/* resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/24"
} */

/* variable "vpc_id" {}

data "aws_vpc" "default" {
  id = ""

  filter {
    name     = "vpc-id"
    values   = ["vpc-05e89b07a4ff0a12b"]
  }
} */

/* resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "us-west-2a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
} */
