#!/bin/bash

set -e
set -u
set -o pipefail

if [[ -z "$MYPROJECT" ]]; then
    echo "Application name cannot be empty"
fi

# Script to generate a secret
generate_secret() {
    PASS_LENGTH=20
    local secret=`openssl rand -base64 48 | cut -c1-$PASS_LENGTH`
    echo $secret
}

use_private_registry() {
    echo "Generating YAML for private container registry..."
    if [[ -z "$MYREGISTRY" ]]; then
        echo "Container registry cannot be empty"
    fi
    if [[ -z "$MYNAMESPACE" ]]; then
        echo "Registry namespace cannot be empty"
    fi
    
    GIT_REPO_URL="https://github.com/IBM-Cloud/openshift-node-app"
    MYPROJECT="$MYPROJECT-priv-reg"
    
    cat openshift.template.yaml | \
    MYPROJECT=$MYPROJECT \
    MYNAMESPACE=$MYNAMESPACE \
    MYREGISTRY=$MYREGISTRY \
    REPO_URL=$GIT_REPO_URL \
    SECRET_GITHUB=$(generate_secret) \
    SECRET_GENERIC=$(generate_secret) \
    envsubst > openshift_private_registry.yaml
    #| \
    #oc apply -f - || exit 1

    echo 'export MYPROJECT="$MYPROJECT-priv-reg"'
}

use_private_repository() {
     echo "Generating YAML for private Gitlab repository and private container registry..."
    if [[ -z "$GIT_TOKEN_USERNAME" || -z "$GIT_TOKEN_PASSWORD" ]]; then
        echo "Git(Private) token cannot be empty"
    fi
    
    if [[ -z "$REPO_URL" ]]; then
        echo "Git(Private) repo URL cannot be empty"
    fi
    # Check for HTTPS and replace with empty string
    REPO_URL=${REPO_URL/https:\/\//}
    
    # Check for `.git` in the end
    # Get the repo name
    REPO_NAME="$(cut -d'/' -f3 <<<"$REPO_URL")"
    SUB='.git'
    if [[ "$REPO_NAME" != *"$SUB"* ]]; then
        REPO_URL=${REPO_URL}${SUB}
    fi
    
    MYPROJECT="$MYPROJECT-repo"
    GIT_REPO_URL="https://$GIT_TOKEN_USERNAME:$GIT_TOKEN_PASSWORD@$REPO_URL"

    cat openshift.template.yaml | \
    MYPROJECT=$MYPROJECT \
    MYNAMESPACE=$MYNAMESPACE \
    MYREGISTRY=$MYREGISTRY \
    GIT_TOKEN_USERNAME=$GIT_TOKEN_USERNAME \
    GIT_TOKEN_PASSWORD=$GIT_TOKEN_PASSWORD \
    REPO_URL=$GIT_REPO_URL \
    SECRET_GITHUB=$(generate_secret) \
    SECRET_GENERIC=$(generate_secret) \
    envsubst > openshift_private_repository.yaml
    #| \
    #oc apply -f - || exit 1

    echo 'export MYPROJECT="$MYPROJECT-repo"'
}

$1