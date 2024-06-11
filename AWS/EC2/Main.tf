####################################################
# AWS
# Region: us-east 1
####################################################

provider "aws" {
  alias  = "east_1"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
    }
  }
}

####################################################
# VPC
####################################################

data "aws_vpc" "vpc_1" {
  id = "vpc-0ee41b4f4617ff425"
}

####################################################
# EC2 Instance
####################################################

module "ec2_instance" {
  source = "./.terraform/modules/instance"

  name = "ec2 from Terraform"

  instance_type = "t2.micro"
  ami           = "ami-0c101f26f147fa7fd"
  key_name      = aws_key_pair.pukey_east_1.key_name

  tags = {
    Terraform   = "True"
    Environment = terraform.workspace
  }
}

# resource "aws_instance" "instance_1" {
#   count = length(var.instance_name)

#   ami                         = "ami-0c101f26f147fa7fd"
#   instance_type               = "t2.micro"
#   key_name                    = data.aws_key_pair.pukey_east_1.key_name
#   security_groups             = ["aws_security_group.sg_1.id"]
#   associate_public_ip_address = true

#   provisioner "local-exec" {
#     command = "chmod 600 ${local_file.private_key_pem.filename}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo rm -rf /tmp",
#       "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
#       "sudo sh /tmp/assets/setup-web.sh"
#     ]
#   }

#   tags = {
#     Name = "ec2_${var.instance_name[count.index]}"
#   }
# }

####################################################
# EC2 Instance State
####################################################

# resource "aws_ec2_instance_state" "instance_1" {
#   instance_id = aws_instance.instance_1.id
#   state       = "stopped"
# }

####################################################
# EC2 key Pair
####################################################

resource "tls_private_key" "prkey_east_1" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.prkey_east_1.private_key_pem
  filename = "test_instance_2.pem"
}

resource "aws_key_pair" "pukey_east_1" {
  key_name   = "test_instance_2"
  public_key = tls_private_key.prkey_east_1.public_key_openssh
}

# data "aws_key_pair" "pukey_east_1" {
#   key_name           = "test_instance_1"
#   include_public_key = true
# }

####################################################
# Security Group
####################################################

module "web_server_sg" {
  source = "./.terraform/modules/security group"

  name                = "web-server"
  description         = "Security group for web-server with HTTP ports open within VPC"
  vpc_id              = data.aws_vpc.vpc_1.id
  ingress_cidr_blocks = ["10.10.0.0/16"]

  tags = {
    Name = "sg_1"
  }
}

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = module.web_server_sg
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   to_port           = 22
#   ip_protocol       = "tcp"
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = module.web_server_sg
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }