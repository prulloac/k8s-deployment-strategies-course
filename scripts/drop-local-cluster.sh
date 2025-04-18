#!/bin/bash

# This script is used to delete the Minikube cluster
# and clean up the environment for local development.
# It also stops the API server.
# Check if Minikube is installed

if ! minikube version
then
    echo "Minikube could not be found. Please install Minikube first."
    exit
fi

# Check if Minikube is running
if minikube status | grep -q "Running"
then
    echo "Stopping Minikube..."
    minikube stop
fi

# Delete the Minikube cluster
echo "Deleting Minikube cluster..."
minikube delete

