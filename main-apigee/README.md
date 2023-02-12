<!-- BEGIN_TF_DOCS -->
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

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigee_analytics_region"></a> [apigee_analytics_region](#input_apigee_analytics_region) | Primary GCP region for analytics data storage | `string` | n/a | yes |
| <a name="input_apigee_domain_suffix"></a> [apigee_domain_suffix](#input_apigee_domain_suffix) | Suffix for apigee domain | `string` | n/a | yes |
| <a name="input_apigee_environments"></a> [apigee_environments](#input_apigee_environments) | List of apigee envs to create | <pre>list(object({<br>    name  = string<br>    group = string<br>  }))</pre> | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks_cluster_name](#input_eks_cluster_name) | Target EKS cluster name | `string` | n/a | yes |
| <a name="input_eks_cluster_region"></a> [eks_cluster_region](#input_eks_cluster_region) | Target EKS cluster region | `string` | n/a | yes |
| <a name="input_gcp_project_name"></a> [gcp_project_name](#input_gcp_project_name) | GCP project name | `string` | n/a | yes |
| <a name="input_apigee_env_type"></a> [apigee_env_type](#input_apigee_env_type) | The target apigee environment type, supported values : non-prod, prod | `string` | `"non-prod"` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->