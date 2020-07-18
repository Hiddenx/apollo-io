# k8s-helloworld GKE + Terraform

### k8s-helloworld app
This hello-world app has 2 endpoints:
- '/' which displays an "Hello World!" message with the name of the pod it runs
    into and its current version. It also performs heavy computations every time it is accessed.
- '/health' which provides a basic health check

##### Installation

This application is a Python app. It runs smoothly in Python 3.5 and Python 2.7.
To run it, you will need to install its dependencies first:
```
pip install -r ./requirements.txt
```
Then you will be able to launch it:
```
python ./app.py
```
By default, the app listens on port *5000*.

# Deploy

### Prerequisites
- Google Cloud Platform account, create one [here](https://cloud.google.com/free)
- Setup [gcloud](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup), [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) on your local machine.

### Launch GKE Infra using Terraform
Make sure you have your [Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts) configured to let terraform create resources on your behalf.
```
cd <project-repo>/terraform
terraform init
terraform apply
```
The above terraform should start launching below resources - 
1. GKE Cluster
2. nodepool for GKE

### Build image and push it to GCR

- Start by building the docker image `docker build -t .`
- Make sure you have push and pull permissions to GCR. [Setup Instructions](https://cloud.google.com/container-registry/docs/pushing-and-pulling)
- Tag your image `docker tag k8s-helloworld gcr.io/<-GCP-PROJECT-ID>/k8s-helloworld`
- Finally push your image `docker push gcr.io/apollo-io/k8s-helloworld`

### Deploy GKE Manifests

- Create a reserved static IP for your service `gcloud compute addresses create <address-name> --global`
- To find the static IP address you created, run the following command: `gcloud compute addresses describe <address-name> --global`
- Note down the static IP Address, output should be similar to --
```
address: x.x.x.x
... 
```
- Replace all .yml files in `gke/manifests` having this `<project-id>.<addresses>.xip.io` with your GCP project-id and the address we just noted down in the earlier step.
- Run `kubectl apply -f aio.yml` creates deployment, service, hpa components for k8s-helloworld app.
- Run `kubectl apply -f managed-cert.yml` to create Google-managed SSL certificate for your service.
- Run `kubectl apply -f ingress.yml`
- Run `kubectl get ingress`, you should see your ingress with the service endpoint in HOSTS field.
```
~ ❯ kubectl get ing
NAME                     HOSTS                          ADDRESS   PORTS   AGE
k8s-helloworld-ingress   <gcp-project-id>.<ip>.xip.io             80      72m
```
- Now try to resolve this URL on your favorite browser with HTTPS - `<gcp-project-id>.<ip>.xip.io`
