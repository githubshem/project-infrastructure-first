terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.0"
    }
  }
}

####################################################
# AWS
# Region: us-east 1
####################################################

provider "aws" {
  alias  = "east_1"
  region = "us-east-1"
}

####################################################
# VPC
####################################################

data "aws_vpc" "vpc_1" {
  id = resource.aws_security_group.sg_1.vpc_id
}

####################################################
# EC2 Instance
####################################################

/* resource "aws_instance" "instance_1" {
  count = length(var.instance_name)

  ami             = "ami-0c101f26f147fa7fd"
  instance_type   = "t2.micro"
  key_name        = data.aws_key_pair.pkey_east_1.key_name
  security_groups = ["aws_security_group.sg_1.id"]

  tags = {
    Name = "ec2_${var.instance_name[count.index]}"
  }
} */

resource "aws_instance" "instance_1" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.pkey_east_1.key_name
  vpc_security_group_ids = ["data.aws_vpc.vpc_1.id"]
  security_groups        = ["aws_security_group.sg_1.id"]

  tags = {
    Name = "ec2_1"
  }
}

####################################################
# EC2 Instance State
####################################################

/* resource "aws_ec2_instance_state" "instance_1" {
  instance_id = aws_instance.instance_1.id
  state       = "stopped"
} */

####################################################
# EC2 key Pair
####################################################

data "aws_key_pair" "pkey_east_1" {
  key_name           = "test_instance_1"
  include_public_key = true
}

####################################################
# Security Group
####################################################

resource "aws_security_group" "sg_1" {
  name        = "sg_1"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0ee41b4f4617ff425"

  tags = {
    Name = "sg_1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.sg_1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

####################################################
# Launch Template
####################################################

resource "aws_launch_template" "lt_east_1" {
  name = "launch_template_1"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 8
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

/*   cpu_options {
    core_count       = 4
    threads_per_core = 2
  } */

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  elastic_gpu_specifications {
    type = "test"
  }

  elastic_inference_accelerator {
    type = "eia1.medium"
  }

  iam_instance_profile {
    name = "test"
  }

  image_id = "ami-0c101f26f147fa7fd"

/*   instance_initiated_shutdown_behavior = "terminate" */

  instance_type = "t2.micro"

/*   kernel_id = "test" */

  key_name = data.aws_key_pair.pkey_east_1.key_name

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  ram_disk_id = "test"

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}

####################################################
# Provider: AWS
# Region: us-east 2
####################################################

/* provider "aws" {
  alias  = "east_2"
  region = "us-east-2"
} */

####################################################
# EC2 instance
####################################################

/* resource "aws_instance" "instance_2" {
  count = length(var.instance_name)

  ami             = "ami-0c101f26f147fa7fd"
  instance_type   = "t2.micro"
  key_name        = data.aws_key_pair.pkey_east_1.key_name
  security_groups = [aws_security_group.sg_1.id]

  tags = {
    Name = "ec2_${var.instance_name[count.index]}"
  }
} */

####################################################
# EC2 Instance State
####################################################

/* resource "aws_ec2_instance_state" "instance_2" {
  instance_id = aws_instance.instance_2.id
  state       = "stopped"
} */

####################################################
# EC2 Key Pair
####################################################

/* data "aws_key_pair" "pkey_east_2" {
  key_name           = "test_instance_1"
  include_public_key = true
} */

####################################################
# Security Group
####################################################

resource "aws_security_group" "sg_2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}