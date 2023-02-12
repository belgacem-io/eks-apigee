eks_cluster_name        = "ex-apigee"
eks_cluster_region      = "apigee_config_path"
gcp_project_name        = "poc-vicat"
apigee_analytics_region = "europe-west1"
apigee_domain_suffix    = "vicat.oneskill.ovh"
apigee_environments     = [
  {
    name  = "demo"
    group = "poc"
  }
]