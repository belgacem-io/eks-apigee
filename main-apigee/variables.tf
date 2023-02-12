variable "eks_cluster_name" {
  description = "Target EKS cluster name"
  type =  string
}

variable "eks_cluster_region" {
  description = "Target EKS cluster region"
  type =  string
}

variable "gcp_project_name" {
  description = "GCP project name"
  type =  string
}

variable "apigee_analytics_region" {
  description = "Primary GCP region for analytics data storage"
  type =  string
}

variable "apigee_env_type" {
  description = "The target apigee environment type, supported values : non-prod, prod"
  type =  string
  default = "non-prod"
}


variable "apigee_domain_suffix" {
  description = "Suffix for apigee domain"
  type = string
}

variable "apigee_environments" {
  description = "List of apigee envs to create"
  type = list(object({
    name  = string
    group = string
  }))
}