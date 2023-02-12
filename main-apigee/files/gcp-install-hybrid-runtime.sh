# exit when any command fails
set -e

# get your eks authentication credentials
aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ex-apigee

cd ${APIGEECTL_HOME}
# Do a dry run initialization
apigeectl init -f ${HYBRID_FILES}/overrides/overrides.yaml --dry-run=client

# Run initialization
apigeectl init -f ${HYBRID_FILES}/overrides/overrides.yaml

# check the status of the deployment
apigeectl check-ready -f ${HYBRID_FILES}/overrides/overrides.yaml

# Do a dry run install.
apigeectl apply -f ${HYBRID_FILES}/overrides/overrides.yaml --dry-run=client

# Run install
apigeectl apply -f ${HYBRID_FILES}/overrides/overrides.yaml

#check the status of the deployment
apigeectl check-ready -f ${HYBRID_FILES}/overrides/overrides.yaml