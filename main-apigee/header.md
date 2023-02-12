# Description

This module allows easy installation of Apigee runtime modules on EKS cluster.

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
If you haven't
## Usage

Basic usage of this module is as follows:

```hcl
module "apigee" {
  source        = "./"

  eks_cluster_name        = "eks-apigee"
  eks_cluster_region      = "apigee_config_path"
  gcp_project_name        = "apigee-poc"
  apigee_analytics_region = "europe-west1"
  apigee_domain_suffix    = "example.com"
  apigee_environments     = [
    {
      name  = "demo"
      group = "poc"
    }
  ]

}
```

Using a terraform.tfvars file

```hcl
  eks_cluster_name        = "eks-apigee"
  eks_cluster_region      = "apigee_config_path"
  gcp_project_name        = "apigee-poc"
  apigee_analytics_region = "europe-west1"
  apigee_domain_suffix    = "example.com"
  apigee_environments     = [
    {
      name  = "demo"
      group = "poc"
    }
  ]
```