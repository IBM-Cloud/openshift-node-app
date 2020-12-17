#!/bin/bash

set -e
set -u
set -o pipefail

if [[ -z "$MYPROJECT" ]]; then
  echo "Application name cannot be empty"
fi

if [[ -z "$MYREGISTRY" ]]; then
  echo "Container registry cannot be empty"
fi

if [[ -z "$GIT_TOKEN_USERNAME" || -z "$GIT_TOKEN_PASSWORD" ]]; then
  echo "Git(Private) token cannot be empty"
fi

if [[ -z "$REPO_URL_WITHOUT_HTTPS" ]]; then
  echo "Git(Private) repo URL cannot be empty"
fi

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