### Requirements

1. Create GCP project that will be used for Apigee config
2. Create a service account with an authentication key. Copy the downloaded JSON file to .auth folder 
3. Install Docker engine in your local environment ( you can skip this part, but you will need to install all required libs defined in the [dockerfile](./docker/Dockerfile) )

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/h-belgacem/eks-apigee.git
   ```
2. For each module main-xxx, create a terraform.tfvars file with the appropriates values.
   Functional examples are included in the README files.
   - [main-eks](./main-eks/README.md)
   - [main-apigee](./main-apigee/README.md)
3. Create a service account key and download the credentials file as JSON
4. Create an '.auth/env' file and add required variables
   ```sh
   ##################################### GCP Credentials ###################
   export PROJECT_ID=poc-apigee # Replace this value
   export PROJECT_NAME=poc-apigee # Replace this value
   export GOOGLE_APPLICATION_CREDENTIALS=/wks/.auth/poc-apigee-44f37e58bac0.json # Replace this value
   export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$GOOGLE_APPLICATION_CREDENTIALS
   export CLOUDSDK_CORE_PROJECT=$PROJECT_ID
   
   ##################################### AWS Credentials ###################
   export AWS_ACCESS_KEY_ID=xxxxxx # Replace this value
   export AWS_SECRET_ACCESS_KEY=xxxxxxxxxx # Replace this value
   export AWS_DEFAULT_REGION=eu-west-3 # Replace this value
   
   ##################################### APIGEE Config ###################
   export APIGEE_VERSION=1.8.3
   export APIGEECTL_HOME=/opt/apigeectl-${APIGEE_VERSION}
   export HYBRID_FILES=${APIGEECTL_HOME}/hybrid-files
   export ENV_GROUP_NAME=poc # Replace this value
   export DOMAIN=apigee.example.com # Replace this value
   export ORG_NAME=$PROJECT_NAME
   ```
5. Setup your local environment 
   ```sh
    # If using docker as dev environment
    make up
    ./terraformd --install
   
   # Or, if using locally installed terraform
   source .auth/env 
    
   ```
6. Install EKS
   ```sh
   # If using docker as dev environment
    terraformd -chdir=main-eks init
    terraformd -chdir=main-eks apply
   
   # Or, if using locally installed terraform
    terraform -chdir=main-eks init
    terraform -chdir=main-eks apply
   ```
7. Install and configure Apigee runtime (if not using docker as dev environment, replace `terraformd` with `terraform`)
   ```sh
    # If using docker as dev environment
    terraformd -chdir=main-apigee init
    terraformd -chdir=main-apigee apply
   
   # Or, if using locally installed terraform
    terraform -chdir=main-apigee init
    terraform -chdir=main-apigee apply
   
   ```
8. Update the apigee domain name by creating a new CNAME record with the AWS LB DNS as value