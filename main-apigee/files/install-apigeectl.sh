# exit when any command fails
set -e

################################
# Install apigeectl
################################
curl -L https://storage.googleapis.com/apigee-release/hybrid/apigee-hybrid-setup/${APIGEE_VERSION}/apigeectl_linux_64.tar.gz -o apigeectl_linux_64.tar.gz
tar xvzf apigeectl_linux_64.tar.gz
rm -f apigeectl_linux_64.tar.gz

mv apigeectl_${APIGEE_VERSION}-*_linux_64 $APIGEECTL_HOME
mkdir -p $HYBRID_FILES/{overrides,certs}

cp $APIGEECTL_HOME/apigeectl /usr/local/bin/apigeectl
apigeectl version

ln -s $APIGEECTL_HOME/tools $HYBRID_FILES/tools
ln -s $APIGEECTL_HOME/config $HYBRID_FILES/config
ln -s $APIGEECTL_HOME/templates $HYBRID_FILES/templates
ln -s $APIGEECTL_HOME/plugins $HYBRID_FILES/plugins