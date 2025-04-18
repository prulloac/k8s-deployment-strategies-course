#!/bin/bash

# This script is used to start the API server
# and the Minikube cluster for local development.
# It also sets up the environment for the API server.

# Check if Minikube is installed
if ! minikube version
then
    echo "Minikube could not be found. Please install Minikube first."
    exit
fi

# Check if Minikube is running
if ! minikube status | grep -q "Running"
then
    echo "Starting Minikube..."
    minikube start
fi

# Connect to the Minikube cluster
echo "Connecting to Minikube cluster..."
minikube tunnel
