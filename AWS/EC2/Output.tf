####################################################
# EC2 Instance
# us-east-1
####################################################

output "instance_name_1" {
  value = resource.aws_instance.instance_1
}

####################################################
# key pair
# us-east-1
####################################################

output "fingerprint_1" {
  value = data.aws_key_pair.pkey_east_1.fingerprint
}

output "name_1" {
  value = data.aws_key_pair.pkey_east_1.key_name
}

output "id_1" {
  value = data.aws_key_pair.pkey_east_1.id
}

####################################################
# EC2 Instance
# us-east-2
####################################################

/* output "instance_name_2" {
  value = resource.aws_instance.instance_2
} */

####################################################
# key pair
# us-east-2
####################################################

/* output "fingerprint_2" {
  value = data.aws_key_pair.pkey_east_2.fingerprint
}

output "name_2" {
  value = data.aws_key_pair.pkey_east_2.key_name
}

output "id_2" {
  value = data.aws_key_pair.pkey_east_2.id
} */

####################################################
# security group
# 
####################################################

output "security_group_id" {
  value = resource.aws_security_group.sg_1.id
}