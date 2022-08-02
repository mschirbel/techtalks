#!/bin/bash

helm upgrade --install \
  -f chart/values.yaml \
  --namespace istiodemo \
  --create-namespace \
  --set currentDeployment.weight=0 \
  --set canaryDeployment.weight=100 \
  istiodemo chart/
