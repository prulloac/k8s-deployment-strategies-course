# Deployment Strategies Mini-Course

## About Kubernetes

We use kubernetes as 


## Starting Minikube

Using a Linux system with `docker` and `kubectl` installed, we can start a local kubernetes cluster using `minikube`.

For this, a convenience script is provided in the `scripts` directory. This script will start a local kubernetes cluster using `minikube` and `docker` as the container runtime.

```bash
# Start the local kubernetes cluster
./scripts/run-local-cluster.sh
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

## Deploying the Application

To deploy the application to the local kubernetes cluster, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/bigbang-deployment.yaml
```

This will create a deployment for the application and expose it as a service. You can check the status of the deployment using the following command:

```bash
# Check the status of the deployment --all-namespaces
kubectl get deployments --all-namespaces
```

This should show you the status of the deployment and the number of replicas that are running. You can also check the status of the pods using the following command:

```bash
# Check the status of the pods --all-namespaces
kubectl get pods --all-namespaces
```

## Strategies

### Big Bang Deployment

To deploy the big bang deployment, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/bigbang-deployment.yaml
```

### Rolling Update Deployment

To deploy the rolling update deployment, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/rolling-update-deployment.yaml
```

### Blue-Green Deployment

To deploy the blue-green deployment, we can use the `kubectl` command line tool. The deployment files are located in the `api` directory. The deployment files are in the `yaml` format and can be applied to the kubernetes cluster using the following command:

```bash
# Deploy the application to the local kubernetes cluster
kubectl apply -f api/blue-green-deployment.yaml
```

