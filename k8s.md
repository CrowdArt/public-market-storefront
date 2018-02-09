# Kubernetes infrastructure

## Development

### Run local k8s cluster
1. Install `minikube`: https://github.com/kubernetes/minikube
2. Start k8s cluster:
`minikube start --vm-driver=vmwarefusion`
or `minikube start --vm-driver=virtualbox`

### Build application
1. Switch docker host: `eval $(minikube docker-env)`
2. Build app image in kubernetes docker host: `docker build -t spree-web:v1 ./config/deploy`
