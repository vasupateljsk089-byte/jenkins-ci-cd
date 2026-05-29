#!/bin/bash

# Usage:

# bash update-env.sh <namespace> <ingress-name> <env-file> <env-variable> [optional-path]

NAMESPACE=$1
INGRESS_NAME=$2
ENV_FILE=$3
ENV_VARIABLE=$4
APP_PATH=${5:-}

# Fetch ALB DNS

ALB_DNS=$(kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Validate ALB DNS

if [ -z "$ALB_DNS" ]; then
echo "ERROR: ALB DNS not found"
exit 1
fi

# Remove trailing slash from APP_PATH if accidentally passed

APP_PATH=$(echo "$APP_PATH" | sed 's:/*$::')

# Construct final URL

NEW_URL="http://${ALB_DNS}${APP_PATH}"

# Validate env file exists

if [ ! -f "$ENV_FILE" ]; then
echo "ERROR: Env file not found -> $ENV_FILE"
exit 1
fi

# Update env variable safely

sed -i "s|^${ENV_VARIABLE}=.*|${ENV_VARIABLE}="${NEW_URL}"|g" "$ENV_FILE"

echo "Updated ${ENV_VARIABLE} with:"
echo "${NEW_URL}"
