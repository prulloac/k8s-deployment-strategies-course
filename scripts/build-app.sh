#!/bin/bash

# This script builds the app from the source code.

docker build -t myapp:v1 --build-arg TEXT="Custom Landing Text V1" --build-arg VERSION="v1" api/app
docker build -t myapp:v2 --build-arg TEXT="Custom Landing Text V2" --build-arg VERSION="v2" api/app

# Check if Minikube is running
if ! minikube status | grep -q "Running"
then
    echo "Minikube is not running. Please start Minikube to load the images."
    exit 0
fi

# Load the images into Minikube
minikube image load myapp:v1
minikube image load myapp:v2

# Check if the images are loaded
if ! minikube ssh -- docker images | grep -q "myapp"
then
    echo "Failed to load images into Minikube."
    exit 1
fi
echo "Images loaded into Minikube successfully."

