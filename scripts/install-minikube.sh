#!/bin/bash

# This script is used to install Minikube on a Linux system.


# It downloads the latest version of Minikube and installs it.
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

sudo chown -R $USER $HOME/.minikube; chmod -R u+wrx $HOME/.minikube

# Test if Minikube is installed correctly
minikube version
# Check if Minikube is running
minikube status