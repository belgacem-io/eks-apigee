data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

data "google_client_config" "current" {}

locals {
  service_account_name       = "apigee-${var.apigee_env_type}"
  service_account_creds_path = "${data.external.env.result["HYBRID_FILES"]}/service-accounts/${var.gcp_project_name}-${local.service_account_name}.json"
  ssl_cert_base_path         = "${data.external.env.result["HYBRID_FILES"]}/certs"
  apigee_config_path         = "${data.external.env.result["HYBRID_FILES"]}/overrides/overrides.yaml"
  org_name                   = var.gcp_project_name
}
##############################################################################################################
#                    Part 1: Project and org setup
##############################################################################################################
resource "google_project_service" "precog-enableapi" {
  for_each = toset([
    "apigee.googleapis.com",
    "apigeeconnect.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "pubsub.googleapis.com"
  ])

  service = each.value
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = true
}

resource "google_apigee_organization" "precog-provision" {
  display_name     = local.org_name
  analytics_region = var.apigee_analytics_region
  project_id       = data.google_client_config.current.project
  runtime_type     = "HYBRID"
  depends_on       = [
    google_project_service.precog-enableapi
  ]
}

resource "google_apigee_environment" "precog-add-environment" {
  for_each = toset(var.apigee_environments.*.name)

  name         = each.value
  description  = "Apigee Environment ${each.value}"
  display_name = "Environment ${each.value}"
  org_id       = google_apigee_organization.precog-provision.id

  depends_on = [
    google_apigee_organization.precog-provision
  ]
}

resource "google_apigee_envgroup" "precog-add-environment" {
  for_each = toset(var.apigee_environments.*.group)

  name      = each.value
  hostnames = ["${each.value}.${var.apigee_domain_suffix}"]
  org_id    = google_apigee_organization.precog-provision.id

  depends_on = [
    google_apigee_environment.precog-add-environment
  ]
}

resource "google_apigee_envgroup_attachment" "precog-add-environment" {
  for_each = {for env in var.apigee_environments : env.name => env}

  envgroup_id = google_apigee_envgroup.precog-add-environment[each.value.group].id
  environment = google_apigee_environment.precog-add-environment[each.value.name].name

  depends_on = [
    google_apigee_envgroup.precog-add-environment,
    google_apigee_environment.precog-add-environment
  ]
}

##############################################################################################################
#                    Part 2: Hybrid runtime setup
##############################################################################################################
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.7.3"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "null_resource" "install-apigeectl" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/files/install-apigeectl.sh"
  }
  depends_on = [
    helm_release.cert-manager
  ]
}


module "gcp-service-account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2"

  project_id    = data.google_client_config.current.project
  display_name  = local.service_account_name
  names         = [local.service_account_name]
  generate_keys = true
  project_roles = [
    "${data.google_client_config.current.project}=>roles/apigee.admin",
    "${data.google_client_config.current.project}=>roles/apigee.analyticsAgent",
    "${data.google_client_config.current.project}=>roles/apigee.runtimeAgent",
    "${data.google_client_config.current.project}=>roles/apigee.synchronizerManager",
    "${data.google_client_config.current.project}=>roles/apigeeconnect.Agent",
    "${data.google_client_config.current.project}=>roles/logging.logWriter",
    "${data.google_client_config.current.project}=>roles/monitoring.metricWriter",
    "${data.google_client_config.current.project}=>roles/storage.objectAdmin",
  ]
}

resource "local_file" "gcp-service-account-key" {
  content  = module.gcp-service-account.keys[local.service_account_name]
  filename = local.service_account_creds_path
}


# Run the script to get the environment variables of interest.
# This is a data source, so it will run at plan time.
data "external" "env" {
  program = ["${path.module}/files/env.sh"]
}

# Creates a private key in PEM format
resource "tls_private_key" "private_key" {
  for_each = toset(var.apigee_environments.*.group)

  algorithm = "RSA"
}

# Generates a TLS self-signed certificate using the private key
resource "tls_self_signed_cert" "tls_certs" {
  for_each = toset(var.apigee_environments.*.group)

  private_key_pem       = tls_private_key.private_key[each.key].private_key_pem
  validity_period_hours = 3650
  subject {
    # The subject CN field here contains the hostname to secure
    common_name = "*.${var.apigee_domain_suffix}"
  }
  allowed_uses = ["key_encipherment", "digital_signature", "server_auth"]
}

resource "local_file" "keystore_key" {
  for_each = toset(var.apigee_environments.*.group)

  content  = tls_private_key.private_key[each.key].private_key_pem
  filename = "${local.ssl_cert_base_path}/keystore_${each.key}.key"
}

resource "local_file" "keystore_cert" {
  for_each = toset(var.apigee_environments.*.group)

  content  = tls_self_signed_cert.tls_certs[each.key].cert_pem
  filename = "${local.ssl_cert_base_path}/keystore_${each.key}.pem"
}


resource "local_file" "apigee-config-overrides" {
  for_each = {for env in var.apigee_environments : env.name => env}

  content = templatefile("${path.module}/files/overrides.yaml", {
    ANALYTICS_REGION           = var.apigee_analytics_region
    GCP_PROJECT_ID             = data.google_client_config.current.project
    CLUSTER_NAME               = var.eks_cluster_name
    CLUSTER_LOCATION           = var.eks_cluster_region
    ORG_NAME                   = var.gcp_project_name
    UNIQUE_INSTANCE_IDENTIFIER = "${local.org_name}-${each.value.group}-${each.value.name}"
    ENVIRONMENT_GROUP_NAME     = each.value.group
    SSL_CERT_PATH              = "${local.ssl_cert_base_path}/keystore_${each.value.group}.pem"
    SSL_KEY_PATH               = "${local.ssl_cert_base_path}/keystore_${each.value.group}.key"
    INGRESS_NAME               = "ingress-${var.gcp_project_name}"
    ENVIRONMENT_NAME           = each.value.name
    SVC_ACCOUNT_PATH           = local.service_account_creds_path
  }
  )
  filename = local.apigee_config_path
}


resource "null_resource" "install-hybrid-runtime" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/files/gcp-install-hybrid-runtime.sh"
  }
  depends_on = [
    helm_release.cert-manager,
    local_file.apigee-config-overrides
  ]
}

resource "kubernetes_manifest" "install-expose-apigee-ingress" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata"   = {
      "name"      = local.org_name
      "namespace" = "apigee"
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "status-port"
          "port"       = 15021
          "protocol"   = "TCP"
          "targetPort" = 15021
        }, {
          "name"       = "https"
          "port"       = 443
          "protocol"   = "TCP"
          "targetPort" = 8443
        }
      ]
      "selector" = {
        "app"          = "apigee-ingressgateway" #required
        "ingress_name" = "ingress-${var.gcp_project_name}"
        "org"          = local.org_name
      }
      "type" = "LoadBalancer"
    }
  }
}

resource "google_apigee_sync_authorization" "apigee_sync_authorization" {
  name       = google_apigee_organization.precog-provision.name
  identities = [
    "serviceAccount:${module.gcp-service-account.email}",
  ]
  depends_on = [module.gcp-service-account]
}