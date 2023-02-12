<!-- BEGIN_TF_DOCS -->
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

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks_cluster_name](#input_eks_cluster_name) | Target EKS cluster name | `string` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks_cluster_version](#input_eks_cluster_version) | Target EKS cluster version | `string` | n/a | yes |
| <a name="input_eks_node_group_desired_size"></a> [eks_node_group_desired_size](#input_eks_node_group_desired_size) | Minimum number of nodes. Will be applied to runtime and data pools | `number` | n/a | yes |
| <a name="input_eks_node_group_instance_types"></a> [eks_node_group_instance_types](#input_eks_node_group_instance_types) | Nodes types, must be a valid aws VM type and available in the selected region. | `list(string)` | n/a | yes |
| <a name="input_eks_node_group_max_size"></a> [eks_node_group_max_size](#input_eks_node_group_max_size) | Maximum number of nodes. Will be applied to runtime and data pools | `number` | n/a | yes |
| <a name="input_eks_node_group_min_size"></a> [eks_node_group_min_size](#input_eks_node_group_min_size) | Minimum number of nodes. Will be applied to runtime and data pools | `number` | n/a | yes |
| <a name="input_k8s_admins"></a> [k8s_admins](#input_k8s_admins) | List of k8s admins, must be iam users. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Global tags that will be added to all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr) | VPC CIDR block. | `string` | n/a | yes |
| <a name="input_kms_admin_identity"></a> [kms_admin_identity](#input_kms_admin_identity) | Kms user identity | `string` | `"root"` | no |
| <a name="input_kms_user_identity"></a> [kms_user_identity](#input_kms_user_identity) | Kms user identity | `string` | `"root"` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->