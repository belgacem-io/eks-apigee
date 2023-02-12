# Description

This module allows easy creation of one EKS cluster along with all required configuration for running and Apigee runtime modules.

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
If you haven't
## Usage

Basic usage of this module is as follows:

```hcl
module "apigee_eks" {
  source        = "./"

  eks_cluster_name = "eks-apigee"
  eks_cluster_version = "1.24"
  eks_node_group_max_size = 7
  eks_node_group_min_size = 1
  eks_node_group_desired_size = 2
  eks_node_group_instance_types = ["m6i.xlarge"]

  k8s_admins = ["eks-user1","eks-user2"]

  vpc_cidr = "10.0.0.0/16"
  tags = {
    Example    = "eks-apigee"
    CreatedBy = "DEMO"
    Org = "example.com"
  }

}
```
Using a terraform.tfvars file
```hcl
  eks_cluster_name = "eks-apigee"
  eks_cluster_version = "1.24"
  eks_node_group_max_size = 7
  eks_node_group_min_size = 1
  eks_node_group_desired_size = 2
  eks_node_group_instance_types = ["m6i.xlarge"]

  k8s_admins = ["eks-user1","eks-user2"]

  vpc_cidr = "10.0.0.0/16"
  tags = {
    Example    = "eks-apigee"
    CreatedBy = "DEMO"
    Org = "example.com"
  }
```