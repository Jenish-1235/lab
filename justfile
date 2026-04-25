#!/usr/bin/env -S just --list
cluster_name := "lab"
kind_config := "kind/kind-config.yaml"

cluster-create:
    kind create cluster --name {{cluster_name}} --config {{kind_config}}

cluster-delete:
    kind delete cluster --name {{cluster_name}}

cluster-recreate: cluster-delete cluster-create

apply-all:
    kubectl apply -f ingress/nginx-ingress.yaml
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
    kubectl apply -f kite/

apply-ingress:
    kubectl apply -f ingress/nginx-ingress.yaml

apply-kite:
    kubectl apply -f kite/

hosts:
    echo "127.0.0.1 kite.local" | sudo tee -a /etc/hosts