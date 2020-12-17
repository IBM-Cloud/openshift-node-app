#!/bin/bash

set -e
set -u
set -o pipefail

# Script to generate a secret
generate_secret() {
    PASS_LENGTH=20
    local secret=`openssl rand -base64 48 | cut -c1-$PASS_LENGTH`
    echo $secret
}

cat openshift.template.yaml | \
  MYPROJECT=$MYPROJECT \
  MYREGISTRY=$MYREGISTRY \
  GIT_TOKEN_USERNAME=$GIT_TOKEN_USERNAME \
  GIT_TOKEN_PASSWORD=$GIT_TOKEN_PASSWORD \
  REPO_URL_WITHOUT_HTTPS=$REPO_URL_WITHOUT_HTTPS \
  SECRET_GITHUB=$(generate_secret) \
  SECRET_GENERIC=$(generate_secret) \
  envsubst > openshift.yaml
  #| \
  #oc apply -f - || exit 1