variable "aws_region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "us-east-1b_availability_zone" {
  type = string
}
variable "us-east-1c_availability_zone" {
  type = string
}
variable "us-east-1d_availability_zone" {
  type = string
}
variable "public_subnet_1_cidr" {
  type = string
}
variable "public_subnet_2_cidr" {
  type = string
}
variable "public_subnet_3_cidr" {
  type = string
}
variable "private_subnet_1_cidr" {
  type = string
}
variable "private_subnet_2_cidr" {
  type = string
}
variable "private_subnet_3_cidr" {
  type = string
}
variable "public_subnet_1_name" {
  type = string
}
variable "public_subnet_2_name" {
  type = string
}
variable "public_subnet_3_name" {
  type = string
}
variable "private_subnet_1_name" {
  type = string
}
variable "private_subnet_2_name" {
  type = string
}
variable "private_subnet_3_name" {
  type = string
}

variable "kms_key_deletion_window" {
  type = number
}
variable "kms_key_rotation_period" {
  type = number
}
variable "eks_secrets_key_alias" {
  type = string
}
variable "ebs_volumes_key_alias" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}
variable "eks_cluster_version" {
  type = string
}
variable "eks_cluster_authentication_mode" {
  type = string
}
variable "eks_cluster_ip_family" {
  type = string
}
variable "eks_cluster_node_group_name" {
  type = string
}
variable "node_group_instance_capacity_type" {
  type = string
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum size of the node group"
}

variable "node_group_max_size" {
  type        = number
  description = "Maximum size of the node group"
}

variable "node_group_desired_size" {
  type        = number
  description = "Desired size of the node group"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "Instance types for the node group"
}

variable "node_group_instance_ami_type" {
  type        = string
  description = "AMI type for the node group instances"
}

variable "node_group_instance_disk_size" {
  type        = number
  description = "Disk size (in GB) for the node group instances"
}

variable "node_group_instance_max_unavailable" {
  type        = number
  description = "Maximum number of unavailable nodes during updates"
}

variable "chart_path_autoscaler" {
  description = "The path to the directory containing the Helm chart archives"
  type        = string
}

variable "chart_path_fluentbit" {
  description = "The path to the directory containing the Helm chart archives"
  type        = string
}

variable "kubeconfig_path" {
  description = "The path to the local kubeconfig file"
  type        = string
}

variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_hostname" {
  type = string
}
variable "grafana_username" {
  type = string
}
variable "grafana_password" {
  type = string
}
variable "cluster_autoscaler_image_tag" {
  type = string
}