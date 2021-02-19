Please follow the live for an explanation of the case study. [document](https://docs.google.com/document/d/17OwlITE-yPWNj3Vi5RtQfz3ItvSkOfnbaVMnzlZyGTg)

This Project uses a cask flask application to implement a CI/CD pipeline.

The infrastructure added.

Dockerfile: Containerizes the flask application with it's Python requirements.

Kubernetes.yml: Creates the kubernetes cluster and deployment to be implemented on Minikube.

Jenkinsfile: This is the CI/CD pipeline. For this project Jenkins is running in a Docker container and deploying the application to a Linux computer running Minikube, Kubernetes, Docker, ...

Steps not visible in the Jenkinsfile involve:
1. Setting up credentials in Jenkins for GitHub, DockerHub and SSH.
2. SSH is used to deploy the application to the Linux client/computer running the MiniKube cluster.A secret key has to be created in the Docker container and propigated to the Linux computer. To learn more about the permissions required see. A good link to point you in the right direction. (https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04)
