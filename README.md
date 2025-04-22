# Deployment Strategies Mini-Course

## About Kubernetes

We use kubernetes as the container orchestration platform for deploying and managing our applications. Kubernetes is an open-source platform that automates the deployment, scaling, and management of containerized applications. It provides a robust set of features for managing containers, including load balancing, service discovery, and self-healing.

## Prerequisites

To run the code in this repository, you will need to have the following software installed on your system:

- Docker
- kubectl
- Minikube

## Starting Minikube

Using a Linux system with `docker` and `kubectl` installed, we can start a local kubernetes cluster using `minikube`.

For this, a convenience script is provided in the `scripts` directory. This script will start a local kubernetes cluster using `minikube` and `docker` as the container runtime.

```bash
# Start the local kubernetes cluster
sh scripts/run-local-cluster.sh
```

After running this script, you should have a local kubernetes cluster running on your system. You can check the status of the cluster using the following command:

```bash
# Check the status of the local kubernetes cluster
kubectl cluster-info
```
This should show you the URL of the kubernetes API server and the kubernetes dashboard. You can access the dashboard using the following command:

```bash
# Access the kubernetes dashboard
minikube dashboard
```

This will open the kubernetes dashboard in your default web browser. You can use the dashboard to manage your kubernetes cluster and view the status of your pods, services, and other resources.

## Building the Application

To build the application, there is a convenience script provided in the `scripts` directory. This script will build the docker image for the application and tag it with the proper version.

```bash
# Build the docker image for the application
sh scripts/build-app.sh
```

This will build the docker image for the application and tag it with the proper version. You can check the status of the docker image using the following command:

```bash
# Check the status of the docker image
docker images
```

Also, if minikube cluster is running, this will automatically push the image to the local minikube docker registry.

## Deploying the Application

Before deploying the application, we need to make sure that the local kubernetes cluster is running and that the docker image for the application is built and tagged with the proper version.

After that, we first create the kubernetes namespace for the application. This is done using the `kubectl` command line tool. The namespace is defined in the `api` directory in the `namespace.yaml` file.

```bash
# Create the kubernetes namespace for the application
kubectl apply -f api/namespace.yaml
```

### Big Bang Deployment

To deploy the big bang deployment, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/bigbang-deployment.yaml
```

We can check the status of the deployment using Minikube dashboard or using the following command:

```bash
# Check the status of the deployment
kubectl get pods -n sample
```

Now we need to enable the ingress service to access the application. This is done using the `kubectl` command line tool. The ingress service is defined in the `api` directory in the `basic-ingress.yaml` file.

```bash
# Enable the ingress service
kubectl apply -f api/basic-ingress.yaml
```

We can check the status of the ingress service using the following command:

```bash
# Check the status of the ingress service
kubectl get service -n sample
```

This should enable the application to be accessed using localhost:80, which is the default port for HTTP traffic. You can access the application using the following URL:

```bash
# Access the application using the ingress service
http://localhost:80
```

### Rolling Update Deployment

To deploy the rolling update deployment, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/rolling-deployment.yaml
```

Since this deployment uses the same deployment name as the big bang deployment, the rolling update deployment will replace the big bang deployment. We can check the status of the deployment using Minikube dashboard or using the following command:

```bash
# Check the status of the deployment
kubectl get pods -n sample
```

This will also enable the application to be accessed using the same service as the big bang deployment. You can access the application using the following URL:

```bash
# Access the application using the ingress service
http://localhost:80
```

### Blue-Green Deployment

For this deployment, we will delete the previous deployments and create a new deployment using the blue-green deployment strategy. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Delete the previous deployments
kubectl delete -f api/rolling-deployment.yaml

# Delete the ingress service
kubectl delete -f api/basic-ingress.yaml
```

Now we can proceed to create the blue-green deployment. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/blue-green-deployment.yaml
```

We can check the status of the deployment using Minikube dashboard or using the following command:

```bash
# Check the status of the deployment
kubectl get pods -n sample
```

We now need to modify the ingress service to point to the blue deployment. We can achieve this by modifying the `basic-ingress.yaml` file to point to the blue deployment. The ingress service is defined in the `api` directory in the `basic-ingress.yaml` file.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-service
  namespace: sample
spec:
  selector:
    app: blue-sample
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: LoadBalancer
```	

This will enable the application to be accessed using the same service as the big bang deployment. If we use the health check endpoint, we can see that the application is running on the green deployment.

```bash
# Access the application using the ingress service
curl -X GET -H "Content-Type: application/json" http://localhost:80/health
```

After that, we can switch the ingress service to point to the green deployment. We can achieve this by modifying the `basic-ingress.yaml` file to point to the blue deployment. The ingress service is defined in the `api` directory in the `basic-ingress.yaml` file.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-service
  namespace: sample
spec:
  selector:
    app: green-sample
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: LoadBalancer
```

After updating the yaml file, we can apply the changes using the following command:

```bash
# Apply the changes to the ingress service
kybectl replace -f api/basic-ingress.yaml
```

This will enable the application to be accessed using the same service as the big bang deployment. If we use the health check endpoint, we can see that the application is running on the green deployment.

```bash
# Access the application using the ingress service
curl -X GET -H "Content-Type: application/json" http://localhost:80/health
```

### Canary Deployment

For this last deployment, we will delete the previous deployments and create a new deployment using the canary deployment strategy. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Delete the previous deployments
kubectl delete -f api/blue-green-deployment.yaml

# Delete the ingress service
kubectl delete -f api/basic-ingress.yaml
```

Now we will use a new kind of service called a `Gateway` to route traffic to the canary deployment. To enable gateway, we need to install the `gateway-api` controller. This can be done using the following command:

```bash
# Install the gateway-api controller
sh scripts/install-gateway-api.sh
```

This will install an NGINX ingress controller and a gateway-api controller. We can check the status of the installation using the following command:

```bash
# Check the status of the installation
kubectl get pods -n nginx-gateway
```

Now we can proceed to create the canary deployment. For this, we will use the `canary-deployment.yaml` file. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/canary-deployment.yaml
```

We can check the status of the deployment using Minikube dashboard or using the following command:

```bash
# Check the status of the deployment
kubectl get pods -n sample
```

Now what is left is to create the gateway service. The gateway service is defined in the `api` directory in the `gateway.yaml` file.

```bash
# Deploy the gateway service to the local kubernetes cluster
kubectl apply -f api/gateway.yaml
```

We can check the status of the gateway service using the following command:

```bash
# Check the status of the gateway service
kubectl get gateway -n sample
```

For testing the canary deployment, we can use the following command:

```bash
# Access the application using the ingress service
curl --resolve sample.usach.com:80:127.0.0.1 -X GET -H "Content-Type: application/json" http://sample.usach.com:80/health
```

The canary deployment will route 20% of the traffic to the canary deployment and 80% of the traffic to the stable deployment. If we want to change the weights, we can modify the `gateway.yaml` file to change the weights of the canary deployment. Remember that the weights are defined in the `backendRefs` section of the `gateway.yaml` file, and that after modifying the file, we need to apply the changes using the following command:

```bash
# Apply the changes to the gateway service
kubectl replace -f api/gateway.yaml
```

After applying the changes, we can perform further requests to the application and see which deployment was used to serve the request.

## Destroying the Local Cluster

To destroy the local kubernetes cluster, we can use the `minikube` command line tool. Luckily, the convenience script provided in the `scripts` directory will take care of this for us. This script will destroy the local kubernetes cluster and remove all the resources created by the script.

```bash
# Destroy the local kubernetes cluster
sh scripts/drop-local-cluster.sh
```

