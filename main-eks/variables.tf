variable "eks_cluster_name" {
  description = "Target EKS cluster name"
  type =  string
}

variable "eks_cluster_version" {
  description = "Target EKS cluster version"
  type =  string
}

variable "eks_node_group_min_size" {
  description = "Minimum number of nodes. Will be applied to runtime and data pools"
  type =  number
}
variable "eks_node_group_max_size" {
  description = "Maximum number of nodes. Will be applied to runtime and data pools"
  type =  number
}
variable "eks_node_group_desired_size" {
  description = "Minimum number of nodes. Will be applied to runtime and data pools"
  type =  number
}
variable "eks_node_group_instance_types" {
  description = "Nodes types, must be a valid aws VM type and available in the selected region."
  type =  list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type = string
}

variable "kms_user_identity" {
  description = "Kms user identity"
  type =  string
  default = "root"
}

variable "kms_admin_identity" {
  description = "Kms user identity"
  type =  string
  default = "root"
}

variable "tags" {
  description = "Global tags that will be added to all resources"
  type = map(string)
}

variable "k8s_admins" {
  type = list(string)
  description = "List of k8s admins, must be iam users."
}