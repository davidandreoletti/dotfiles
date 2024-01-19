f_minikube_defaultConfig() {
    # Default minikube config
    minikube config set memory 3072
    minikube config set vm-driver hyperkit
    minikube config set cpus 2
}
