#!/usr/bin/env bash
set -e

RG="CloudChallenge"
AKS="aks-challenge"
ACR="CloudChallengeACR"
IMAGE="$ACR.azurecr.io/demo-site:v1"

echo "Logging into ACR"
az acr login -n "$ACR"

echo "Building and pushing image"
az acr build --registry "$ACR" --image demo-site:v1 .

echo "Getting AKS credentials"
az aks get-credentials -g "$RG" -n "$AKS" --overwrite-existing

echo "Deploying to AKS"
sed "s|IMAGE_REPLACE|$IMAGE|g" site-deploy.yaml | kubectl apply -f -

echo "Done"
