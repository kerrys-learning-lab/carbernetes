#! /bin/bash

NAMESPACE=argocd
SECRET=argocd-initial-admin-secret

B64_PASSWORD=$(kubectl -n ${NAMESPACE} get secrets ${SECRET} --template='{{ .data.password }}')

echo ${B64_PASSWORD} | base64 -d
echo
